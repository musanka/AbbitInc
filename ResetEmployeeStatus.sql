CREATE PROCEDURE [dbo].[ResetEmployeeStatus]
(
    @EmployeeID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@EmployeeID IS NULL OR @EmployeeID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid EmployeeID."');
        RETURN -1;  
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Employee] WHERE [JID] = @EmployeeID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Employee not found."');
        RETURN -1;  
    END

    BEGIN TRY
        UPDATE [dbo].[Employee]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [JID] = @EmployeeID;

        UPDATE [dbo].[UserNetUserRel]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [UserID] = @EmployeeID AND [UserType] = 'Person';

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Employee status reset for EmployeeID: ', @EmployeeID, '"');
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
