﻿CREATE TABLE [dbo].[EXAMSITTINGDATE] (
    [EXAMSITTINGDATEID] CHAR (36) NOT NULL,
    [EXAMOBJECTID]      CHAR (36) NOT NULL,
    [STARTDATE]         DATETIME  NULL,
    [ENDDATE]           DATETIME  NULL,
    [CUTOFFDATE]        DATETIME  NULL,
    CONSTRAINT [PK_EXAMSITTINGDATE] PRIMARY KEY NONCLUSTERED ([EXAMSITTINGDATEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [EXAMSITTINGDATE_IX_EXAMOBJECTID]
    ON [dbo].[EXAMSITTINGDATE]([EXAMOBJECTID] ASC);


GO

CREATE TRIGGER [dbo].[TG_EXAMSITTINGDATE_DELETE] ON [dbo].[EXAMSITTINGDATE]
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
			[EXAMLOCATION].[EXAMLOCATIONID],
			[EXAMLOCATION].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Exam Location Sitting Date Deleted',
			'',
			'',
			'Exam Location (' + [EXAMLOCATION].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),'[none]') + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			3,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			INNER JOIN [EXAMLOCATION] ON [EXAMLOCATION].[EXAMLOCATIONID] = [deleted].[EXAMOBJECTID]
	UNION ALL

	SELECT
			[EXAMTYPE].[EXAMTYPEID],
			[EXAMTYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Exam Type Sitting Date Deleted',
			'',
			'',
			'Exam Type (' + [EXAMTYPE].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),'[none]') + ')',
			'B4DF1B5F-9A50-4053-8695-EE3A78674DCF',
			3,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			INNER JOIN [EXAMTYPE] ON [EXAMTYPE].[EXAMTYPEID] = [deleted].[EXAMOBJECTID]
END
GO

CREATE TRIGGER [dbo].[TG_EXAMSITTINGDATE_UPDATE] ON [dbo].[EXAMSITTINGDATE] 
	AFTER UPDATE
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
			[EXAMLOCATION].[EXAMLOCATIONID],
			[EXAMLOCATION].[ROWVERSION],
			GETUTCDATE(),
			[EXAMLOCATION].[LASTCHANGEDBY],
			'Exam Sitting Start Date',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]'),
			'Exam Location (' + [EXAMLOCATION].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSITTINGDATEID] = [inserted].[EXAMSITTINGDATEID]
			INNER JOIN [EXAMLOCATION] ON [EXAMLOCATION].[EXAMLOCATIONID] = [inserted].[EXAMOBJECTID]
	WHERE	ISNULL([deleted].[STARTDATE], '') <> ISNULL([inserted].[STARTDATE], '')
	
	UNION ALL
	SELECT
			[EXAMTYPE].[EXAMTYPEID],
			[EXAMTYPE].[ROWVERSION],
			GETUTCDATE(),
			[EXAMTYPE].[LASTCHANGEDBY],
			'Exam Sitting Start Date',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]'),
			'Exam Type (' + [EXAMTYPE].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'B4DF1B5F-9A50-4053-8695-EE3A78674DCF',
			2,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSITTINGDATEID] = [inserted].[EXAMSITTINGDATEID]
			INNER JOIN [EXAMTYPE] ON [EXAMTYPE].[EXAMTYPEID] = [inserted].[EXAMOBJECTID]
	WHERE	ISNULL([deleted].[STARTDATE], '') <> ISNULL([inserted].[STARTDATE], '')
	
	UNION ALL
	SELECT
			[EXAMLOCATION].[EXAMLOCATIONID],
			[EXAMLOCATION].[ROWVERSION],
			GETUTCDATE(),
			[EXAMLOCATION].[LASTCHANGEDBY],
			'Exam Sitting End Date',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[ENDDATE], 101),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[ENDDATE], 101),'[none]'),
			'Exam Location (' + [EXAMLOCATION].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSITTINGDATEID] = [inserted].[EXAMSITTINGDATEID]
			INNER JOIN [EXAMLOCATION] ON [EXAMLOCATION].[EXAMLOCATIONID] = [inserted].[EXAMOBJECTID]
	WHERE	ISNULL([deleted].[ENDDATE], '') <> ISNULL([inserted].[ENDDATE], '')

	UNION ALL
	SELECT
			[EXAMTYPE].[EXAMTYPEID],
			[EXAMTYPE].[ROWVERSION],
			GETUTCDATE(),
			[EXAMTYPE].[LASTCHANGEDBY],
			'Exam Sitting End Date',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[ENDDATE], 101),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[ENDDATE], 101),'[none]'),
			'Exam Type (' + [EXAMTYPE].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'B4DF1B5F-9A50-4053-8695-EE3A78674DCF',
			2,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSITTINGDATEID] = [inserted].[EXAMSITTINGDATEID]
			INNER JOIN [EXAMTYPE] ON [EXAMTYPE].[EXAMTYPEID] = [inserted].[EXAMOBJECTID]
	WHERE	ISNULL([deleted].[ENDDATE], '') <> ISNULL([inserted].[ENDDATE], '')

	UNION ALL
	SELECT
			[EXAMLOCATION].[EXAMLOCATIONID],
			[EXAMLOCATION].[ROWVERSION],
			GETUTCDATE(),
			[EXAMLOCATION].[LASTCHANGEDBY],
			'Exam Cut-Off Date',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[CUTOFFDATE], 101),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[CUTOFFDATE], 101),'[none]'),
			'Exam Location (' + [EXAMLOCATION].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSITTINGDATEID] = [inserted].[EXAMSITTINGDATEID]
			INNER JOIN [EXAMLOCATION] ON [EXAMLOCATION].[EXAMLOCATIONID] = [inserted].[EXAMOBJECTID]
	WHERE	ISNULL([deleted].[CUTOFFDATE], '') <> ISNULL([inserted].[CUTOFFDATE], '')

	UNION ALL
	SELECT
			[EXAMTYPE].[EXAMTYPEID],
			[EXAMTYPE].[ROWVERSION],
			GETUTCDATE(),
			[EXAMTYPE].[LASTCHANGEDBY],
			'Exam Cut-Off Date',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[CUTOFFDATE], 101),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[CUTOFFDATE], 101),'[none]'),
			'Exam Type (' + [EXAMTYPE].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'B4DF1B5F-9A50-4053-8695-EE3A78674DCF',
			2,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSITTINGDATEID] = [inserted].[EXAMSITTINGDATEID]
			INNER JOIN [EXAMTYPE] ON [EXAMTYPE].[EXAMTYPEID] = [inserted].[EXAMOBJECTID]
	WHERE	ISNULL([deleted].[CUTOFFDATE], '') <> ISNULL([inserted].[CUTOFFDATE], '')
END
GO

CREATE TRIGGER [dbo].[TG_EXAMSITTINGDATE_INSERT] ON [dbo].[EXAMSITTINGDATE]
   FOR INSERT
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
			[EXAMLOCATION].[EXAMLOCATIONID],
			[EXAMLOCATION].[ROWVERSION],
			GETUTCDATE(),
			[EXAMLOCATION].[LASTCHANGEDBY],
			'Exam Location Sitting Date Added',
			'',
			'',
			'Exam Location (' + [EXAMLOCATION].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			1,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[inserted]
			INNER JOIN [EXAMLOCATION] ON [EXAMLOCATION].[EXAMLOCATIONID] = [inserted].[EXAMOBJECTID]
	UNION ALL

	SELECT
			[EXAMTYPE].[EXAMTYPEID],
			[EXAMTYPE].[ROWVERSION],
			GETUTCDATE(),
			[EXAMTYPE].[LASTCHANGEDBY],
			'Exam Type Sitting Date Added',
			'',
			'',
			'Exam Type (' + [EXAMTYPE].[NAME] + '), Sitting Date Start Date (' + ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]') + ')',
			'B4DF1B5F-9A50-4053-8695-EE3A78674DCF',
			1,
			0,
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),'[none]')
	FROM	[inserted]
			INNER JOIN [EXAMTYPE] ON [EXAMTYPE].[EXAMTYPEID] = [inserted].[EXAMOBJECTID]

END