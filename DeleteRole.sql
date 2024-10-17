CREATE PROCEDURE [dbo].[DeleteRole]
(
    @RoleID BIGINT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@RoleID IS NULL OR @RoleID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid RoleID."');
        RETURN -1;  
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [ID] = @RoleID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Role not found."');
        RETURN -1;  
    END

    BEGIN TRY
        UPDATE [dbo].[Role]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [ID] = @RoleID;

        UPDATE [dbo].[UserRoleRel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [BID] = @RoleID; 

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Role marked as deleted."');
    END TRY
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        RETURN -1;  
    END CATCH;

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;

    RETURN 0;  
END
GO
