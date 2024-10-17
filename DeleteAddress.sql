CREATE PROCEDURE [dbo].[DeleteAddress]
(
    @Address  NVARCHAR(MAX) = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    declare @AddressID BIGINT;
    
    IF (@Address IS NULL OR @Address <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid Address."');
        RETURN -1;  
    END

    SET @AddressID = (SELECT EID FROM [dbo].[Address] WHERE [AddressLine] = @Address);
    IF @AddressID IS NULL
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Address not found."');
        RETURN -1;
    END

    BEGIN TRY
        UPDATE [dbo].[Address]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [EID] = @AddressID;

        UPDATE [dbo].[AURel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [EID] = @AddressID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Address marked as deleted."');
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
