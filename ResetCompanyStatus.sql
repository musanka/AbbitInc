CREATE PROCEDURE [dbo].[ResetCompanyStatus]
    (
    @CompanyID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    IF (@CompanyID <= 0 OR @CompanyID IS NULL)
        BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid CompanyID."');
        RETURN -1;
    END

    IF NOT EXISTS (SELECT 1
    FROM [dbo].[Company]
    WHERE [DID] = @CompanyID)
        BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Company not found."');
        RETURN -1;
    END

    BEGIN TRY
     
        UPDATE [dbo].[Company]
        SET [Active] = ISNULL(@Active, [Active]), 
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [DID] = @CompanyID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: CompanyID: ', @CompanyID, '"');
    END TRY
    BEGIN CATCH
   
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE() , '"'); 
        RETURN -1;  
    END CATCH;

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

    RETURN 0;  

END;
GO
