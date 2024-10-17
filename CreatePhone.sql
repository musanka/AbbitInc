CREATE PROCEDURE [dbo].[CreatePhone]
    @EntityID BIGINT = NULL,
    @UserType NVARCHAR(50) = NULL,
    @CountryCode VARCHAR(20) = NULL,
    @Number VARCHAR(50) = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @PhoneID BIGINT OUTPUT
AS
BEGIN
    SET XACT_ABORT ON;  
    SET NOCOUNT ON;

    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();  -- Unique ID for tracking operations

    -- Input validation
    IF @DObj IS NULL OR @CallWebApi IS NULL OR TRIM(@DObj) = '' OR TRIM(@CallWebApi) = ''
    BEGIN
        SET @DObj = CONCAT(ISNULL(@DObj, ''), ',"Result":"ERROR: Missing or invalid @DObj or @CallWebApi."');
        RETURN -1;
    END

    IF TRIM(ISNULL(@CountryCode, '')) = '' OR TRIM(ISNULL(@Number, '')) = '' OR @ChangedBy IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Missing mandatory fields (CountryCode, Number, or ChangedBy)."');
        RETURN -1;
    END

    -- Try to insert the Phone and PURel records
    BEGIN TRY
        -- Insert into Phone table
        INSERT INTO [dbo].[Phone] 
        VALUES (@GUID, @CountryCode, @Number, 1, 0);

        -- Retrieve the generated PhoneID
        SELECT @PhoneID = SCOPE_IDENTITY();

        -- Insert into PURel table, linking PhoneID with EntityID and UserType
        IF @EntityID IS NOT NULL AND @UserType IS NOT NULL
        BEGIN
            INSERT INTO [dbo].[PURel]
            VALUES (NEWID(), @PhoneID, @EntityID, @UserType, 1, 0);
        END

        -- Set success result in DObj
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. PhoneID: ', @PhoneID, '"');
    END TRY
    BEGIN CATCH
        -- Capture and log errors, set PhoneID to -1
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());

        SET @PhoneID = -1;
        THROW;
    END CATCH

    -- Log the operation
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;
END
GO
