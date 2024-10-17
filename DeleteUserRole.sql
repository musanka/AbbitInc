CREATE PROCEDURE [dbo].[DeleteUserRole]
(
    @RoleShortName BIGINT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RoleID BIGINT;

    IF (@RoleShortName IS NULL OR @RoleShortName <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid Role name."');
        RETURN -1;  
    END

    SET @RoleID = (SELECT BID FROM [dbo].[Role] WHERE [RoleShortName] = @RoleShortName);
    IF @RoleD IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Role not found."');
        RETURN -1;
    END

    BEGIN TRY
        UPDATE [dbo].[Role]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [BID] = @RoleID;

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
        @LogWho = N'Database';

    RETURN 0;  
END
GO
