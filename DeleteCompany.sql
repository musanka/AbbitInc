CREATE PROCEDURE [dbo].[DeleteCompany]
(   -- if we now company id , if not fix code
    @CompanyID BIGINT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)

-- 111024 RMR - this procedure must be reviewed
AS
BEGIN
    SET NOCOUNT ON;

    IF (@CompanyID IS NULL OR @CompanyID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid CompanyID."');
        RETURN -1;
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Company] WHERE [DID] = @CompanyID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Company not found."');
        RETURN -1;
    END
    
    BEGIN TRY
        UPDATE [dbo].[Company]
        SET [Deleted] = 1,
            [Active] = 0, 
            [ChangedLast] = SYSDATETIMEOFFSET(),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy])
        WHERE [DID] = @CompanyID;
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Company marked as deleted."');
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
