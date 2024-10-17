CREATE PROCEDURE [dbo].[CreateEmail] 
    @UserID BIGINT = NULL,
    @UserType NVARCHAR(50) = NULL,
    @Email NVARCHAR(256) = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @EmailID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Input validation
    IF @DObj IS NULL OR @CallWebApi IS NULL OR TRIM(@DObj) = '' OR TRIM(@CallWebApi) = ''
    BEGIN
        SET @DObj = CONCAT(ISNULL(@DObj, ''), ',"Result":"ERROR: Missing or invalid @DObj or @CallWebApi."');
        RETURN -1;
    END

    IF TRIM(ISNULL(@Email, '')) = '' OR @ChangedBy IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Missing mandatory fields (Email or ChangedBy)."');
        RETURN -1;
    END

    -- Proceed with the insertion
    BEGIN TRY
        -- Insert email into the Email table
        INSERT INTO [dbo].[Email] (Guid, Email, Active, Deleted) 
        VALUES (NEWID(), @Email, 1, 0);
        
        -- Get the inserted EmailID
        SELECT @EmailID = SCOPE_IDENTITY();

        -- If UserID and UserType are provided, insert into EURel
        IF @UserID IS NOT NULL AND @UserType IS NOT NULL
        BEGIN
            INSERT INTO [dbo].[EURel] (Guid, EID, UserID, UserType, Active, Deleted) 
            VALUES (NEWID(), @EmailID, @UserID, @UserType, 1, 0);
        END

        -- Set success result in DObj
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. EmailID: ', @EmailID, '"');
    END TRY
    BEGIN CATCH
        -- On error, log and return error information
        SET @EmailID = -1;
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        THROW;
    END CATCH

    -- Log the action
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;

END
GO
