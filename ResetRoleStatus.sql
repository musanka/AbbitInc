CREATE PROCEDURE [dbo].[ResetRoleStatus]
(
    @RoleID BIGINT = NULL,
    @Active BIT = 1,
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

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [BID] = @RoleID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Role not found."');
        RETURN -1;
    END

    BEGIN TRY
        UPDATE [dbo].[Role]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [BID] = @RoleID;

        UPDATE [dbo].[UserRoleRel]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [BID] = @RoleID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Role status reset for RoleID: ', @RoleID, '"');
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
END;
GO
