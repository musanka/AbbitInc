CREATE PROCEDURE [dbo].[UpdatePerson]
    @PersonID BIGINT,
    @FirstName NVARCHAR(200) = NULL,
    @MiddleNames NVARCHAR(MAX) = NULL,
    @LastName NVARCHAR(200) = NULL,
    @Birthday DATETIME = NULL,
    @Active BIT = NULL,
    @Deleted BIT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @GUID UNIQUEIDENTIFIER = NEWID();
    DECLARE @return_value INT = 0;  

    BEGIN TRY
        UPDATE [dbo].[Person]
        SET
            [FirstName] = ISNULL(@FirstName, [FirstName]),
            [MiddleNames] = ISNULL(@MiddleNames, [MiddleNames]),
            [LastName] = ISNULL(@LastName, [LastName]),
            [Birthday] = ISNULL(@Birthday, [Birthday]),
            [Active] = ISNULL(@Active, [Active]),
            [Deleted] = ISNULL(@Deleted, [Deleted]),
            [ChangedBy] = @ChangedBy
        WHERE [PersonID] = @PersonID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. PersonID: ', @PersonID, '"');
        
    END TRY
    BEGIN CATCH
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        INSERT INTO [dbo].[DbErrors]
        VALUES (@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
        SET @return_value = -1;  
        THROW;  
    END CATCH

    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = N'Database';

    RETURN @return_value;  
END
GO
