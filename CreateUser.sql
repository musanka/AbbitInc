
CREATE PROCEDURE [dbo].[CreateUser]
  @Name nvarchar(256) = null,
	@PassKey nvarchar(max) = null,
	@EMail nvarchar(256) = null,
	@ChangedBy nvarchar(256) = null,
	@DObj nvarchar(max) = null,
	@CallWebApi nvarchar(200) = null

AS
BEGIN
  DECLARE @GUID uniqueidentifier;
  declare @result int;
  declare @UserID bigint;
  set @EMail = lower(@EMail);
  SET @GUID = NEWID();

  BEGIN TRY
    set @UserID = (select [ID] from [dbo].[NetUser] where [EMail] = @EMail);
	if (@UserID is null)
	begin
     	if (@Name is not null and @PassKey is not null and @EMail is not null and trim(@Name) <> '' and trim(@PassKey) <> '' and trim(@EMail) <> '')
	    begin
          INSERT INTO [dbo].[NetUser]
          VALUES (@GUID, @Name, @EMail, @PassKey, 0, 1, 0);
		      select @UserID = SCOPE_IDENTITY();
    	    set @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
	    end
		else
		Begin
    	  set @DObj = CONCAT(@DObj, ',"Result":"ERROR - NULL or blank parameter."');
          INSERT INTO [dbo].[DbErrors]
              VALUES(@GUID, SUSER_SNAME(), 999, 2, 16, 999, 'CreateUser', 'NULL or blank parameter.', GETDATE());
		    set @UserID = -1;
		End
	end
	else
	Begin
        set @DObj = CONCAT(@DObj, ',"Result":"ERROR - User Already exists."');
        INSERT INTO [dbo].[DbErrors]
            VALUES
            (@GUID,
      	    SUSER_SNAME(),
             999,
             2,
             16,
             999,
             'CreateUser',
             concat('User mail ', @EMail, ' already exists.'),
             GETDATE());
		set @UserID = -1;
	End
  END TRY
  BEGIN CATCH
   	set @DObj = CONCAT(@DObj, ',"Result":"ERROR - See Error log."');
    INSERT INTO [dbo].[DbErrors]
        VALUES
        (@GUID,
		 SUSER_SNAME(),
         ERROR_NUMBER(),
         ERROR_STATE(),
         ERROR_SEVERITY(),
         ERROR_LINE(),
         ERROR_PROCEDURE(),
         ERROR_MESSAGE(),
         GETDATE());
  END CATCH

  EXEC [dbo].[NewLogDB]
	   	@WebApi = @CallWebApi,
    	@ObjectData = @Odata,
	   	@LogWho = N'Database';	
  select @UserID;
END
GO


