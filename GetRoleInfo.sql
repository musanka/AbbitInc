CREATE PROCEDURE [dbo].[GetRoleInfo]
(
    @RoleID bigint = null,           -- Optional: Role ID to get a specific role
    @ChangedBy nvarchar(256) = null, -- Optional: Who initiated the request
    @DObj nvarchar(max) = null,      -- Optional: Object data (JSON or other tracking information)
    @CallWebApi nvarchar(200) = null -- Optional: API that made the call
)
AS
BEGIN
    DECLARE @GUID uniqueidentifier;
    SET @GUID = NEWID();

    BEGIN TRY
        IF (@ChangedBy IS NOT NULL AND @DObj IS NOT NULL AND @CallWebApi IS NOT NULL 
            AND TRIM(@ChangedBy) <> '' AND TRIM(@DObj) <> '' AND TRIM(@CallWebApi) <> '')
        BEGIN
            -- If a specific RoleID is provided, return details for that role
            IF (@RoleID IS NOT NULL AND @RoleID <> 0)
            BEGIN
                SELECT 
                    [ID] AS RoleID,        -- Using ID as the primary key
                    [Guid], 
                    [ShortName], 
                    [LongName], 
                    [Description], 
                    [Active], 
                    [Deleted], 
                    [ChangedLast],
                    [ChangedBy]
                FROM [dbo].[Role]
                WHERE [ID] = @RoleID;

                SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
            END
            ELSE
            BEGIN
                -- Return all roles if no specific RoleID is provided
                SELECT 
                    [ID] AS RoleID, 
                    [Guid], 
                    [ShortName], 
                    [LongName], 
                    [Description], 
                    [Active], 
                    [Deleted], 
                    [ChangedLast],
                    [ChangedBy]
                FROM [dbo].[Role];

                SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
            END
        END
        ELSE
        BEGIN
            -- Handle missing parameters
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR."');
            INSERT INTO [dbo].[DbErrors]
                VALUES (@GUID, SUSER_SNAME(), 999, 2, 16, 999, 'GetRoleInfo', CONCAT('NULL or blank parameter. Data - ', @DObj), GETDATE());
        END
    END TRY
    BEGIN CATCH
        -- Handle any errors
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR."');
        INSERT INTO [dbo].[DbErrors]
            VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
    END CATCH

    -- Log the request
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;
END
GO
