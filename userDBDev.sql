IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AbbitUserDev')
BEGIN
    CREATE DATABASE AbbitUserDev;
END
GO

USE AbbitUserDev;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[Role](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ShortName] [nvarchar](100) NOT NULL,
	[LongName] [nvarchar](300) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
	[Stamp] [timestamp] NOT NULL, --to remove the columns  or not
	[ChangedLast] [datetimeoffset] NOT NULL, 
	[ChangedBy] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[NetUser](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[PassKey] [nvarchar](max) NOT NULL,
	[ResetPassKey] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.NetUser] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_NetUser_Email] UNIQUE ([Email]),
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[UserRoleRel](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AID] [bigint] NOT NULL, --relation to the NetUser table
	[BID] [bigint] NOT NULL, --relation to the Role table
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserRoleRel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UserNetUserRel](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AID] [bigint] NOT NULL, --netuser
	[UserID] [bigint] NOT NULL, --userId her depends on usertype, if type is person the userid is CID ot if usertype is company than UserID is DID
	[UserType] [varchar](50) NOT NULL DEFAULT 'Person', 
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.UserNetUserRel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT CK_UserNetUserRel_UserType CHECK ([UserType] IN ('Person', 'Company', 'Vehicle'))
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Company](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CID] [bigint] NOT NULL,  -- link to person table - the owner 
	[StartDate] [datetime] NOT NULL,
	[ShortName] [nvarchar](200) NOT NULL,
	[LongName] [nvarchar](max) NOT NULL,
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
	[ChangedLast] [datetimeoffset] NOT NULL,
	[ChangedBy] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.Company] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Company] ADD  DEFAULT ((1)) FOR [Active]
GO


CREATE TABLE [dbo].[Person](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[BirthDay] [datetime] NOT NULL,
	[FirstName] [nvarchar](200) NOT NULL,
	[MiddleName] [nvarchar](200) NULL,
	[LastName] [nvarchar](200) NOT NULL,
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
	[ChangedLast] [datetimeoffset] NOT NULL,
	[ChangedBy] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.Person] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Person] ADD  DEFAULT ((1)) FOR [Active]
GO


CREATE TABLE [dbo].[Employee](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeNo] [nvarchar](20) NOT NULL,
    [JobPosition] [nvarchar](50) NOT NULL,
	[CID] [bigint] NOT NULL, --relation to person table
	[DID] [bigint] NOT NULL, --relation to company table
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Employee] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO


CREATE TABLE [dbo].[Identifier](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](100) NOT NULL,
	[IdValue] [varchar](100) NOT NULL,
	[IdType] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Identifier] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Address](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](100) NOT NULL,
	[AddressLine] [nvarchar](max) NOT NULL,
	[AddressType] [varchar](50) NULL DEFAULT 'Post', 
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Address] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT CK_Address_AddressType CHECK ([AddressType] IN ('Post', 'Billing', 'Shipping'))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [dbo].[Email](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Email] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Email_EmailRel] UNIQUE ([Email]),
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Phone](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryCode] [varchar](20) NOT NULL,
	[PhoneNo] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Phone] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[IURel](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IID] [bigint] NOT NULL, 
	[UserID] [bigint] NOT NULL,
	[UserType] [varchar](50) NULL DEFAULT 'Person',  
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.IURel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT CK_IURel_UserType CHECK ([UserType] IN ('Person', 'Company', 'Vehicle'))
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[AURel](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[EID] [bigint] NOT NULL, 
	[UserID] [bigint] NOT NULL, 
	[UserType] [varchar](50) NULL DEFAULT 'Person', 
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.AURel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT CK_AURel_UserType CHECK ([UserType] IN ('Person', 'Company', 'Vehicle'))
) ON [PRIMARY] 
GO


CREATE TABLE [dbo].[EURel](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[GID] [bigint] NOT NULL, 
	[UserID] [bigint] NOT NULL, 
	[UserType] [varchar](50) NOT NULL DEFAULT 'Person', 
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.EURel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT CK_EURel_UserType CHECK ([UserType] IN ('Person', 'Company', 'Vehicle'))
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[PURel](
	[Guid] [uniqueidentifier] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FID] [bigint] NOT NULL, 
	[UserID] [bigint] NOT NULL, 
	[UserType] [varchar](50) NOT NULL DEFAULT 'Person', 
	[Active] [bit] NOT NULL,
    [Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.PURel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT CK_PURel_UserType CHECK ([UserType] IN ('Person', 'Company', 'Vehicle'))
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DbLog](
	[LogGuid] [uniqueidentifier] NOT NULL,
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[WebApi] [nvarchar](200) NULL,
	[ObjectData] [nvarchar](max) NOT NULL,
	[LogWho] [nvarchar](100) NOT NULL,
	[LogWhen] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_LogDB] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[DbErrors](
	[ErrorGuid] [uniqueidentifier] NOT NULL,
	[ErrorID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorDateTime] [datetimeoffset] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

