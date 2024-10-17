CREATE PROCEDURE [dbo].[UpdateAddress]
    @UserID BIGINT = NULL,
    @UserType NVARCHAR(50) = NULL,
    @Address BIGINT = NULL,
    @Country NVARCHAR(100) = NULL,
    @AddressLine NVARCHAR(MAX) = NULL,
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
        UPDATE [dbo].[Address]
        SET
            [Country] = ISNULL(@Country, [Country]),
            [AddressLine] = ISNULL(@AddressLine, [AddressLine]),
            [Active] = ISNULL(@Active, [Active]),
            [Deleted] = ISNULL(@Deleted, [Deleted])
        WHERE [AddressID] = @AddressID;

        IF @UserID IS NOT NULL AND @UserType IS NOT NULL
        BEGIN
            UPDATE [dbo].[AURel]
            SET
                [Active] = ISNULL(@Active, [Active]),
                [Deleted] = ISNULL(@Deleted, [Deleted])
            WHERE [AddressID] = @AddressID AND [EntityID] = @EntityID AND [UserType] = @UserType;
        END

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. AddressID: ', @AddressID, '"');

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
