CREATE PROCEDURE [dbo].[LoginR]
  (
  @PassKey nvarchar(max) = null,
  @EMail nvarchar(256) = null,
  @CallWebApi nvarchar(200) = 'Login',
  @DObj nvarchar(max) = null
)
AS
BEGIN
  SET NOCOUNT ON
  declare @PersonID bigint;
  declare @NetUserID bigint;
  declare @RoleID bigint;
  -- Result (User + Role)
  DECLARE @Result as Table (netUserID bigint,
    roleID bigint,
    personID bigint,
    email nvarchar(256));
  BEGIN TRY
    set @NetUserID = (select ID
  from [dbo].[NetUser]
  where [EMail] = @EMail and PassKey = @PassKey and ResetPassKey = 0 and [Active] = 1);
    if (@NetUserID is null)
	begin
    set @DObj = CONCAT(@DObj, ',"Result":"ERROR: User does not Exists."');
    set @PersonID = 0;
  end
	else
	begin
    set @PersonID = (select ID
    from [dbo].[Person]
    where [NetUserID] = @NetUserID and [Active] = 1);
    if (@PersonID is null)
	  begin
      set @DObj = CONCAT(@DObj, ',"Result":"ERROR: Person does not Exists."');
      set @PersonID = 0;
    end
	  else
	  begin
      set @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
      set @RoleID = (select RoleID
      from [dbo].[NetUserRole]
      where NetUserID = @NetUserID);
      if (@RoleID is null)
	      set @RoleID = 0;
		else
	      insert into @Result
      values(@NetUserID, @PersonID, @RoleID, @EMail);

    end
  end
  END TRY
  BEGIN CATCH
	  set @DObj = CONCAT(@DObj, ',"Result":"ERROR - See Error log."');
    INSERT INTO [dbo].[DbErrors]
  VALUES
    (NEWID(), SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
  END CATCH

  EXEC [dbo].[NewLogDB]
	   	@WebApi = @CallWebApi,
	    @ObjectData = @DObj,
	   	@LogWho = N'Database';
  select *
  from @Result;
END
GO


