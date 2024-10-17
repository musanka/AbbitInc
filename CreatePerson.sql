CREATE PROCEDURE [dbo].[CreatePerson]
    @Birthday DATETIME = NULL,
    @FirstName NVARCHAR(200) = NULL,
    @MiddleName NVARCHAR(600) = NULL,
    @LastName NVARCHAR(200) = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @PersonID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; 

    DECLARE @GUID UNIQUEIDENTIFIER = NEWID(); 

    BEGIN TRY
        INSERT INTO [dbo].[Person] 
        VALUES (NEWID(), @Birthday, @FirstName, @MiddleName, @LastName, 1, 0);

        SELECT @PersonID = SCOPE_IDENTITY();

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. PersonID: ', @PersonID, '"');
    END TRY
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
        SET @PersonID = -1;
        THROW;
    END CATCH

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

END
GO
