CREATE PROCEDURE [dbo].[DeletePerson]
(
    @PersonID BIGINT = NULL,
    @ChangedBy NVARCHAR(256) = NULL,
    @DObj NVARCHAR(MAX) = NULL,
    @CallWebApi NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate the provided PersonID
    IF (@PersonID IS NULL OR @PersonID <= 0)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Invalid PersonID."');
        RETURN -1;  
    END

    -- Check if the person exists based on the ID
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Person] WHERE [ID] = @PersonID)
    BEGIN
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: Person not found."');
        RETURN -1;  
    END

    -- Try to mark the person as deleted
    BEGIN TRY
        -- Mark the Person as deleted
        UPDATE [dbo].[Person]
        SET [Deleted] = 1,
            [Active] = 0, 
            [ChangedBy] = ISNULL(@ChangedBy, [ChangedBy]), 
            [ChangedLast] = SYSDATETIMEOFFSET()
        WHERE [ID] = @PersonID;

        -- Mark related entries in UserNetUserRel as deleted
        UPDATE [dbo].[UserNetUserRel]
        SET [Deleted] = 1,
            [Active] = 0
        WHERE [UserID] = @PersonID AND [UserType] = 'Person';

        -- Check if the person is an Employee, and if so, mark as deleted
        IF EXISTS (SELECT 1 FROM [dbo].[Employee] WHERE [CID] = @PersonID)
        BEGIN
            UPDATE [dbo].[Employee]
            SET [Deleted] = 1,
                [Active] = 0
            WHERE [CID] = @PersonID;
        END

        -- Success message
        SET @DObj = CONCAT(@DObj, ',"Result":"SUCCESS: Person marked as deleted."');
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur and log them
        SET @DObj = CONCAT(@DObj, ',"Result":"ERROR: ', ERROR_MESSAGE(), '"');
        RETURN -1;  
    END CATCH;

    -- Log the request for auditing purposes
    EXEC [dbo].[NewLogDB]
        @WebApi = @CallWebApi,
        @ObjectData = @DObj,
        @LogWho = @ChangedBy;

    RETURN 0;  
END;
GO
