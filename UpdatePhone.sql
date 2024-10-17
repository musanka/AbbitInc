CREATE PROCEDURE [dbo].[UpdatePhone]
    @EntityID BIGINT = NULL,
    @PhoneID BIGINT = NULL,
    @UserType NVARCHAR(50) = NULL,
    @CountryCode VARCHAR(20) = NULL,
    @PhoneNo VARCHAR(50) = NULL,
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
        UPDATE [dbo].[Phone]
        SET
            [CountryCode] = ISNULL(@CountryCode, [CountryCode]),
            [PhoneNo] = ISNULL(@PhoneNo, [PhoneNo]),
            [Active] = ISNULL(@Active, [Active]),
            [Deleted] = ISNULL(@Deleted, [Deleted])
        WHERE [FID] = @PhoneID;

        IF @EntityID IS NOT NULL AND @UserType IS NOT NULL
        BEGIN
            UPDATE [dbo].[PURel]
            SET
                [Active] = ISNULL(@Active, [Active]),
                [Deleted] = ISNULL(@Deleted, [Deleted])
            WHERE [FID] = @PhoneID AND [UserID] = @EntityID AND [UserType] = @UserType;
        END;    

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. PhoneID: ', @PhoneID, '"');
    END TRY    
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
        SET @return_value = -1;
        THROW;  
    END CATCH

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

    RETURN @return_value;  
END
GO
