CREATE PROCEDURE [dbo].[ResetEmailStatus]
    (
    @EmailID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    IF (@EmailID IS NULL OR @EmailID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid EmailID."');
        RETURN -1;
    END

    IF NOT EXISTS (SELECT 1
    FROM [dbo].[Email]
    WHERE [GID] = @EmailID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Email not found."');
        RETURN -1;
    END

    BEGIN TRY
        UPDATE [dbo].[Email]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [GID] = @EmailID;

        UPDATE [dbo].[EURel]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [GID] = @EmailID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: EmailID: ', @EmailID, '"');
    END TRY
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        RETURN -1;  
    END CATCH;

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

    RETURN 0;  
END;
GO
