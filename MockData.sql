DECLARE @i INT = 1;
DECLARE @CompanyID BIGINT;
DECLARE @DObj NVARCHAR(MAX);
DECLARE @CallWebApi NVARCHAR(200) = 'TestApi';
DECLARE @StartDate DATETIME = '2024-01-01';

-- Loop to insert 1000 company records
WHILE @i <= 1000
BEGIN
    -- Generate random data for each record
    DECLARE @ShortName NVARCHAR(200) = CONCAT('TestCompany_', @i);
    DECLARE @LongName NVARCHAR(MAX) = CONCAT('Test Long Name for Company ', @i);
    DECLARE @IdValueCvr NVARCHAR(100) = CAST(10000000 + @i AS NVARCHAR(100));
    DECLARE @IdValueCustNo NVARCHAR(100) = CAST(87654321 + @i AS NVARCHAR(100));
    DECLARE @CountryCode VARCHAR(20) = '45';
    DECLARE @Number VARCHAR(50) = CAST(1000000000 + @i AS VARCHAR(50));
    DECLARE @Country NVARCHAR(100) = 'Denmark';
    DECLARE @AddressLine NVARCHAR(MAX) = CONCAT('Test Street ', @i, ', Copenhagen');
    DECLARE @ChangedBy NVARCHAR(256) = 'AdminUser';

    -- Call the InsertCompanyDetails procedure
    EXEC dbo.InsertCompanyDetails
        @StartDate = @StartDate,
        @ShortName = @ShortName,
        @LongName = @LongName,
        @IdValueCvr = @IdValueCvr,
        @IdValueCustNo = @IdValueCustNo,
        @CountryCode = @CountryCode,
        @Number = @Number,
        @Country = @Country,
        @AddressLine = @AddressLine,
        @ChangedBy = @ChangedBy,
        @DObj = @DObj OUTPUT,
        @CallWebApi = @CallWebApi,
        @CompanyID = @CompanyID OUTPUT;

    -- Print the result for tracking
    PRINT CONCAT('Inserted CompanyID: ', @CompanyID, ' - Result: ', @DObj);

    -- Increment the counter
    SET @i = @i + 1;
END

-- Reset the counter for update operation
SET @i = 1;

-- Loop to update 1000 company records
WHILE @i <= 1000
BEGIN
    -- Use the CompanyID generated during insert operation
    DECLARE @UpdateCompanyID BIGINT = @i; -- Assuming CompanyIDs are 1 to 1000

    -- Generate random data for update
    DECLARE @UpdatedShortName NVARCHAR(200) = CONCAT('UpdatedCompany_', @i);
    DECLARE @UpdatedLongName NVARCHAR(MAX) = CONCAT('Updated Long Name for Company ', @i);
    DECLARE @UpdatedNumber VARCHAR(50) = CAST(2000000000 + @i AS VARCHAR(50));
    DECLARE @UpdatedAddressLine NVARCHAR(MAX) = CONCAT('Updated Street ', @i, ', Copenhagen');
    DECLARE @Active BIT = 1;
    DECLARE @Deleted BIT = 0;

    -- Call the UpdateCompanyDetails procedure
    EXEC dbo.UpdateCompanyDetails
        @CompanyID = @UpdateCompanyID,
        @ShortName = @UpdatedShortName,
        @LongName = @UpdatedLongName,
        @Country = @Country,
        @AddressLine = @UpdatedAddressLine,
        @PhoneID = NULL,  -- Set to NULL or provide valid PhoneID if needed
        @CountryCode = @CountryCode,
        @Number = @UpdatedNumber,
        @Active = @Active,
        @Deleted = @Deleted,
        @DObj = @DObj OUTPUT,
        @CallWebApi = @CallWebApi;

    -- Print the result for tracking
    PRINT CONCAT('Updated CompanyID: ', @UpdateCompanyID, ' - Result: ', @DObj);

    -- Increment the counter
    SET @i = @i + 1;
END
