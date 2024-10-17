CREATE PROCEDURE [dbo].[DeletePhone]
(
    @PhoneNo BIGINT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PhoneID BIGINT;

    -- Validate Phone Number
    IF (@PhoneNo IS NULL OR @PhoneNo <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid Phone number."');
        RETURN -1;
    END

    -- Get PhoneID based on Phone Number
    SET @PhoneID = (SELECT ID FROM [dbo].[Phone] WHERE [PhoneNo] = @PhoneNo);
    IF @PhoneID IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Phone not found."');
        RETURN -1;
    END

    -- Try to mark the phone and related records as deleted
    BEGIN TRY
        -- Mark the phone record as deleted
        UPDATE [dbo].[Phone]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [ID] = @PhoneID;

        -- Mark related entries in PURel as deleted
        UPDATE [dbo].[PURel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [FID] = @PhoneID;

        -- Success message
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Phone marked as deleted."');
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur and log them
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        RETURN -1;  
    END CATCH;

    -- Log the request for auditing purposes
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;

    RETURN 0;  
END;
GO
