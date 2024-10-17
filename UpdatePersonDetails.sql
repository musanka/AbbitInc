CREATE PROCEDURE [dbo].[UpdatePersonDetails]
    @PersonID BIGINT,
    @FirstName NVARCHAR(200),
    @MiddleNames NVARCHAR(MAX) = NULL,
    @LastName NVARCHAR(200),
    @Birthday DATETIME = NULL,
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
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;  

    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();
    DECLARE @return_value INT = 0;  
    DECLARE @AddressID BIGINT = 0;
    DECLARE @PhoneID BIGINT = 0;
    DECLARE @EmailID BIGINT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC @return_value = [dbo].[UpdatePerson]
            @PersonID = @PersonID,
            @FirstName = @FirstName,
            @MiddleNames = @MiddleNames,
            @LastName = @LastName,
            @Birthday = @Birthday,
            @Active = @Active,
            @Deleted = @Deleted,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi;

        IF @return_value < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Update Person failed."');
            ROLLBACK TRANSACTION;
            RETURN @return_value;
        END

        EXEC @return_value = [dbo].[UpdateAddress]
            @EntityID = @PersonID,
            @AddressID = @AddressID,
            @UserType = 'Person',
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
            @EntityID = @PersonID,
            @PhoneID = @PhoneID,
            @UserType = 'Person',
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
            @EntityID = @PersonID,
            @EmailID = @EmailID,
            @UserType = 'Person',
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
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. PersonID: ', @PersonID, '"');
        RETURN 0;  
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
