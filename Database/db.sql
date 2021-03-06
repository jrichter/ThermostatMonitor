USE [ThermostatMonitor]
GO
/****** Object:  StoredProcedure [dbo].[SaveSetting]    Script Date: 09/15/2012 14:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveSetting]
	@Id int,
	@ZipCode varchar(50),
	@FilterChangeDate datetime
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Settings] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Settings] SET
		[ZipCode] = @ZipCode,
		[FilterChangeDate] = @FilterChangeDate
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Settings] (
		[ZipCode],
		[FilterChangeDate]
	) VALUES (
		@ZipCode,
		@FilterChangeDate
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveZipCode]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveZipCode]
	@Id int,
	@PostalCode varchar(50)
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[ZipCodes] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[ZipCodes] SET
		[PostalCode] = @PostalCode
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[ZipCodes] (
		[PostalCode]
	) VALUES (
		@PostalCode
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveThermostatSetting]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveThermostatSetting]
	@Id int,
	@ThermostatId int,
	@LogDate datetime,
	@Degrees float,
	@Mode varchar(50)
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[ThermostatSettings] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[ThermostatSettings] SET
		[ThermostatId] = @ThermostatId,
		[LogDate] = @LogDate,
		[Degrees] = @Degrees,
		[Mode] = @Mode
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[ThermostatSettings] (
		[ThermostatId],
		[LogDate],
		[Degrees],
		[Mode]
	) VALUES (
		@ThermostatId,
		@LogDate,
		@Degrees,
		@Mode
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  Table [dbo].[Users]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmailAddress] [varchar](255) NULL,
	[Password] [varchar](255) NULL,
	[AuthCode] [varchar](255) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[LoadThermostatSettingsByThermostatId]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadThermostatSettingsByThermostatId]
	@ThermostatId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[LogDate],
	[Degrees],
	[Mode]
FROM
	[dbo].[ThermostatSettings]
WHERE
	[ThermostatId] = @ThermostatId
GO
/****** Object:  StoredProcedure [dbo].[LoadThermostatSettingsAll]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadThermostatSettingsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[LogDate],
	[Degrees],
	[Mode]
FROM
	[dbo].[ThermostatSettings]
GO
/****** Object:  StoredProcedure [dbo].[LoadThermostatSetting]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadThermostatSetting]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[LogDate],
	[Degrees],
	[Mode]
FROM
	[dbo].[ThermostatSettings]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadZipCodesAll]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadZipCodesAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[PostalCode]
FROM
	[dbo].[ZipCodes]
GO
/****** Object:  StoredProcedure [dbo].[LoadZipCode]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadZipCode]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[PostalCode]
FROM
	[dbo].[ZipCodes]
WHERE
	[Id] = @Id
GO
/****** Object:  Table [dbo].[Cycles]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cycles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ThermostatId] [int] NULL,
	[CycleType] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[StartPrecision] [smallint] NULL,
	[EndPrecision] [smallint] NULL,
 CONSTRAINT [PK_Cycles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_Cycles] ON [dbo].[Cycles] 
(
	[ThermostatId] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[DeleteSetting]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSetting]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Settings]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteThermostatSetting]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteThermostatSetting]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[ThermostatSettings]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteZipCode]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteZipCode]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[ZipCodes]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadSettingsAll]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadSettingsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ZipCode],
	[FilterChangeDate]
FROM
	[dbo].[Settings]
GO
/****** Object:  StoredProcedure [dbo].[LoadSetting]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadSetting]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ZipCode],
	[FilterChangeDate]
FROM
	[dbo].[Settings]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadCyclesAll]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadCyclesAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[CycleType],
	[StartDate],
	[EndDate],
	[StartPrecision],
	[EndPrecision]
FROM
	[dbo].[Cycles]
GO
/****** Object:  StoredProcedure [dbo].[LoadCycle]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadCycle]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[CycleType],
	[StartDate],
	[EndDate],
	[StartPrecision],
	[EndPrecision]
FROM
	[dbo].[Cycles]
WHERE
	[Id] = @Id
GO
/****** Object:  Table [dbo].[Errors]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Errors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[LogDate] [datetime] NULL,
	[ErrorMessage] [text] NULL,
	[Url] [varchar](255) NULL,
 CONSTRAINT [PK_Errors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[DeleteUser]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUser]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Users]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadUsersAll]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadUsersAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[EmailAddress],
	[Password],
	[AuthCode]
FROM
	[dbo].[Users]
GO
/****** Object:  StoredProcedure [dbo].[LoadUser]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadUser]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[EmailAddress],
	[Password],
	[AuthCode]
FROM
	[dbo].[Users]
WHERE
	[Id] = @Id
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Locations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Name] [varchar](50) NULL,
	[ApiKey] [uniqueidentifier] NULL,
	[ZipCode] [varchar](50) NULL,
	[ElectricityPrice] [float] NULL,
	[ShareData] [bit] NULL,
	[Timezone] [int] NULL,
	[DaylightSavings] [bit] NULL,
	[HeatFuelPrice] [float] NULL,
	[OpenWeatherCityId] [int] NULL,
 CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SaveCycle]    Script Date: 09/15/2012 14:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveCycle]
	@Id int,
	@ThermostatId int,
	@CycleType varchar(50),
	@StartDate datetime,
	@EndDate datetime,
	@StartPrecision smallint,
	@EndPrecision smallint
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Cycles] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Cycles] SET
		[ThermostatId] = @ThermostatId,
		[CycleType] = @CycleType,
		[StartDate] = @StartDate,
		[EndDate] = @EndDate,
		[StartPrecision] = @StartPrecision,
		[EndPrecision] = @EndPrecision
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Cycles] (
		[ThermostatId],
		[CycleType],
		[StartDate],
		[EndDate],
		[StartPrecision],
		[EndPrecision]
	) VALUES (
		@ThermostatId,
		@CycleType,
		@StartDate,
		@EndDate,
		@StartPrecision,
		@EndPrecision
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUser]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUser]
	@Id int,
	@EmailAddress varchar(255),
	@Password varchar(255)
AS

SET NOCOUNT ON

UPDATE [dbo].[Users] SET
	[EmailAddress] = @EmailAddress,
	[Password] = @Password
WHERE
	[Id] = @Id
GO
/****** Object:  Table [dbo].[UserSettings]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ZipCode] [varchar](50) NULL,
	[FilterChangeDate] [datetime] NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[DeleteCycle]    Script Date: 09/15/2012 14:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteCycle]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Cycles]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[SaveUser]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveUser]
	@Id int,
	@EmailAddress varchar(255),
	@Password varchar(255),
	@AuthCode varchar(255)
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Users] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Users] SET
		[EmailAddress] = @EmailAddress,
		[Password] = @Password,
		[AuthCode] = @AuthCode
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Users] (
		[EmailAddress],
		[Password],
		[AuthCode]
	) VALUES (
		@EmailAddress,
		@Password,
		@AuthCode
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveUserSetting]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveUserSetting]
	@Id int,
	@ZipCode varchar(50),
	@FilterChangeDate datetime,
	@UserId int
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[UserSettings] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[UserSettings] SET
		[ZipCode] = @ZipCode,
		[FilterChangeDate] = @FilterChangeDate,
		[UserId] = @UserId
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[UserSettings] (
		[ZipCode],
		[FilterChangeDate],
		[UserId]
	) VALUES (
		@ZipCode,
		@FilterChangeDate,
		@UserId
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveLocation]    Script Date: 09/15/2012 14:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveLocation]
	@Id int,
	@UserId int,
	@Name varchar(50),
	@ApiKey uniqueidentifier,
	@ZipCode varchar(50),
	@ElectricityPrice float,
	@ShareData bit,
	@Timezone int,
	@DaylightSavings bit,
	@HeatFuelPrice float,
	@OpenWeatherCityId int
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Locations] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Locations] SET
		[UserId] = @UserId,
		[Name] = @Name,
		[ApiKey] = @ApiKey,
		[ZipCode] = @ZipCode,
		[ElectricityPrice] = @ElectricityPrice,
		[ShareData] = @ShareData,
		[Timezone] = @Timezone,
		[DaylightSavings] = @DaylightSavings,
		[HeatFuelPrice] = @HeatFuelPrice,
		[OpenWeatherCityId] = @OpenWeatherCityId
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Locations] (
		[UserId],
		[Name],
		[ApiKey],
		[ZipCode],
		[ElectricityPrice],
		[ShareData],
		[Timezone],
		[DaylightSavings],
		[HeatFuelPrice],
		[OpenWeatherCityId]
	) VALUES (
		@UserId,
		@Name,
		@ApiKey,
		@ZipCode,
		@ElectricityPrice,
		@ShareData,
		@Timezone,
		@DaylightSavings,
		@HeatFuelPrice,
		@OpenWeatherCityId
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveError]    Script Date: 09/15/2012 14:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveError]
	@Id int,
	@UserId int,
	@LogDate datetime,
	@ErrorMessage text,
	@Url varchar(255)
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Errors] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Errors] SET
		[UserId] = @UserId,
		[LogDate] = @LogDate,
		[ErrorMessage] = @ErrorMessage,
		[Url] = @Url
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Errors] (
		[UserId],
		[LogDate],
		[ErrorMessage],
		[Url]
	) VALUES (
		@UserId,
		@LogDate,
		@ErrorMessage,
		@Url
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  Table [dbo].[Thermostats]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Thermostats](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IpAddress] [varchar](50) NULL,
	[DisplayName] [varchar](50) NULL,
	[ACTons] [float] NULL,
	[ACSeer] [int] NULL,
	[ACKilowatts] [float] NULL,
	[FanKilowatts] [float] NULL,
	[Brand] [varchar](50) NULL,
	[LocationId] [int] NULL,
	[HeatBtuPerHour] [float] NULL,
	[KeyName] [varchar](50) NULL,
 CONSTRAINT [PK_Thermostats] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[UpdateLocation]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateLocation]
	@Id int,
	@UserId int,
	@Name varchar(50),
	@ApiKey uniqueidentifier,
	@ZipCode varchar(50),
	@ElectricityPrice float,
	@ShareData bit,
	@Timezone int
AS

SET NOCOUNT ON

UPDATE [dbo].[Locations] SET
	[UserId] = @UserId,
	[Name] = @Name,
	[ApiKey] = @ApiKey,
	[ZipCode] = @ZipCode,
	[ElectricityPrice] = @ElectricityPrice,
	[ShareData] = @ShareData,
	[Timezone] = @Timezone
WHERE
	[Id] = @Id
GO
/****** Object:  Table [dbo].[OutsideConditions]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OutsideConditions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Degrees] [int] NULL,
	[LogDate] [datetime] NULL,
	[LocationId] [int] NULL,
 CONSTRAINT [PK_OutsideConditions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_OutsideConditions] ON [dbo].[OutsideConditions] 
(
	[LocationId] ASC,
	[LogDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[LoadUserSettingsByUserId]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadUserSettingsByUserId]
	@UserId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ZipCode],
	[FilterChangeDate],
	[UserId]
FROM
	[dbo].[UserSettings]
WHERE
	[UserId] = @UserId
GO
/****** Object:  StoredProcedure [dbo].[LoadUserSettingsAll]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadUserSettingsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ZipCode],
	[FilterChangeDate],
	[UserId]
FROM
	[dbo].[UserSettings]
GO
/****** Object:  StoredProcedure [dbo].[LoadUserSetting]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadUserSetting]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ZipCode],
	[FilterChangeDate],
	[UserId]
FROM
	[dbo].[UserSettings]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteUserSetting]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUserSetting]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[UserSettings]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteLocation]    Script Date: 09/15/2012 14:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteLocation]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Locations]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteError]    Script Date: 09/15/2012 14:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteError]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Errors]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadLocationsByUserId]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadLocationsByUserId]
	@UserId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[Name],
	[ApiKey],
	[ZipCode],
	[ElectricityPrice],
	[ShareData],
	[Timezone],
	[DaylightSavings],
	[HeatFuelPrice],
	[OpenWeatherCityId]
FROM
	[dbo].[Locations]
WHERE
	[UserId] = @UserId
GO
/****** Object:  StoredProcedure [dbo].[LoadLocationsAll]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadLocationsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[Name],
	[ApiKey],
	[ZipCode],
	[ElectricityPrice],
	[ShareData],
	[Timezone],
	[DaylightSavings],
	[HeatFuelPrice],
	[OpenWeatherCityId]
FROM
	[dbo].[Locations]
GO
/****** Object:  StoredProcedure [dbo].[LoadLocation]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadLocation]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[Name],
	[ApiKey],
	[ZipCode],
	[ElectricityPrice],
	[ShareData],
	[Timezone],
	[DaylightSavings],
	[HeatFuelPrice],
	[OpenWeatherCityId]
FROM
	[dbo].[Locations]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadErrorsByUserId]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadErrorsByUserId]
	@UserId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[LogDate],
	[ErrorMessage],
	[Url]
FROM
	[dbo].[Errors]
WHERE
	[UserId] = @UserId
GO
/****** Object:  StoredProcedure [dbo].[LoadErrorsAll]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadErrorsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[LogDate],
	[ErrorMessage],
	[Url]
FROM
	[dbo].[Errors]
GO
/****** Object:  StoredProcedure [dbo].[LoadError]    Script Date: 09/15/2012 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadError]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[LogDate],
	[ErrorMessage],
	[Url]
FROM
	[dbo].[Errors]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadOutsideConditionsByZipCodeId]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadOutsideConditionsByZipCodeId]
	@ZipCodeId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ZipCodeId],
	[Degrees]
FROM
	[dbo].[OutsideConditions]
WHERE
	[ZipCodeId] = @ZipCodeId
GO
/****** Object:  StoredProcedure [dbo].[LoadOutsideConditionsByUserId]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadOutsideConditionsByUserId]
	@UserId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[Degrees],
	[LogDate],
	[LocationId]
FROM
	[dbo].[OutsideConditions]
WHERE
	[UserId] = @UserId
GO
/****** Object:  StoredProcedure [dbo].[LoadOutsideConditionsByLocationId]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadOutsideConditionsByLocationId]
	@LocationId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[Degrees],
	[LogDate],
	[LocationId]
FROM
	[dbo].[OutsideConditions]
WHERE
	[LocationId] = @LocationId
GO
/****** Object:  StoredProcedure [dbo].[LoadOutsideConditionsAll]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadOutsideConditionsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[Degrees],
	[LogDate],
	[LocationId]
FROM
	[dbo].[OutsideConditions]
GO
/****** Object:  StoredProcedure [dbo].[LoadOutsideCondition]    Script Date: 09/15/2012 14:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadOutsideCondition]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[Degrees],
	[LogDate],
	[LocationId]
FROM
	[dbo].[OutsideConditions]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteOutsideCondition]    Script Date: 09/15/2012 14:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteOutsideCondition]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[OutsideConditions]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteThermostat]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteThermostat]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Thermostats]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadThermostatsByUserId]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadThermostatsByUserId]
	@UserId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[IpAddress],
	[DisplayName],
	[UserId],
	[ACTons],
	[ACSeer],
	[ACKilowatts],
	[FanKilowatts],
	[Brand],
	[LocationId]
FROM
	[dbo].[Thermostats]
WHERE
	[UserId] = @UserId
GO
/****** Object:  StoredProcedure [dbo].[LoadThermostatsByLocationId]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadThermostatsByLocationId]
	@LocationId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[IpAddress],
	[DisplayName],
	[ACTons],
	[ACSeer],
	[ACKilowatts],
	[FanKilowatts],
	[Brand],
	[LocationId],
	[HeatBtuPerHour],
	[KeyName]
FROM
	[dbo].[Thermostats]
WHERE
	[LocationId] = @LocationId
GO
/****** Object:  StoredProcedure [dbo].[LoadThermostatsAll]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadThermostatsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[IpAddress],
	[DisplayName],
	[ACTons],
	[ACSeer],
	[ACKilowatts],
	[FanKilowatts],
	[Brand],
	[LocationId],
	[HeatBtuPerHour],
	[KeyName]
FROM
	[dbo].[Thermostats]
GO
/****** Object:  StoredProcedure [dbo].[LoadThermostat]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadThermostat]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[IpAddress],
	[DisplayName],
	[ACTons],
	[ACSeer],
	[ACKilowatts],
	[FanKilowatts],
	[Brand],
	[LocationId],
	[HeatBtuPerHour],
	[KeyName]
FROM
	[dbo].[Thermostats]
WHERE
	[Id] = @Id
GO
/****** Object:  Table [dbo].[TransitionStats]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TransitionStats](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ThermostatId] [int] NULL,
	[TransitionType] [varchar](50) NULL,
	[TemperatureDelta] [int] NULL,
	[MinutesPerDegree] [float] NULL,
	[Occurances] [int] NULL,
 CONSTRAINT [PK_TransitionStats] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Temperatures]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Temperatures](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ThermostatId] [int] NULL,
	[LogDate] [datetime] NULL,
	[Degrees] [float] NULL,
	[Precision] [smallint] NULL,
 CONSTRAINT [PK_Temperatures] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Temperatures] ON [dbo].[Temperatures] 
(
	[ThermostatId] ASC,
	[LogDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Snapshots]    Script Date: 09/15/2012 14:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Snapshots](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ThermostatId] [int] NULL,
	[StartTime] [datetime] NULL,
	[Seconds] [int] NULL,
	[Mode] [varchar](50) NULL,
	[InsideTempHigh] [int] NULL,
	[InsideTempLow] [int] NULL,
	[InsideTempAverage] [int] NULL,
	[OutsideTempHigh] [int] NULL,
	[OutsideTempLow] [int] NULL,
	[OutsideTempAverage] [int] NULL,
 CONSTRAINT [PK_Snapshots] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_Snapshots] ON [dbo].[Snapshots] 
(
	[ThermostatId] ASC,
	[StartTime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SaveOutsideCondition]    Script Date: 09/15/2012 14:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveOutsideCondition]
	@Id int,
	@Degrees int,
	@LogDate datetime,
	@LocationId int
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[OutsideConditions] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[OutsideConditions] SET
		[Degrees] = @Degrees,
		[LogDate] = @LogDate,
		[LocationId] = @LocationId
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[OutsideConditions] (
		[Degrees],
		[LogDate],
		[LocationId]
	) VALUES (
		@Degrees,
		@LogDate,
		@LocationId
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveThermostat]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveThermostat]
	@Id int,
	@IpAddress varchar(50),
	@DisplayName varchar(50),
	@ACTons float,
	@ACSeer int,
	@ACKilowatts float,
	@FanKilowatts float,
	@Brand varchar(50),
	@LocationId int,
	@HeatBtuPerHour float,
	@KeyName varchar(50)
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Thermostats] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Thermostats] SET
		[IpAddress] = @IpAddress,
		[DisplayName] = @DisplayName,
		[ACTons] = @ACTons,
		[ACSeer] = @ACSeer,
		[ACKilowatts] = @ACKilowatts,
		[FanKilowatts] = @FanKilowatts,
		[Brand] = @Brand,
		[LocationId] = @LocationId,
		[HeatBtuPerHour] = @HeatBtuPerHour,
		[KeyName] = @KeyName
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Thermostats] (
		[IpAddress],
		[DisplayName],
		[ACTons],
		[ACSeer],
		[ACKilowatts],
		[FanKilowatts],
		[Brand],
		[LocationId],
		[HeatBtuPerHour],
		[KeyName]
	) VALUES (
		@IpAddress,
		@DisplayName,
		@ACTons,
		@ACSeer,
		@ACKilowatts,
		@FanKilowatts,
		@Brand,
		@LocationId,
		@HeatBtuPerHour,
		@KeyName
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveTransitionStat]    Script Date: 09/15/2012 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveTransitionStat]
	@Id int,
	@ThermostatId int,
	@TransitionType varchar(50),
	@TemperatureDelta int,
	@MinutesPerDegree float,
	@Occurances int
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[TransitionStats] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[TransitionStats] SET
		[ThermostatId] = @ThermostatId,
		[TransitionType] = @TransitionType,
		[TemperatureDelta] = @TemperatureDelta,
		[MinutesPerDegree] = @MinutesPerDegree,
		[Occurances] = @Occurances
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[TransitionStats] (
		[ThermostatId],
		[TransitionType],
		[TemperatureDelta],
		[MinutesPerDegree],
		[Occurances]
	) VALUES (
		@ThermostatId,
		@TransitionType,
		@TemperatureDelta,
		@MinutesPerDegree,
		@Occurances
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveTemperature]    Script Date: 09/15/2012 14:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveTemperature]
	@Id int,
	@ThermostatId int,
	@LogDate datetime,
	@Degrees float,
	@Precision smallint
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Temperatures] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Temperatures] SET
		[ThermostatId] = @ThermostatId,
		[LogDate] = @LogDate,
		[Degrees] = @Degrees,
		[Precision] = @Precision
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Temperatures] (
		[ThermostatId],
		[LogDate],
		[Degrees],
		[Precision]
	) VALUES (
		@ThermostatId,
		@LogDate,
		@Degrees,
		@Precision
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveSnapshot]    Script Date: 09/15/2012 14:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveSnapshot]
	@Id int,
	@ThermostatId int,
	@StartTime datetime,
	@Seconds int,
	@Mode varchar(50),
	@InsideTempHigh int,
	@InsideTempLow int,
	@InsideTempAverage int,
	@OutsideTempHigh int,
	@OutsideTempLow int,
	@OutsideTempAverage int
AS

SET NOCOUNT ON

IF EXISTS(SELECT [Id] FROM [dbo].[Snapshots] WHERE [Id] = @Id)
BEGIN
	UPDATE [dbo].[Snapshots] SET
		[ThermostatId] = @ThermostatId,
		[StartTime] = @StartTime,
		[Seconds] = @Seconds,
		[Mode] = @Mode,
		[InsideTempHigh] = @InsideTempHigh,
		[InsideTempLow] = @InsideTempLow,
		[InsideTempAverage] = @InsideTempAverage,
		[OutsideTempHigh] = @OutsideTempHigh,
		[OutsideTempLow] = @OutsideTempLow,
		[OutsideTempAverage] = @OutsideTempAverage
	WHERE
		[Id] = @Id
		
	; SELECT @Id;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Snapshots] (
		[ThermostatId],
		[StartTime],
		[Seconds],
		[Mode],
		[InsideTempHigh],
		[InsideTempLow],
		[InsideTempAverage],
		[OutsideTempHigh],
		[OutsideTempLow],
		[OutsideTempAverage]
	) VALUES (
		@ThermostatId,
		@StartTime,
		@Seconds,
		@Mode,
		@InsideTempHigh,
		@InsideTempLow,
		@InsideTempAverage,
		@OutsideTempHigh,
		@OutsideTempLow,
		@OutsideTempAverage
	)
	
	; SELECT @@Identity;
END
GO
/****** Object:  StoredProcedure [dbo].[LoadTransitionStatsByUserId]    Script Date: 09/15/2012 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadTransitionStatsByUserId]
	@UserId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[UserId],
	[TransitionType],
	[TemperatureDelta],
	[MinutesPerDegree],
	[Occurances]
FROM
	[dbo].[TransitionStats]
WHERE
	[UserId] = @UserId
GO
/****** Object:  StoredProcedure [dbo].[LoadTransitionStatsByThermostatId]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadTransitionStatsByThermostatId]
	@ThermostatId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[TransitionType],
	[TemperatureDelta],
	[MinutesPerDegree],
	[Occurances]
FROM
	[dbo].[TransitionStats]
WHERE
	[ThermostatId] = @ThermostatId
GO
/****** Object:  StoredProcedure [dbo].[LoadTransitionStatsAll]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadTransitionStatsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[TransitionType],
	[TemperatureDelta],
	[MinutesPerDegree],
	[Occurances]
FROM
	[dbo].[TransitionStats]
GO
/****** Object:  StoredProcedure [dbo].[LoadTransitionStat]    Script Date: 09/15/2012 14:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadTransitionStat]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[TransitionType],
	[TemperatureDelta],
	[MinutesPerDegree],
	[Occurances]
FROM
	[dbo].[TransitionStats]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadTemperaturesByThermostatId]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadTemperaturesByThermostatId]
	@ThermostatId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[LogDate],
	[Degrees],
	[Precision]
FROM
	[dbo].[Temperatures]
WHERE
	[ThermostatId] = @ThermostatId
GO
/****** Object:  StoredProcedure [dbo].[LoadTemperaturesAll]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadTemperaturesAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[LogDate],
	[Degrees],
	[Precision]
FROM
	[dbo].[Temperatures]
GO
/****** Object:  StoredProcedure [dbo].[LoadTemperature]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadTemperature]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[LogDate],
	[Degrees],
	[Precision]
FROM
	[dbo].[Temperatures]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[LoadSnapshotsByThermostatId]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadSnapshotsByThermostatId]
	@ThermostatId int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[StartTime],
	[Seconds],
	[Mode],
	[InsideTempHigh],
	[InsideTempLow],
	[InsideTempAverage],
	[OutsideTempHigh],
	[OutsideTempLow],
	[OutsideTempAverage]
FROM
	[dbo].[Snapshots]
WHERE
	[ThermostatId] = @ThermostatId
GO
/****** Object:  StoredProcedure [dbo].[LoadSnapshotsAll]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadSnapshotsAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[StartTime],
	[Seconds],
	[Mode],
	[InsideTempHigh],
	[InsideTempLow],
	[InsideTempAverage],
	[OutsideTempHigh],
	[OutsideTempLow],
	[OutsideTempAverage]
FROM
	[dbo].[Snapshots]
GO
/****** Object:  StoredProcedure [dbo].[LoadSnapshot]    Script Date: 09/15/2012 14:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoadSnapshot]
	@Id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Id],
	[ThermostatId],
	[StartTime],
	[Seconds],
	[Mode],
	[InsideTempHigh],
	[InsideTempLow],
	[InsideTempAverage],
	[OutsideTempHigh],
	[OutsideTempLow],
	[OutsideTempAverage]
FROM
	[dbo].[Snapshots]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteTransitionStat]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTransitionStat]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[TransitionStats]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteTemperature]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTemperature]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Temperatures]
WHERE
	[Id] = @Id
GO
/****** Object:  StoredProcedure [dbo].[DeleteSnapshot]    Script Date: 09/15/2012 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSnapshot]
	@Id int
AS

SET NOCOUNT ON

DELETE FROM [dbo].[Snapshots]
WHERE
	[Id] = @Id
GO
/****** Object:  ForeignKey [FK_Errors_Users]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[Errors]  WITH NOCHECK ADD  CONSTRAINT [FK_Errors_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[Errors] NOCHECK CONSTRAINT [FK_Errors_Users]
GO
/****** Object:  ForeignKey [FK_Locations_Users]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[Locations]  WITH NOCHECK ADD  CONSTRAINT [FK_Locations_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[Locations] NOCHECK CONSTRAINT [FK_Locations_Users]
GO
/****** Object:  ForeignKey [FK_OutsideConditions_Locations]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[OutsideConditions]  WITH NOCHECK ADD  CONSTRAINT [FK_OutsideConditions_Locations] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Locations] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[OutsideConditions] NOCHECK CONSTRAINT [FK_OutsideConditions_Locations]
GO
/****** Object:  ForeignKey [FK_Snapshots_Thermostats]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[Snapshots]  WITH NOCHECK ADD  CONSTRAINT [FK_Snapshots_Thermostats] FOREIGN KEY([ThermostatId])
REFERENCES [dbo].[Thermostats] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[Snapshots] NOCHECK CONSTRAINT [FK_Snapshots_Thermostats]
GO
/****** Object:  ForeignKey [FK_Temperatures_Thermostats]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[Temperatures]  WITH NOCHECK ADD  CONSTRAINT [FK_Temperatures_Thermostats] FOREIGN KEY([ThermostatId])
REFERENCES [dbo].[Thermostats] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[Temperatures] NOCHECK CONSTRAINT [FK_Temperatures_Thermostats]
GO
/****** Object:  ForeignKey [FK_Thermostats_Locations]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[Thermostats]  WITH NOCHECK ADD  CONSTRAINT [FK_Thermostats_Locations] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Locations] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[Thermostats] NOCHECK CONSTRAINT [FK_Thermostats_Locations]
GO
/****** Object:  ForeignKey [FK_TransitionStats_Thermostats]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[TransitionStats]  WITH NOCHECK ADD  CONSTRAINT [FK_TransitionStats_Thermostats] FOREIGN KEY([ThermostatId])
REFERENCES [dbo].[Thermostats] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[TransitionStats] NOCHECK CONSTRAINT [FK_TransitionStats_Thermostats]
GO
/****** Object:  ForeignKey [FK_Settings_Users]    Script Date: 09/15/2012 14:16:28 ******/
ALTER TABLE [dbo].[UserSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_Settings_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[UserSettings] NOCHECK CONSTRAINT [FK_Settings_Users]
GO
