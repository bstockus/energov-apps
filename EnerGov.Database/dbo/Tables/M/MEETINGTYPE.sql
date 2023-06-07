CREATE TABLE [dbo].[MEETINGTYPE] (
    [MEETINGTYPEID]       CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [CUSTOMFIELDLAYOUTID] CHAR (36)      NULL,
    [DEFAULTSUBJECT]      VARCHAR (255)  NULL,
    [DEFAULTLOCATION]     VARCHAR (255)  NULL,
    [DEFAULTCOMMENT]      VARCHAR (MAX)  NULL,
    [STIME]               DATETIME       NULL,
    [ETIME]               DATETIME       NULL,
    [RECURRENCEID]        CHAR (36)      NULL,
    [CONTENTLIMIT]        INT            NULL,
    [LIMIT]               INT            NULL,
    [AVAILINCAP]          BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINCAPCONTACTS]  BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_MEETINGTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_MEETINGTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_MeetingType] PRIMARY KEY CLUSTERED ([MEETINGTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MeetingType_CustomFieldLayout] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_MEETINGTYPE_RECUR] FOREIGN KEY ([RECURRENCEID]) REFERENCES [dbo].[RECURRENCE] ([RECURRENCEID])
);


GO
CREATE NONCLUSTERED INDEX [MEETINGTYPE_IX_QUERY]
    ON [dbo].[MEETINGTYPE]([MEETINGTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_MEETINGTYPE_DELETE] ON [dbo].[MEETINGTYPE]
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
			[deleted].[MEETINGTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Meeting Type Deleted',
			'',
			'',
			'Meeting Type (' + [deleted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_MEETINGTYPE_UPDATE] ON [dbo].[MEETINGTYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of MEETINGTYPE table with USERS table.
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
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID], '') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID], '')	
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Subject',
			ISNULL(CAST([deleted].[DEFAULTSUBJECT] AS NVARCHAR(255)),'[none]'),
			ISNULL(CAST([inserted].[DEFAULTSUBJECT] AS NVARCHAR(255)),'[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[DEFAULTSUBJECT], '') <> ISNULL([inserted].[DEFAULTSUBJECT], '')
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Location',
			ISNULL(CAST([deleted].[DEFAULTLOCATION] AS NVARCHAR(255)),'[none]'),
			ISNULL(CAST([inserted].[DEFAULTLOCATION] AS NVARCHAR(255)),'[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[DEFAULTLOCATION], '') <> ISNULL([inserted].[DEFAULTLOCATION], '')
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Comment',
			ISNULL(CAST([deleted].[DEFAULTCOMMENT] AS NVARCHAR(MAX)),'[none]'),
			ISNULL(CAST([inserted].[DEFAULTCOMMENT] AS NVARCHAR(MAX)),'[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[DEFAULTCOMMENT], '') <> ISNULL([inserted].[DEFAULTCOMMENT], '')
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Start Time',
			ISNULL(CONVERT(nvarchar(max), [deleted].[STIME], 121),'[none]'),
			ISNULL(CONVERT(nvarchar(max), [inserted].[STIME], 121),'[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[STIME],'') <> ISNULL([inserted].[STIME],'')
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default End Time',
			ISNULL(CONVERT(nvarchar(max), [deleted].[ETIME], 121),'[none]'),
			ISNULL(CONVERT(nvarchar(max), [inserted].[ETIME], 121),'[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[ETIME],'') <> ISNULL([inserted].[ETIME],'')
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recurrence',
			ISNULL([RECURRENCE_DELETED].[NAME],'[none]'),
			ISNULL([RECURRENCE_INSERTED].[NAME],'[none]'),
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
			LEFT JOIN [RECURRENCE] RECURRENCE_INSERTED WITH (NOLOCK) ON [RECURRENCE_INSERTED].[RECURRENCEID] = [inserted].[RECURRENCEID]
			LEFT JOIN [RECURRENCE] RECURRENCE_DELETED WITH (NOLOCK) ON [RECURRENCE_DELETED].[RECURRENCEID] = [deleted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[RECURRENCEID], '') <> ISNULL([inserted].[RECURRENCEID], '')	
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Meeting Content Limit',
			CASE
				WHEN [deleted].[CONTENTLIMIT] = 1 THEN 'Limit By Total # of Cases'
				WHEN [deleted].[CONTENTLIMIT] = 2 THEN 'Limit By Specific Case Type' 
				ELSE '[none]'
			END,
			CASE
				WHEN [inserted].[CONTENTLIMIT] = 1 THEN 'Limit By Total # of Cases'
				WHEN [inserted].[CONTENTLIMIT] = 2 THEN 'Limit By Specific Case Type' 
				ELSE '[none]'
			END,
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[CONTENTLIMIT],'') <> ISNULL([inserted].[CONTENTLIMIT],'')
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'# of Cases',
			CASE WHEN [deleted].[LIMIT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[LIMIT]) END,
			CASE WHEN [inserted].[LIMIT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[LIMIT]) END,			
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	ISNULL([deleted].[LIMIT],'') <> ISNULL([inserted].[LIMIT],'')
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available to CAP/CSS Public Flag',
			CASE [deleted].[AVAILINCAP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[AVAILINCAP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	[deleted].[AVAILINCAP] <> [inserted].[AVAILINCAP]
	
	UNION ALL
	SELECT
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available to CAP/CSS Contacts Flag',
			CASE [deleted].[AVAILINCAPCONTACTS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[AVAILINCAPCONTACTS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
	WHERE	[deleted].[AVAILINCAPCONTACTS] <> [inserted].[AVAILINCAPCONTACTS]	
END
GO

CREATE TRIGGER [dbo].[TG_MEETINGTYPE_INSERT] ON [dbo].[MEETINGTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of MEETINGTYPE table with USERS table.
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
			[inserted].[MEETINGTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Meeting Type Added',
			'',
			'',
			'Meeting Type (' + [inserted].[NAME] + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END