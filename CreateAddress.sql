CREATE PROCEDURE [dbo].[CreateAddress]
    @UserID BIGINT = NULL,
    @UserType NVARCHAR(50) = NULL,
    @Country NVARCHAR(100) = NULL,
    @AddressLine NVARCHAR(MAX) = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL,
    @AddressID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Input validation
    IF @DObj IS NULL OR @CallWebApi IS NULL OR TRIM(@DObj) = '' OR TRIM(@CallWebApi) = ''
    BEGIN
        SET @DObj = CONCAT(ISNULL(@DObj, ''), ',"Result":"ERROR: Missing or invalid @DObj or @CallWebApi."');
        RETURN -1;
    END

    IF @UserID IS NULL OR @UserType IS NULL OR TRIM(@Country) = '' OR TRIM(@AddressLine) = ''
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Missing mandatory fields."');
        RETURN -1;
    END

    BEGIN TRY
        -- Insert into Address table
        INSERT INTO [dbo].[Address] (Guid, Country, AddressLine, Active, Deleted)
        VALUES (NEWID(), @Country, @AddressLine, 1, 0);

        -- Get AddressID
        SELECT @AddressID = SCOPE_IDENTITY();

        -- Insert into AURel table
        IF @UserID IS NOT NULL AND @UserType IS NOT NULL
        BEGIN
            INSERT INTO [dbo].[AURel] (Guid, EID, UserID, UserType, Active, Deleted)
            VALUES (NEWID(), @AddressID, @UserID, @UserType, 1, 0);
        END

        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS. AddressID: ', @AddressID, '"');
    END TRY
    BEGIN CATCH
        SET @AddressID = -1;
        THROW;
    END CATCH

    EXEC [dbo].[NewLogDB] @WebApi = @CallWebApi, @ObjectData = @DObj, @LogWho = N'Database';
END
GO
