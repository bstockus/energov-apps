﻿CREATE TABLE [dbo].[ILLICENSETYPELICENSEGROUP] (
    [ILLICENSEGROUPID] CHAR (36) NOT NULL,
    [ILLICENSETYPEID]  CHAR (36) NOT NULL,
    CONSTRAINT [PK_ILLicenseTypeLicenseGroup] PRIMARY KEY CLUSTERED ([ILLICENSEGROUPID] ASC, [ILLICENSETYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_LicTypeLicGroup_LicGroup] FOREIGN KEY ([ILLICENSEGROUPID]) REFERENCES [dbo].[ILLICENSEGROUP] ([ILLICENSEGROUPID]),
    CONSTRAINT [FK_LicTypeLicGroup_LicType] FOREIGN KEY ([ILLICENSETYPEID]) REFERENCES [dbo].[ILLICENSETYPE] ([ILLICENSETYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ILLICENSETYPELICENSEGROUP_ILLICENSETYPEID]
    ON [dbo].[ILLICENSETYPELICENSEGROUP]([ILLICENSETYPEID] ASC);


GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPELICENSEGROUP_DELETE]  ON  [dbo].[ILLICENSETYPELICENSEGROUP]
   AFTER DELETE
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
		[ILLICENSETYPE].[ILLICENSETYPEID],
		[ILLICENSETYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Professional License Type Professional License Group Deleted',
        '',
        '',       
		'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), Professional License Group (' + [ILLICENSEGROUP].[NAME] +')',
		'67978C16-D720-4F8E-8120-E00FBB732A77',
		3,
		0,
		[ILLICENSEGROUP].[NAME]
    FROM [deleted]
	INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [deleted].[ILLICENSETYPEID]
	INNER JOIN [ILLICENSEGROUP] WITH (NOLOCK) ON [ILLICENSEGROUP].[ILLICENSEGROUPID] = [deleted].[ILLICENSEGROUPID]
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPELICENSEGROUP_INSERT] ON  [dbo].[ILLICENSETYPELICENSEGROUP]
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
        [ILLICENSETYPE].[ILLICENSETYPEID], 
        [ILLICENSETYPE].[ROWVERSION],
        GETUTCDATE(),
        [ILLICENSETYPE].[LASTCHANGEDBY],	
        'Professional License Type Professional License Group Added',
        '',
        '',       
		'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), Professional License Group (' + [ILLICENSEGROUP].[NAME] +')',
		'67978C16-D720-4F8E-8120-E00FBB732A77',
		1,
		0,
		[ILLICENSEGROUP].[NAME]
    FROM [inserted]
	INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	INNER JOIN [ILLICENSEGROUP] WITH (NOLOCK) ON [ILLICENSEGROUP].[ILLICENSEGROUPID] = [inserted].[ILLICENSEGROUPID]
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPELICENSEGROUP_UPDATE]   ON  [dbo].[ILLICENSETYPELICENSEGROUP] 
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
			[ILLICENSETYPE].[ILLICENSETYPEID], 
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],	
			'Professional License Group',			
			[ILLICENSEGROUP_DELETED].[NAME] ,
			[ILLICENSEGROUP_INSERTED].[NAME] ,
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), Professional License Group (' + [ILLICENSEGROUP_INSERTED].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSEGROUP_INSERTED].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEGROUPID] = [inserted].[ILLICENSEGROUPID]	AND [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSEGROUP] [ILLICENSEGROUP_DELETED] WITH (NOLOCK) ON [ILLICENSEGROUP_DELETED].[ILLICENSEGROUPID] = [deleted].[ILLICENSEGROUPID]
			INNER JOIN [ILLICENSEGROUP] [ILLICENSEGROUP_INSERTED] WITH (NOLOCK) ON [ILLICENSEGROUP_INSERTED].[ILLICENSEGROUPID] = [inserted].[ILLICENSEGROUPID]
	WHERE	[deleted].[ILLICENSEGROUPID] <>[inserted].[ILLICENSEGROUPID]
END