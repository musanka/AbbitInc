CREATE PROCEDURE [dbo].[UpdateIdentifier]
    @EntityID BIGINT = NULL,
    @IdentifierID BIGINT = NULL,
    @Country NVARCHAR(100) = NULL,
    @IdValue NVARCHAR(100) = NULL,
    @IdType NVARCHAR(50) = NULL,
    @UserType NVARCHAR(50) = NULL,
    @Active BIT = NULL,
    @Deleted BIT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();
    DECLARE @return_value INT = 0;  

    BEGIN TRY
        UPDATE [dbo].[Identifier]
        SET
            [Country] = ISNULL(@Country, [Country]),
            [IdValue] = ISNULL(@IdValue, [IdValue]),
            [IdType] = ISNULL(@IdType, [IdType]),
            [Active] = ISNULL(@Active, [Active]),
            [Deleted] = ISNULL(@Deleted, [Deleted])
        WHERE [IdentifierID] = @IdentifierID;

        IF @EntityID IS NOT NULL AND @UserType IS NOT NULL
        BEGIN
            UPDATE [dbo].[IURel]
            SET
                [Active] = ISNULL(@Active, [Active]),
                [Deleted] = ISNULL(@Deleted, [Deleted])
            WHERE [IdentifierID] = @IdentifierID AND [EntityID] = @EntityID AND [UserType] = @UserType;
        END

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. IdentifierID: ', @IdentifierID, '"');

    END TRY
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES(@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
        SET @return_value = -1;
        THROW;  
    END CATCH

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';
        
END
GO
