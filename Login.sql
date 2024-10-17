CREATE PROCEDURE [dbo].[Login]
(
	@PassKey nvarchar(max) = null,
    @EMail nvarchar(256) = null,
	@CallWebApi nvarchar(200) = 'Login',
	@DObj nvarchar(max) = null
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserID bigint;

    BEGIN TRY
        -- Check if the user exists with the provided email and password
        SET @UserID = (SELECT ID 
                       FROM [dbo].[NetUser] 
                       WHERE [EMail] = @EMail 
                         AND PassKey = @PassKey 
                         AND ResetPassKey = 0 
                         AND Active = 1);

        IF (@UserID IS NULL)
        BEGIN
            -- If the user does not exist, log an error
            SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: User does not exist."');
        END
        ELSE
        BEGIN
            -- Success case
            SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
        END
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur during the login process
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR - See Error log."');
        INSERT INTO [dbo].[DbErrors]
        VALUES
        (
            NEWID(),
            SUSER_SNAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );
    END CATCH

    -- Log the request for tracking purposes
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

    -- Return the UserID as part of the result
    SELECT @UserID;
END
GO
