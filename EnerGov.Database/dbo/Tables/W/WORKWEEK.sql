CREATE TABLE [dbo].[WORKWEEK] (
    [DAYOFWEEK]     INT       NOT NULL,
    [STARTTIME]     DATETIME  NULL,
    [ENDTIME]       DATETIME  NULL,
    [ISWORKINGDAY]  BIT       CONSTRAINT [DF_WorkWeek_IsWorkingDay] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY] CHAR (36) NULL,
    [LASTCHANGEDON] DATETIME  CONSTRAINT [DF_WORKWEEK_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT       CONSTRAINT [DF_WORKWEEK_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_WorkWeek] PRIMARY KEY CLUSTERED ([DAYOFWEEK] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE TRIGGER [TG_WORKWEEK_INSERT] ON [dbo].[WORKWEEK]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;	
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of WORKWEEK table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )
	SELECT
			[inserted].[DAYOFWEEK],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Work Week Added',
			'',
			'',
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK])),
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			1,
			0,
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK]))
	FROM	[inserted]
END
GO
CREATE TRIGGER [TG_WORKWEEK_UPDATE] ON [dbo].[WORKWEEK]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of WORKWEEK table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )	
	SELECT
			[inserted].[DAYOFWEEK],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Working Day Flag',
			CASE [deleted].[ISWORKINGDAY] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISWORKINGDAY] WHEN 1 THEN 'Yes' ELSE 'No' END,
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK])),
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK]))
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[DAYOFWEEK] = [inserted].[DAYOFWEEK]			
	WHERE	[deleted].[ISWORKINGDAY] <> [inserted].[ISWORKINGDAY]
	UNION ALL

	SELECT
			[inserted].[DAYOFWEEK],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start Time',
			ISNULL(CONVERT(NVARCHAR(MAX),FORMAT([deleted].[STARTTIME],'hh:mm tt')),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),FORMAT([inserted].[STARTTIME],'hh:mm tt')),'[none]'),
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK])),
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK]))
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[DAYOFWEEK] = [inserted].[DAYOFWEEK]
	WHERE	ISNULL([deleted].[STARTTIME], '') <> ISNULL([inserted].[STARTTIME], '')
	UNION ALL

	SELECT
			[inserted].[DAYOFWEEK],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End Time',
			ISNULL(CONVERT(NVARCHAR(MAX),FORMAT([deleted].[ENDTIME],'hh:mm tt')),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),FORMAT([inserted].[ENDTIME],'hh:mm tt')),'[none]'),
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK])),
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([inserted].[DAYOFWEEK]))
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[DAYOFWEEK] = [inserted].[DAYOFWEEK]
	WHERE	ISNULL([deleted].[ENDTIME], '') <> ISNULL([inserted].[ENDTIME], '')
END
GO
CREATE TRIGGER [TG_WORKWEEK_DELETE] ON [dbo].[WORKWEEK]
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
	
    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )	
	SELECT
			[deleted].[DAYOFWEEK],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Work Week Deleted',
			'',
			'',
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([deleted].[DAYOFWEEK])),
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			3,
			0,
			(SELECT [dbo].[UFN_GET_DAY_OF_WEEK_NAME]([deleted].[DAYOFWEEK]))
	FROM	[deleted]
END