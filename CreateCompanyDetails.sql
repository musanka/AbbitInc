CREATE PROCEDURE [dbo].[CreateCompany]
    @StartDate DATETIME,
    @ShortName NVARCHAR(200),
    @LongName NVARCHAR(MAX),
    @IdValueCvr NVARCHAR(100),
    @IdValueCustNo VARCHAR(100) = NULL,
    @CountryCode VARCHAR(20),
    @Number VARCHAR(50),
    @Country NVARCHAR(100),
    @AddressLine NVARCHAR(256),
    @ChangedBy NVARCHAR(256),
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @CompanyID BIGINT OUTPUT
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @PhoneID BIGINT;
    DECLARE @AddressID BIGINT;
    DECLARE @IdentifierIDCvr BIGINT;
    DECLARE @IdentifierIDCustNo BIGINT;
    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();

    -- Input Validation
    IF @DObj IS NULL OR @CallWebApi IS NULL OR TRIM(@DObj) = '' OR TRIM(@CallWebApi) = ''
    BEGIN
        SET @DObj = CONCAT(ISNULL(@DObj, ''), ',"Result":"ERROR: Missing or invalid @DObj or @CallWebApi."');
        INSERT INTO [dbo].[DbErrors]
        VALUES(NEWID(), SUSER_SNAME(), 999, 2, 16, 999, 'CreateCompany', CONCAT('Early exit due to missing or invalid @DObj or @CallWebApi. Data - ', @DObj), GETDATE());
        RETURN -1;
    END

    IF @StartDate IS NULL OR TRIM(ISNULL(@ShortName, '')) = '' OR TRIM(ISNULL(@LongName, '')) = '' OR
       TRIM(ISNULL(@IdValueCvr, '')) = '' OR TRIM(ISNULL(@CountryCode, '')) = '' OR
       TRIM(ISNULL(@Number, '')) = '' OR TRIM(ISNULL(@Country, '')) = '' OR TRIM(ISNULL(@AddressLine, '')) = ''
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Missing mandatory fields."');
        INSERT INTO [dbo].[DbErrors]
        VALUES(NEWID(), SUSER_SNAME(), 999, 2, 16, 999, 'CreateCompany', CONCAT('Early exit due to missing mandatory fields. Data - ', @DObj), GETDATE());
        RETURN -1;
    END

    -- Transaction begins
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert into Company table
        INSERT INTO [dbo].[Company]
        VALUES (NEWID(), @StartDate, @ShortName, @LongName, 1, 0, SYSDATETIMEOFFSET(), @ChangedBy);
        SELECT @CompanyID = SCOPE_IDENTITY();

        -- If company insert fails, rollback
        IF @CompanyID IS NULL OR @CompanyID <= 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Insert into Company failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Proceed with calling sub-procedures
        EXEC [dbo].[CreateAddress]
            @UserID = @CompanyID,
            @UserType = 'Company',
            @Country = @Country,
            @AddressLine = @AddressLine,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi,
            @AddressID = @AddressID OUTPUT;

        IF @AddressID < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Address creation failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        EXEC [dbo].[CreatePhone]
            @EntityID = @CompanyID,
            @UserType = 'Company',
            @CountryCode = @CountryCode,
            @Number = @Number,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi,
            @PhoneID = @PhoneID OUTPUT;

        IF @PhoneID < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Phone creation failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        EXEC [dbo].[CreateIdentifier]
            @UserID = @CompanyID,
            @UserType = 'Company',
            @Country = @Country,
            @IdValue = @IdValueCvr,
            @IdType = 'cvr',
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi,
            @IdentifierID = @IdentifierIDCvr OUTPUT;

        IF @IdentifierIDCvr < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: CVR Identifier creation failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        IF @IdValueCustNo IS NOT NULL
        BEGIN
            EXEC [dbo].[CreateIdentifier]
                @UserID = @CompanyID,
                @UserType = 'Company',
                @Country = @Country,
                @IdValue = @IdValueCustNo,
                @IdType = 'custno',
                @ChangedBy = @ChangedBy,
                @DObj = @DObj,
                @CallWebApi = @CallWebApi,
                @IdentifierID = @IdentifierIDCustNo OUTPUT;

            IF @IdentifierIDCustNo < 0
            BEGIN
                SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: CustomerNo Identifier creation failed."');
                ROLLBACK TRANSACTION;
                RETURN -1;
            END
        END

        -- Commit the transaction if all steps succeed
        COMMIT TRANSACTION;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: CompanyID: ', @CompanyID, '"');
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', @ErrorMessage, '"');

        INSERT INTO [dbo].[DbErrors]
        VALUES (NEWID(), SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), @ErrorMessage, GETDATE());

        RETURN -1;
    END CATCH

    -- Log the request
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;

    SELECT @CompanyID;
END
GO
