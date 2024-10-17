CREATE PROCEDURE [dbo].[CreatePerson]
    @NetUserID BIGINT = NULL,
    @Birthday DATETIME = NULL,
    @FirstName NVARCHAR(200) = NULL,
    @MiddleNames NVARCHAR(MAX) = NULL,
    @LastName NVARCHAR(200) = NULL,
    @Country NVARCHAR(100) = NULL,
    @AddressLine NVARCHAR(MAX) = NULL,
    @CountryCode VARCHAR(20) = NULL,
    @PhoneNo VARCHAR(50) = NULL, -- Changed to match the proper field name
    @Email NVARCHAR(256) = NULL,
    @IdValueCustNo NVARCHAR(100),
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @PersonID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validate inputs
    IF @DObj IS NULL OR @CallWebApi IS NULL OR TRIM(@DObj) = '' OR TRIM(@CallWebApi) = ''
    BEGIN
        SET @DObj = CONCAT(ISNULL(@DObj, ''), ',"Result":"ERROR: Missing or invalid @DObj or @CallWebApi."');
        INSERT INTO [dbo].[DbErrors]
        VALUES(NEWID(), SUSER_SNAME(), 999, 2, 16, 999, 'CreatePersonDetails', CONCAT('Early exit due to missing or invalid @DObj or @CallWebApi. Data - ', @DObj), GETDATE());
        RETURN -1;  
    END

    IF ISNULL(TRIM(@FirstName), '') = '' OR ISNULL(TRIM(@LastName), '') = '' OR ISNULL(TRIM(@Country), '') = '' OR
       ISNULL(TRIM(@AddressLine), '') = '' OR ISNULL(TRIM(@CountryCode), '') = '' OR ISNULL(TRIM(@PhoneNo), '') = '' OR
       ISNULL(TRIM(@Email), '') = '' OR ISNULL(TRIM(@IdValueCustNo), '') = ''
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Missing mandatory fields."');
        INSERT INTO [dbo].[DbErrors]
        VALUES(NEWID(), SUSER_SNAME(), 999, 2, 16, 999, 'CreatePersonDetails', CONCAT('Early exit due to missing mandatory fields. Data - ', @DObj), GETDATE());
        RETURN -1;  
    END

    DECLARE @AddressID BIGINT = 0;
    DECLARE @PhoneID BIGINT = 0;
    DECLARE @EmailID BIGINT = 0;
    DECLARE @IdentifierIDCustNo BIGINT = 0;
    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();  
    DECLARE @ErrorMessage NVARCHAR(MAX);

    -- Start transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert Person directly into the Person table
        INSERT INTO [dbo].[Person]
        VALUES (NEWID(), @Birthday, @FirstName, @MiddleNames, @LastName, 1, 0, SYSDATETIMEOFFSET(), @ChangedBy);

        -- Get the newly created PersonID
        SELECT @PersonID = SCOPE_IDENTITY();

        -- If the Person insert fails, rollback
        IF @PersonID IS NULL OR @PersonID <= 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Insert into Person failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Insert Address for the Person
        EXEC [dbo].[InsertAddress]
            @EntityID = @PersonID,
            @UserType = 'Person',
            @Country = @Country,
            @AddressLine = @AddressLine,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi,
            @AddressID = @AddressID OUTPUT;

        IF @AddressID < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Create Address failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Insert Phone for the Person
        EXEC [dbo].[InsertPhone]
            @EntityID = @PersonID,
            @UserType = 'Person',
            @CountryCode = @CountryCode,
            @Number = @PhoneNo,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi,
            @PhoneID = @PhoneID OUTPUT;

        IF @PhoneID < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Create Phone failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Insert Email for the Person
        EXEC [dbo].[InsertEmail]
            @EntityID = @PersonID,
            @UserType = 'Person',
            @Email = @Email,
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi,
            @EmailID = @EmailID OUTPUT;

        IF @EmailID < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Create Email failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Insert Identifier (CustNo) for the Person
        EXEC [dbo].[InsertIdentifier]
            @EntityID = @PersonID,
            @UserType = 'Person',
            @Country = @Country,
            @IdValue = @IdValueCustNo,
            @IdType = 'custno',
            @ChangedBy = @ChangedBy,
            @DObj = @DObj,
            @CallWebApi = @CallWebApi,
            @IdentifierID = @IdentifierIDCustNo OUTPUT;

        IF @IdentifierIDCustNo < 0
        BEGIN
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Create Identifier failed."');
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Commit transaction if all steps succeed
        COMMIT TRANSACTION;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: PersonID: ', @PersonID, '"');

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', @ErrorMessage, '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES(NEWID(), SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), @ErrorMessage, GETDATE());

        RETURN -1;
    END CATCH

    -- Log the request
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;

END
GO
