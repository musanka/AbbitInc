CREATE PROCEDURE [dbo].[GetPersonInfo]
(
    @PersonID bigint = null,
    @IncludeDetails bit = 0,  -- New flag to determine if full details should be returned
    @ChangedBy nvarchar(256) = null,
    @DObj nvarchar(max) = null,
    @CallWebApi nvarchar(200) = null
)
AS
BEGIN
    DECLARE @GUID uniqueidentifier;
    SET @GUID = NEWID();

    BEGIN TRY
        IF (@ChangedBy IS NOT NULL AND @DObj IS NOT NULL AND @CallWebApi IS NOT NULL AND 
            TRIM(@ChangedBy) <> '' AND TRIM(@DObj) <> '' AND TRIM(@CallWebApi) <> '')
        BEGIN
            -- Return detailed or summary view based on @IncludeDetails flag
            IF (@PersonID IS NOT NULL AND @PersonID <> 0)
            BEGIN
                IF (@IncludeDetails = 1)
                BEGIN
                    -- Full details including address and phone
                    SELECT person.[ID], person.[BirthDay], person.[FirstName], person.[MiddleName], person.[LastName], 
                           addr.[Country], addr.[AddressLine], 
                           phn.[CountryCode], phn.[PhoneNo], 
                           person.[Active], person.[ChangedLast], person.[ChangedBy]
                    FROM [dbo].[Person] AS person
                    LEFT JOIN [dbo].[AURel] AS aur ON aur.[UserID] = person.[ID] AND aur.[UserType] = 'Person' AND aur.[Active] = 1
                    LEFT JOIN [dbo].[Address] AS addr ON aur.[EID] = addr.[ID]
                    LEFT JOIN [dbo].[PURel] AS pur ON pur.[UserID] = person.[ID] AND pur.[UserType] = 'Person' AND pur.[Active] = 1
                    LEFT JOIN [dbo].[Phone] AS phn ON pur.[FID] = phn.[ID]
                    WHERE person.[ID] = @PersonID;
                END
                ELSE
                BEGIN
                    -- Summary (head) view
                    SELECT person.[ID], person.[FirstName], person.[LastName], 
                           addr.[AddressLine], addr.[Country], 
                           phn.[CountryCode], phn.[PhoneNo], 
                           person.[Active], person.[ChangedLast], person.[ChangedBy]
                    FROM [dbo].[Person] AS person
                    LEFT JOIN [dbo].[AURel] AS aur ON aur.[UserID] = person.[ID] AND aur.[UserType] = 'Person' AND aur.[Active] = 1
                    LEFT JOIN [dbo].[Address] AS addr ON aur.[EID] = addr.[ID]
                    LEFT JOIN [dbo].[PURel] AS pur ON pur.[UserID] = person.[ID] AND pur.[UserType] = 'Person' AND pur.[Active] = 1
                    LEFT JOIN [dbo].[Phone] AS phn ON pur.[FID] = phn.[ID]
                    WHERE person.[ID] = @PersonID;
                END
                SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
            END
            ELSE
            BEGIN
                -- If no PersonID is provided, return all persons
                SELECT person.[ID], person.[BirthDay], person.[FirstName], person.[MiddleName], person.[LastName], 
                       person.[Active], person.[ChangedLast], person.[ChangedBy]
                FROM [dbo].[Person] AS person;

                SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
            END
        END
        ELSE
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR."');
            INSERT INTO [dbo].[DbErrors]
            VALUES (@GUID, SUSER_SNAME(), 999, 2, 16, 999, 'GetPersonInfo', CONCAT('NULL or blank parameter. Data - ', @DObj), GETDATE());
        END
    END TRY
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR."');
        INSERT INTO [dbo].[DbErrors]
        VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
    END CATCH

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';
END
GO
