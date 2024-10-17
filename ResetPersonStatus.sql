CREATE PROCEDURE [dbo].[ResetPersonStatus]
(
    @PersonID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@PersonID IS NULL OR @PersonID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid PersonID."');
        RETURN -1;  
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Person] WHERE [CID] = @PersonID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Person not found."');
        RETURN -1;  
    END

    BEGIN TRY
        UPDATE [dbo].[Person]
        SET [Active] = @Active,
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [CID] = @PersonID;

        IF EXISTS (SELECT 1 FROM [dbo].[UserNetUserRel] WHERE [UserID] = @PersonID AND [UserType] = 'Person')
        BEGIN
            UPDATE [dbo].[UserNetUserRel]
            SET [Active] = @Active,
                [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
                [ChangedLast] = SYSDATETIMEOFFSET()
            WHERE [UserID] = @PersonID AND [UserType] = 'Person';
        END

        IF EXISTS (SELECT 1 FROM [dbo].[Employee] WHERE [CID] = @PersonID)
        BEGIN
            UPDATE [dbo].[Employee]
            SET [Active] = @Active,
                [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
                [ChangedLast] = SYSDATETIMEOFFSET()
            WHERE [CID] = @PersonID;
        END

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: PersonID: ', @PersonID, '"');
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
