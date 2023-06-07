﻿CREATE TABLE [dbo].[IMINSPECTIONCALENDAR] (
    [IMINSPECTIONCALENDARID] CHAR (36)     NOT NULL,
    [NAME]                   NVARCHAR (50) NOT NULL,
    [USESYSTEMHOLIDAYS]      BIT           DEFAULT ((0)) NULL,
    [LASTCHANGEDBY]          CHAR (36)     NULL,
    [LASTCHANGEDON]          DATETIME      CONSTRAINT [DF_IMINSPECTIONCALENDAR_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT           CONSTRAINT [DF_IMINSPECTIONCALENDAR_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMINSPECTIONCALENDAR] PRIMARY KEY CLUSTERED ([IMINSPECTIONCALENDARID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTIONCALENDAR_IX_QUERY]
    ON [dbo].[IMINSPECTIONCALENDAR]([IMINSPECTIONCALENDARID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_IMINSPECTIONCALENDAR_INSERT] ON [dbo].[IMINSPECTIONCALENDAR]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONCALENDAR table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
    (
        [ID],
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
        [inserted].[IMINSPECTIONCALENDARID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Inspection Calendar Added',
        '',
        '',
        'Inspection Calendar (' + [inserted].[NAME] + ')',
		'540881BC-B7EC-4CAB-958C-D1820B6FEBAC',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_IMINSPECTIONCALENDAR_UPDATE] ON  [dbo].[IMINSPECTIONCALENDAR]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONCALENDAR table with USERS table.
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
			[inserted].[IMINSPECTIONCALENDARID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Inspection Calendar Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Inspection Calendar (' + [inserted].[NAME] + ')',
			'540881BC-B7EC-4CAB-958C-D1820B6FEBAC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONCALENDARID] = [inserted].[IMINSPECTIONCALENDARID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONCALENDARID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use System Holidays Flag',
			CASE [deleted].[USESYSTEMHOLIDAYS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[USESYSTEMHOLIDAYS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Inspection Calendar (' + [inserted].[NAME] + ')',
			'540881BC-B7EC-4CAB-958C-D1820B6FEBAC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONCALENDARID] = [inserted].[IMINSPECTIONCALENDARID]
	WHERE	([deleted].[USESYSTEMHOLIDAYS] <> [inserted].[USESYSTEMHOLIDAYS]) OR ([deleted].[USESYSTEMHOLIDAYS] IS NULL AND [inserted].[USESYSTEMHOLIDAYS] IS NOT NULL)
			OR ([deleted].[USESYSTEMHOLIDAYS] IS NOT NULL AND [inserted].[USESYSTEMHOLIDAYS] IS NULL)
END
GO

CREATE TRIGGER [dbo].[TG_IMINSPECTIONCALENDAR_DELETE]  ON  [dbo].[IMINSPECTIONCALENDAR]
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
			[deleted].[IMINSPECTIONCALENDARID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Calendar Deleted',
			'',
			'',
			'Inspection Calendar (' + [deleted].[NAME] + ')',
			'540881BC-B7EC-4CAB-958C-D1820B6FEBAC',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END