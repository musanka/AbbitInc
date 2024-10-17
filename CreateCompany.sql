CREATE PROCEDURE [dbo].[CreateCompany]
    @StartDate DATETIME,
    @ShortName NVARCHAR(200),
    @LongName NVARCHAR(MAX),
    @ChangedBy NVARCHAR(256),
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @CompanyID BIGINT OUTPUT
AS
BEGIN ---rename all insert to create
    SET NOCOUNT ON;
    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();

    BEGIN TRY
        INSERT INTO [dbo].[Company] VALUES (@GUID, @StartDate, @ShortName, @LongName, 1, 0);
        SELECT @CompanyID = SCOPE_IDENTITY();
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. CompanyID: ', @CompanyID, '"');
    END TRY
    BEGIN CATCH
        SET @CompanyID = -1;
        THROW;
    END CATCH

    EXEC [dbo].[NewLogDB] @WebApi = @CallWebApi, @ObjectData = @DObj, @LogWho = N'Database';
END
GO
