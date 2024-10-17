CREATE PROCEDURE [dbo].[ResetNetUserStatus]
(
    @NetUserID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    IF (@NetUserID IS NULL OR @NetUserID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid NetUserID."');
        RETURN -1;  
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[NetUser] WHERE [AID] = @NetUserID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: NetUser not found."');
        RETURN -1;  
    END

    BEGIN TRY
        UPDATE [dbo].[NetUser]
        SET [Active] = @Active,
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [AID] = @NetUserID;

        IF EXISTS (SELECT 1 FROM [dbo].[UserRoleRel] WHERE [AID] = @NetUserID)
        BEGIN
            UPDATE [dbo].[UserRoleRel]
            SET [Active] = @Active,
                [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
                [ChangedLast] = SYSDATETIMEOFFSET()
            WHERE [AID] = @NetUserID;
        END

        IF EXISTS (SELECT 1 FROM [dbo].[UserNetUserRel] WHERE [AID] = @NetUserID)
        BEGIN
            UPDATE [dbo].[UserNetUserRel]
            SET [Active] = @Active,
                [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
                [ChangedLast] = SYSDATETIMEOFFSET()
            WHERE [AID] = @NetUserID;
        END

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: NetUserID: ', @NetUserID, '"');
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
