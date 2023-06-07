CREATE TABLE [dbo].[PMPERMITTYPEGROUP] (
    [PMPERMITTYPEGROUPID] CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_PMPERMITTYPEGROUP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_PMPERMITTYPEGROUP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitTypeGroup] PRIMARY KEY CLUSTERED ([PMPERMITTYPEGROUPID] ASC),
    CONSTRAINT [FK_PMPERMITTYPEGROUP_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO

CREATE TRIGGER [dbo].[TG_PMPERMITTYPEGROUP_INSERT] ON [dbo].[PMPERMITTYPEGROUP]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
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
        [inserted].[PMPERMITTYPEGROUPID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Permit Type Group Added',
        '',
        '',
        'Permit Type Group (' + [inserted].[NAME] + ')',
		'65A0E6F4-0B3F-46AD-A28C-0846F7185C88',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITTYPEGROUP_UPDATE] 
   ON  [dbo].[PMPERMITTYPEGROUP]
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
			[inserted].[PMPERMITTYPEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Type Group (' + [inserted].[NAME] + ')',
			'65A0E6F4-0B3F-46AD-A28C-0846F7185C88',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITTYPEGROUPID = [inserted].PMPERMITTYPEGROUPID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PMPERMITTYPEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Permit Type Group (' + [inserted].[NAME] + ')',
			'65A0E6F4-0B3F-46AD-A28C-0846F7185C88',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITTYPEGROUPID = [inserted].PMPERMITTYPEGROUPID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITTYPEGROUP_DELETE]
   ON  [dbo].[PMPERMITTYPEGROUP]
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
			[deleted].[PMPERMITTYPEGROUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Permit Type Group Deleted',
			'',
			'',
			'Permit Type Group (' + [deleted].[NAME] + ')',
			'65A0E6F4-0B3F-46AD-A28C-0846F7185C88',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END