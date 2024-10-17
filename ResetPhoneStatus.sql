CREATE PROCEDURE [dbo].[ResetPhoneStatus]
(
    @PhoneID BIGINT = NULL,
    @Active BIT = 1,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@PhoneID IS NULL OR @PhoneID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid PhoneID."');
        RETURN -1;  
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Phone] WHERE [FID] = @PhoneID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Phone not found."');
        RETURN -1;  
    END

    BEGIN TRY
        UPDATE [dbo].[Phone]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [FID] = @PhoneID;

        UPDATE [dbo].[PURel]
        SET [Active] = ISNULL(@Active, [Active]),
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]),
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [FID] = @PhoneID;

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: PhoneID: ', @PhoneID, '"');
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
