USE [UserTest02]
GO

/****** Object:  StoredProcedure [dbo].[NewLogDB]    Script Date: 02-10-2024 16:08:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Allan Frost>
-- Create date: <19. May 2021>
-- Description:	<Creates a new Entry in Log>
-- =============================================
CREATE PROCEDURE [dbo].[NewLogDB] 
	-- Add the parameters for the stored procedure here
	@WebApi nvarchar(200) = null,
	@ObjectData nvarchar(max) = null,
	@LogWho nvarchar(100) = 'Database'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
  SET NOCOUNT ON;
  DECLARE @GUIDl uniqueidentifier
  SET @GUIDl = NEWID();
    -- Insert statements for procedure here
  BEGIN TRY
    INSERT INTO [dbo].[DbLog]
               ([LogGuid]
               ,[WebApi]
               ,[ObjectData]
               ,[LogWho]
               ,[LogWhen]
               )
     VALUES
           (@GUIDl
           ,@WebApi
           ,@ObjectData
           ,@LogWho
           ,SYSDATETIMEOFFSET()
		   );
  END TRY
  BEGIN CATCH
    INSERT INTO [dbo].[DbErrors]
        VALUES
        (@GUIDl, 
		 SUSER_SNAME(),
         ERROR_NUMBER(),
         ERROR_STATE(),
         ERROR_SEVERITY(),
         ERROR_LINE(),
         ERROR_PROCEDURE(),
         ERROR_MESSAGE(),
         GETDATE());
  END CATCH
END
GO


