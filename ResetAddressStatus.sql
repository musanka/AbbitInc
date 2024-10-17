CREATE PROCEDURE [dbo].[ResetAddressStatus]
(
    @AddressID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@AddressID IS NULL OR @AddressID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid AddressID."');
        RETURN -1; 
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Address] WHERE [EID] = @AddressID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Address not found."');
        RETURN -1;  
    END

    BEGIN TRY
        UPDATE [dbo].[Address]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [EID] = @AddressID;

        UPDATE [dbo].[AURel]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [EID] = @AddressID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Address status reset for AddressID: ', @AddressID, '"');
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
