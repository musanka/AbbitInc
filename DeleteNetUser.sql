CREATE PROCEDURE [dbo].[DeleteNetUser]
(
    @UserID BIGINT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate the provided UserID
    IF (@UserID IS NULL OR @UserID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid UserID."');
        RETURN -1;  
    END

    -- Check if the user exists based on the ID (fixing AID to ID)
    IF NOT EXISTS (SELECT 1 FROM [dbo].[NetUser] WHERE [ID] = @UserID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: NetUser not found."');
        RETURN -1;  
    END

    -- Try updating the user and related tables
    BEGIN TRY
        -- Mark the NetUser as deleted
        UPDATE [dbo].[NetUser]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [ID] = @UserID;

        -- Mark related entries in UserRoleRel as deleted
        UPDATE [dbo].[UserRoleRel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [AID] = @UserID;

        -- Mark related entries in UserNetUserRel as deleted
        UPDATE [dbo].[UserNetUserRel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [AID] = @UserID;

        -- Success message
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: NetUser marked as deleted."');
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur and log them
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        -- Throw the error for higher-level handling if needed
        THROW;
    END CATCH;

    -- Log the request
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

    -- Return success code
    RETURN 0;
END;
GO
