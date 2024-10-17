CREATE PROCEDURE [dbo].[UpdateCompanyDetails]
    @CompanyID BIGINT,
    @ShortName NVARCHAR(200),
    @LongName NVARCHAR(256),
    @Country NVARCHAR(100),
    @AddressLine NVARCHAR(256),
    @CountryCode VARCHAR(20),
    @Number VARCHAR(50),
    @Email NVARCHAR(256),
    @Active BIT = NULL,
    @Deleted BIT = NULL,
    @ChangedBy NVARCHAR(256),
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
AS
BEGIN                        ----------------------find out if we must update more info like Identifier
    SET NOCOUNT ON;
    SET XACT_ABORT ON;  

    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();
    DECLARE @return_value INT = 0; 
    DECLARE @AddressID BIGINT = 0;
    DECLARE @PhoneID BIGINT = 0;
    DECLARE @EmailID BIGINT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC @return_value = [dbo].[UpdateCompany]
            @CompanyID = @CompanyID,
            @ShortName = @ShortName,
            @LongName = @LongName,
            @Active = @Active,
            @Deleted = @Deleted,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi;

        IF @return_value < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Update Company failed."');
            ROLLBACK TRANSACTION;
            RETURN @return_value;
        END

        EXEC @return_value = [dbo].[UpdateAddress]
            @EntityID = @CompanyID,
            @AddressID = @AddressID,
            @UserType = 'Company',
            @Country = @Country,
            @AddressLine = @AddressLine,
            @Active = @Active,
            @Deleted = @Deleted,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi;

        IF @return_value < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Update Address failed."');
            ROLLBACK TRANSACTION;
            RETURN @return_value;
        END

        EXEC @return_value = [dbo].[UpdatePhone]
            @EntityID = @CompanyID,
            @PhoneID = @PhoneID,
            @UserType = 'Company',
            @CountryCode = @CountryCode,
            @Number = @Number,
            @Active = @Active,
            @Deleted = @Deleted,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi;

        IF @return_value < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Update Phone failed."');
            ROLLBACK TRANSACTION;
            RETURN @return_value;
        END

        EXEC @return_value = [dbo].[UpdateEmail]
            @EntityID = @CompanyID,
            @EmailID = @EmailID,
            @UserType = 'Company',
            @Email = @Email,
            @Active = @Active,
            @Deleted = @Deleted,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi;

        IF @return_value < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Update Email failed."');
            ROLLBACK TRANSACTION;
            RETURN @return_value;
        END

        COMMIT TRANSACTION;
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. CompanyID: ', @CompanyID, '"');
        RETURN 0;  -
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());

        RETURN -1;
    END CATCH

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

    RETURN @return_value;  
END
GO
