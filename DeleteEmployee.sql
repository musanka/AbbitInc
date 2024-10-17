CREATE PROCEDURE [dbo].[DeleteEmployee]
(
    @EmployeeID BIGINT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
-- 111024 RMR - this procedure must be reviewed

AS
BEGIN
    SET NOCOUNT ON;

    IF (@EmployeeID IS NULL OR @EmployeeID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid EmployeeID."');
        RETURN -1; 
    END;    

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Employee] WHERE [JID] = @EmployeeID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Employee not found."');
        RETURN -1;  
    END

    BEGIN TRY
           UPDATE [dbo].[Employee]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [JID] = @EmployeeID;
         
        /*UPDATE [dbo].[UserNetUserRel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [UserID] = @EmployeeID AND [UserType] = 'Person';*/

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Employee marked as deleted."');
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