IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'logs'))
BEGIN
	EXEC ('CREATE SCHEMA Logs');
END;

IF OBJECT_ID(N'Logs.Log') IS NULL
BEGIN
	CREATE TABLE [Logs].[Log] (
 
	   [Id] int IDENTITY(1,1) NOT NULL,
	   [Message] nvarchar(max) NULL,
	   [MessageTemplate] nvarchar(max) NULL,
	   [Level] nvarchar(128) NULL,
	   [TimeStamp] datetimeoffset(7) NOT NULL,  
	   [Exception] nvarchar(max) NULL,
	   [Properties] xml NULL,
	   [LogEvent] nvarchar(max) NULL
 
	   CONSTRAINT [PK_Log] 
		 PRIMARY KEY CLUSTERED ([Id] ASC) 
 
	);
END;