CREATE PROCEDURE [dbo].[CreateIdentifier]
    @UserID BIGINT = NULL,
    @UserType NVARCHAR(50) = NULL,
    @Country NVARCHAR(100),
    @IdValue NVARCHAR(100),
    @IdType NVARCHAR(50),
    @ChangedBy NVARCHAR(256),
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @IdentifierID BIGINT OUTPUT
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

    IF TRIM(ISNULL(@IdValue, '')) = '' OR TRIM(ISNULL(@IdType, '')) = '' OR 
       TRIM(ISNULL(@Country, '')) = '' OR @ChangedBy IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Missing mandatory fields (IdValue, IdType, Country, or ChangedBy)."');
        RETURN -1;
    END

    -- Try to insert the Identifier and IURel records
    BEGIN TRY
        -- Insert into Identifier table
        INSERT INTO [dbo].[Identifier] 
        VALUES (@GUID, @Country, @IdValue, @IdType, 1, 0);

        -- Retrieve the generated IdentifierID
        SELECT @IdentifierID = SCOPE_IDENTITY();

        -- Insert into IURel table, using UserID and UserType
        INSERT INTO [dbo].[IURel]
        VALUES (NEWID(), @IdentifierID, @UserID, @UserType, 1, 0);

        -- Set success result
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. IdentifierID: ', @IdentifierID, '"');
    END TRY
    BEGIN CATCH
        -- Capture and log errors, set IdentifierID to -1
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
        SET @IdentifierID = -1;
        THROW;
    END CATCH

    -- Log the operation
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;
END
GO
