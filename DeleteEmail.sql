CREATE PROCEDURE [dbo].[DeleteEmail]
    @Email BIGINT = NULL, 
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @EmailID NVARCHAR(256) ;

    IF (@Email IS NULL OR @Email <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid Email."');
        RETURN -1;  
    END;

    SET @EmailID = (SELECT GID FROM [dbo].[Email] WHERE [Email] = @Email);
    IF @EmailID IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Address not found."');
        RETURN -1;
    END
    BEGIN TRY
        UPDATE [dbo].[Email]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [GID] = @EmailID;

        UPDATE [dbo].[EURel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [GID] = @EmailID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Email marked as deleted."');
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
