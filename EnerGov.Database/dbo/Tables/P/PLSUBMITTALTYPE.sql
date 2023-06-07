﻿CREATE TABLE [dbo].[PLSUBMITTALTYPE] (
    [PLSUBMITTALTYPEID]     CHAR (36)      NOT NULL,
    [TYPENAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [DAYSUNTILDUE]          INT            NULL,
    [PLSUBMITTALSTATUSID]   CHAR (36)      NULL,
    [RESUMITALDAYSUNTILDUE] INT            NULL,
    [COPYFAILEDITEMREVIEW]  BIT            NULL,
    [DESCRIPTION_SPANISH]   NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]         CHAR (36)      NULL,
    [LASTCHANGEDON]         DATETIME       CONSTRAINT [DF_PLSUBMITTALTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT            CONSTRAINT [DF_PLSUBMITTALTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLSubmittalType] PRIMARY KEY CLUSTERED ([PLSUBMITTALTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLSubmittalType_Status] FOREIGN KEY ([PLSUBMITTALSTATUSID]) REFERENCES [dbo].[PLSUBMITTALSTATUS] ([PLSUBMITTALSTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [PLSUBMITTALTYPE_IX_QUERY]
    ON [dbo].[PLSUBMITTALTYPE]([PLSUBMITTALTYPEID] ASC, [TYPENAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_PLSUBMITTALTYPE_DELETE] ON [dbo].[PLSUBMITTALTYPE]
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
			[deleted].[PLSUBMITTALTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Submittal Type Deleted',
			'',
			'',
			'Submittal Type (' + [deleted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			3,
			1,
			[deleted].[TYPENAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_PLSUBMITTALTYPE_UPDATE] ON [dbo].[PLSUBMITTALTYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
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
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[TYPENAME],
			[inserted].[TYPENAME],
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			1,
			[inserted].[TYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
	WHERE	[deleted].[TYPENAME] <> [inserted].[TYPENAME]
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			1,
			[inserted].[TYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days Until Due',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[DAYSUNTILDUE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[DAYSUNTILDUE]),'[none]'),
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			1,
			[inserted].[TYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
	WHERE	ISNULL([deleted].[DAYSUNTILDUE], '') <> ISNULL([inserted].[DAYSUNTILDUE], '')
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([PLSUBMITTALSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([PLSUBMITTALSTATUS_INSERTED].[NAME],'[none]'),
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			1,
			[inserted].[TYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]			
			LEFT JOIN [PLSUBMITTALSTATUS] [PLSUBMITTALSTATUS_INSERTED] WITH (NOLOCK) ON [PLSUBMITTALSTATUS_INSERTED].[PLSUBMITTALSTATUSID] = [inserted].[PLSUBMITTALSTATUSID]
			LEFT JOIN [PLSUBMITTALSTATUS] [PLSUBMITTALSTATUS_DELETED] WITH (NOLOCK) ON [PLSUBMITTALSTATUS_DELETED].[PLSUBMITTALSTATUSID] = [deleted].[PLSUBMITTALSTATUSID]
	WHERE	ISNULL([deleted].[PLSUBMITTALSTATUSID],'') <> ISNULL([inserted].[PLSUBMITTALSTATUSID],'')
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Resubmit Days Until Due',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[RESUMITALDAYSUNTILDUE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[RESUMITALDAYSUNTILDUE]),'[none]'),
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			1,
			[inserted].[TYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
	WHERE	ISNULL([deleted].[RESUMITALDAYSUNTILDUE], '') <> ISNULL([inserted].[RESUMITALDAYSUNTILDUE], '')
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Only Copy Failed Item Review Flag',
			CASE [deleted].[COPYFAILEDITEMREVIEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[COPYFAILEDITEMREVIEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			1,
			[inserted].[TYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
	WHERE	[deleted].[COPYFAILEDITEMREVIEW] <> [inserted].[COPYFAILEDITEMREVIEW]
			OR ([deleted].[COPYFAILEDITEMREVIEW] IS NULL AND [inserted].[COPYFAILEDITEMREVIEW] IS NOT NULL)
			OR ([deleted].[COPYFAILEDITEMREVIEW] IS NOT NULL AND [inserted].[COPYFAILEDITEMREVIEW] IS NULL)
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description Spanish',
			ISNULL([deleted].[DESCRIPTION_SPANISH],'[none]'),
			ISNULL([inserted].[DESCRIPTION_SPANISH],'[none]'),
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			1,
			[inserted].[TYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION_SPANISH], '') <> ISNULL([inserted].[DESCRIPTION_SPANISH], '')
END
GO
CREATE TRIGGER [dbo].[TG_PLSUBMITTALTYPE_INSERT] ON [dbo].[PLSUBMITTALTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
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
			[inserted].[PLSUBMITTALTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Submittal Type Added',
			'',
			'',
			'Submittal Type (' + [inserted].[TYPENAME] + ')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			1,
			1,
			[inserted].[TYPENAME]
	FROM	[inserted]	
END