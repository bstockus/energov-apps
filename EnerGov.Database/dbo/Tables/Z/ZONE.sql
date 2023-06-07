CREATE TABLE [dbo].[ZONE] (
    [ZONEID]        CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [ZONECODE]      NVARCHAR (100) NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_Zone_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_Zone_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Zone] PRIMARY KEY CLUSTERED ([ZONEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ZONE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ZONE_ALL]
    ON [dbo].[ZONE]([ZONEID] ASC)
    INCLUDE([NAME], [ZONECODE]);


GO

CREATE TRIGGER [dbo].[TG_ZONE_INSERT] ON [dbo].[ZONE]
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
        [inserted].[ZONEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Zone Added',
        '',
        '',
        'Zone (' + [inserted].[NAME] + ')',
		'51685303-7B04-4EC2-913B-F579E878FBB9',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_ZONE_UPDATE] ON  [dbo].[ZONE]
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
			[inserted].[ZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Zone (' + [inserted].[NAME] + ')',
			'51685303-7B04-4EC2-913B-F579E878FBB9',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ZONEID] = [inserted].[ZONEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[ZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Zone (' + [inserted].[NAME] + ')',
			'51685303-7B04-4EC2-913B-F579E878FBB9',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ZONEID] = [inserted].[ZONEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[ZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Code',
			ISNULL([deleted].[ZONECODE],'[none]'),
			ISNULL([inserted].[ZONECODE],'[none]'),
			'Zone (' + [inserted].[NAME] + ')',
			'51685303-7B04-4EC2-913B-F579E878FBB9',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ZONEID] = [inserted].[ZONEID]
	WHERE	ISNULL([deleted].[ZONECODE], '') <> ISNULL([inserted].[ZONECODE], '')
END
GO

CREATE TRIGGER [dbo].[TG_ZONE_DELETE]  ON  [dbo].[ZONE]
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
			[deleted].[ZONEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			 'Zone Deleted',
			'',
			'',
			'Zone (' + [deleted].[NAME] + ')',
			'51685303-7B04-4EC2-913B-F579E878FBB9',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END