CREATE PROCEDURE [dbo].[GetCompanyInfo]
(
    @CompanyID bigint = null,
    @OwnerPersonID bigint = null,
    @IncludeDetails bit = 0,  -- Flag to control detailed info
    @ChangedBy nvarchar(256) = null,
    @DObj nvarchar(max) = null,
    @CallWebApi nvarchar(200) = null
)
AS
BEGIN
    DECLARE @GUID uniqueidentifier;
    SET @GUID = NEWID();

    BEGIN TRY
        IF (@ChangedBy IS NOT NULL AND @DObj IS NOT NULL AND @CallWebApi IS NOT NULL 
            AND TRIM(@ChangedBy) <> '' AND TRIM(@DObj) <> '' AND TRIM(@CallWebApi) <> '')
        BEGIN
            -- If a specific CompanyID is provided, return detailed information for that company
            IF (@CompanyID IS NOT NULL AND @CompanyID <> 0)
            BEGIN
                IF (@IncludeDetails = 1)  -- Include detailed info like owner, address, phone
                BEGIN
                    SELECT 
                        company.[ID], 
                        company.[StartDate], 
                        company.[ShortName], 
                        company.[LongName], 
                        CONCAT(person.[FirstName], ' ', person.[LastName]) AS [Owner], 
                        addr.[Country], 
                        addr.[AddressLine], 
                        phn.[CountryCode], 
                        phn.[PhoneNo], 
                        idn.[IdValue] AS CvrNumber, 
                        company.[Active], 
                        company.[ChangedLast]
                    FROM [dbo].[Company] AS company
                    LEFT JOIN [dbo].[UserNetUserRel] AS unur ON company.[ID] = unur.[UserID] AND unur.[UserType] = 'Company'
                    LEFT JOIN [dbo].[Person] AS person ON unur.[AID] = person.[ID] -- Assuming person as owner
                    LEFT JOIN [dbo].[Address] AS addr ON addr.[ID] = (
                        SELECT aur.[EID] 
                        FROM [dbo].[AURel] AS aur 
                        WHERE aur.[UserID] = company.[ID] AND aur.[UserType] = 'Company' AND aur.[Active] = 1
                    )
                    LEFT JOIN [dbo].[Phone] AS phn ON phn.[ID] = (
                        SELECT pur.[FID] 
                        FROM [dbo].[PURel] AS pur 
                        WHERE pur.[UserID] = company.[ID] AND pur.[UserType] = 'Company' AND pur.[Active] = 1
                    )
                    LEFT JOIN [dbo].[Identifier] AS idn ON idn.[ID] = (
                        SELECT iur.[IID] 
                        FROM [dbo].[IURel] AS iur 
                        WHERE iur.[UserID] = company.[ID] AND iur.[UserType] = 'Company' AND iur.[Active] = 1
                    )
                    WHERE company.[ID] = @CompanyID;
                END
                ELSE
                BEGIN
                    -- Return basic company info
                    SELECT 
                        [ID], 
                        [StartDate], 
                        [ShortName], 
                        [LongName], 
                        [Active], 
                        [ChangedLast]
                    FROM [dbo].[Company]
                    WHERE [ID] = @CompanyID;
                END

                SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
            END
            ELSE IF (@OwnerPersonID IS NOT NULL AND @OwnerPersonID <> 0)
            BEGIN
                -- Return companies owned by a specific person (using UserNetUserRel to link persons and companies)
                SELECT 
                    company.[ID], 
                    company.[StartDate], 
                    company.[ShortName], 
                    company.[LongName], 
                    company.[Active], 
                    company.[ChangedLast]
                FROM [dbo].[Company] AS company
                INNER JOIN [dbo].[UserNetUserRel] AS unur ON company.[ID] = unur.[UserID]
                WHERE unur.[AID] = @OwnerPersonID AND unur.[UserType] = 'Company' AND unur.[Active] = 1;

                SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
            END
            ELSE
            BEGIN
                -- Return all companies
                SELECT 
                    [ID], 
                    [StartDate], 
                    [ShortName], 
                    [LongName], 
                    [Active], 
                    [ChangedLast]
                FROM [dbo].[Company];

                SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
            END
        END
        ELSE
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR."');
            INSERT INTO [dbo].[DbErrors]
                VALUES (@GUID, SUSER_SNAME(), 999, 2, 16, 999, 'GetCompanyInfo', CONCAT('NULL or blank parameter. Data - ', @DObj), GETDATE());
        END
    END TRY
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR."');
        INSERT INTO [dbo].[DbErrors]
            VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
    END CATCH

    EXEC [dbo].[NewLogDB] @WebApi = @CallWebApi, @ObjectData = @DObj, @LogWho = @ChangedBy;
END
GO
