CREATE PROCEDURE [dbo].[DeleteIdentifier]
(
    @IdValue NVARCHAR(100) = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IdentifierID BIGINT;

    IF (@IDValue IS NULL OR @IDValue <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid IdentifierID."');
        RETURN -1;  
    END

    SET @IdentifierID = (SELECT IID FROM [dbo].[Identifier] WHERE [IDValue] = @IDValue);
    IF @IdentifierID IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Identifier not found."');
        RETURN -1;
    END
    
    BEGIN TRY
        UPDATE [dbo].[Identifier]
        SET [Deleted] = 1,
            [Active] = 0, 
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [IID] = @IdentifierID;

        UPDATE [dbo].[IURel]
        SET [Deleted] = 1,
            [Active] = 0,
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [IID] = @IdentifierID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Identifier marked as deleted."');
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
