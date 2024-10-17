CREATE PROCEDURE [dbo].[ResetIdentifierStatus]
(
    @IdentifierID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@IdentifierID IS NULL OR @IdentifierID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid IdentifierID."');
        RETURN -1; 
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Identifier] WHERE [IID] = @IdentifierID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Identifier not found."');
        RETURN -1;  
    END

    BEGIN TRY
        UPDATE [dbo].[Identifier]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [IID] = @IdentifierID;

        UPDATE [dbo].[IURel]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [IID] = @IdentifierID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Identifier status reset for IdentifierID: ', @IdentifierID, '"');
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
