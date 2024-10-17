CREATE PROCEDURE [dbo].[AssignUserRole]
  @UserID bigint = null,
  @RoleID bigint = null,
  @Active bit = 0,
  @ChangedBy nvarchar(100) = null,
  @DObj nvarchar(max) = null,
  @CallWebApi nvarchar(200) = null

--- add rolle to user

AS
BEGIN
  DECLARE @GUID uniqueidentifier;
  SET @GUID = NEWID();
  BEGIN TRY
  	if (@UserID is not null and @RoleID is not null and @UserID > 0 and @RoleID > 0 )
	begin 
  if (((select [AID] from [dbo].[NetUser] where [AID] = @UserID) is not null) and ((select [BID] from [dbo].[Role]  where [BID] = @RoleID) is not null))
	  begin
      INSERT INTO [dbo].[UserRoleRel]
      VALUES(@GUID, @UserID, @RoleID, 1, 0);
      RETURN 1;
      set @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
    end else
	  begin
      set @DObj = CONCAT(@DObj, ',"Result":"ERROR - User or role not exists."');
      INSERT INTO [dbo].[DbErrors]
      VALUES(@GUID, SUSER_SNAME(), 999,2,16,999,'InsertNetUserRole', CONCAT('User or role not exists. Data - ', @DObj), GETDATE());
      RETURN -1;
    End
  end else
	Begin
    set @DObj = CONCAT(@DObj, ',"Result":"ERROR - NULL or blank parameter."');
    INSERT INTO [dbo].[DbErrors]
    VALUES(@GUID, SUSER_SNAME(), 999, 2, 16, 999, 'InsertNetUserRole', CONCAT('NULL or blank parameter. Data - ', @DObj), GETDATE());
    RETURN -1;
  End
  END TRY
  BEGIN CATCH
 	set @DObj = CONCAT(@DObj, ',"Result":"ERROR - See Error log."');
    INSERT INTO [dbo].[DbErrors]
  VALUES(@GUID, SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
    RETURN -1;
  END CATCH
 
  EXEC [dbo].[NewLogDB]
	   	@WebApi = @CallWebApi,
    	@ObjectData = @DObj,
	   	@LogWho = N'Database';
  RETURN 1;
END
GO


