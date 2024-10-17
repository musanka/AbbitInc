CREATE PROCEDURE [dbo].[CreateRole]
(
  @ShortName nvarchar(100) = null,
  @LongName nvarchar(300) = null,
	@Description nvarchar(100) = null,
	@ChangedBy nvarchar(256) = null,
	@DObj nvarchar(max) = null,
	@CallWebApi nvarchar(200) = null
)
AS
BEGIN
  DECLARE @GUID uniqueidentifier;
  declare @RoleID bigint;
  SET @GUID = NEWID();
  set @ShortName = lower(@ShortName);

  BEGIN TRY
	if ((select [ShortName] from [dbo].[Role] where [ShortName] = @ShortName) is null)
	begin
     	if (@ShortName is not null and @LongName is not null and @Description is not null and trim(@ShortName) <> '' and trim(@LongName) <> '' and trim(@Description) <> '')
	    begin
          INSERT INTO [dbo].[Role]
          VALUES(@GUID, @ShortName, @LongName, @Description, 1, 0, SYSDATETIMEOFFSET(), SYSDATETIMEOFFSET(), SYSDATETIMEOFFSET(), @ChangedBy);
	      select @RoleID = SCOPE_IDENTITY();
    	  set @DObj = CONCAT(@DObj, ',"Result":"SUCCESS."');
	    end
		else
		Begin
    	  set @DObj = CONCAT(@DObj, ',"Result":"ERROR - NULL or blank parameter."');
          INSERT INTO [dbo].[DbErrors]
              VALUES
              (@GUID,
      		   SUSER_SNAME(),
               999,
               2,
               16,
               999,
               'CreateRole',
               'NULL or blank parameter.',
               GETDATE());
		    set @RoleID = -1;
		End
	end
	else
	Begin
		set @DObj = CONCAT(@DObj, ',"Result":"ERROR - Role Already exists."');
        INSERT INTO [dbo].[DbErrors]
            VALUES
            (@GUID,
      	    SUSER_SNAME(),
             999,
             2,
             16,
             999,
             'CreateRole',
             concat('Role ', @ShortName, ' already exists.'),
             GETDATE());
		set @RoleID = -1;
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
    	@ObjectData = @DObj,
	   	@LogWho = N'Database';	
  select @RoleID;
END
GO


