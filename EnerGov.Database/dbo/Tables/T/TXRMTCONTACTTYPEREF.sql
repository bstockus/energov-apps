﻿CREATE TABLE [dbo].[TXRMTCONTACTTYPEREF] (
    [CONTACTTYPEEXTID]   CHAR (36) NOT NULL,
    [TXREMITTANCETYPEID] CHAR (36) NOT NULL,
    [BLCONTACTTYPEID]    CHAR (36) NOT NULL,
    [CONTACTTYPEGROUPID] INT       NULL,
    [ISREQUIRED]         BIT       NOT NULL,
    PRIMARY KEY CLUSTERED ([CONTACTTYPEEXTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLCONTACTTYPEID] FOREIGN KEY ([BLCONTACTTYPEID]) REFERENCES [dbo].[BLCONTACTTYPE] ([BLCONTACTTYPEID]),
    CONSTRAINT [FK_TXREMITTANCETYPEIDREF] FOREIGN KEY ([TXREMITTANCETYPEID]) REFERENCES [dbo].[TXREMITTANCETYPE] ([TXREMITTANCETYPEID])
);


GO
CREATE NONCLUSTERED INDEX [TXRMTCONTACTTYPEREF_IX_CONTACTTYPEEXTID]
    ON [dbo].[TXRMTCONTACTTYPEREF]([CONTACTTYPEEXTID] ASC);


GO

CREATE TRIGGER [TG_TXRMTCONTACTTYPEREF_UPDATE] ON [TXRMTCONTACTTYPEREF]
	AFTER UPDATE
AS
BEGIN
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
			[TXREMITTANCETYPE].[TXREMITTANCETYPEID],
			[TXREMITTANCETYPE].[ROWVERSION],
			GETUTCDATE(),
			[TXREMITTANCETYPE].[LASTCHANGEDBY],
			'Is Required Flag',
			CASE [deleted].[ISREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Tax Remittance Type (' + [TXREMITTANCETYPE].[NAME] + '), Contact Type ('+ [BLCONTACTTYPE].[NAME] + ')',
			'41E1FC7D-1D43-499B-B40B-7AE70E72A922',
			2,
			0,
			[BLCONTACTTYPE].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TXREMITTANCETYPEID] = [inserted].[TXREMITTANCETYPEID]
			INNER JOIN [TXREMITTANCETYPE] ON [inserted].[TXREMITTANCETYPEID] = [TXREMITTANCETYPE].[TXREMITTANCETYPEID]
			INNER JOIN [BLCONTACTTYPE] WITH (NOLOCK) ON [inserted].[BLCONTACTTYPEID] = [BLCONTACTTYPE].[BLCONTACTTYPEID]
	WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]
	UNION ALL

	SELECT
			[TXREMITTANCETYPE].[TXREMITTANCETYPEID],
			[TXREMITTANCETYPE].[ROWVERSION],
			GETUTCDATE(),
			[TXREMITTANCETYPE].[LASTCHANGEDBY],
			'Contact Group',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[CONTACTTYPEGROUPID]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[CONTACTTYPEGROUPID]),'[none]'),
			'Tax Remittance Type (' + [TXREMITTANCETYPE].[NAME] + '), Contact Type ('+ [BLCONTACTTYPE].[NAME] + ')',
			'41E1FC7D-1D43-499B-B40B-7AE70E72A922',
			2,
			0,
			[BLCONTACTTYPE].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TXREMITTANCETYPEID] = [inserted].[TXREMITTANCETYPEID]
			INNER JOIN [TXREMITTANCETYPE] ON [inserted].[TXREMITTANCETYPEID] = [TXREMITTANCETYPE].[TXREMITTANCETYPEID]
			INNER JOIN [BLCONTACTTYPE] WITH (NOLOCK) ON [inserted].[BLCONTACTTYPEID] = [BLCONTACTTYPE].[BLCONTACTTYPEID]
	WHERE	ISNULL([deleted].[CONTACTTYPEGROUPID], '') <> ISNULL([inserted].[CONTACTTYPEGROUPID], '')
END
GO

CREATE TRIGGER [TG_TXRMTCONTACTTYPEREF_INSERT] ON [TXRMTCONTACTTYPEREF]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

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
			[TXREMITTANCETYPE].[TXREMITTANCETYPEID],
			[TXREMITTANCETYPE].[ROWVERSION],
			GETUTCDATE(),
			[TXREMITTANCETYPE].[LASTCHANGEDBY],
			'Tax Remittance Type Contact Type Added',
			'',
			'',
			'Tax Remittance Type (' + [TXREMITTANCETYPE].[NAME] + '), Contact Type ('+ [BLCONTACTTYPE].[NAME] + ')',
			'41E1FC7D-1D43-499B-B40B-7AE70E72A922',
			1,
			0,
			[BLCONTACTTYPE].[NAME]
	FROM	[inserted]
	INNER JOIN [TXREMITTANCETYPE] ON [inserted].[TXREMITTANCETYPEID] = [TXREMITTANCETYPE].[TXREMITTANCETYPEID]
	INNER JOIN [BLCONTACTTYPE] WITH (NOLOCK) ON [inserted].[BLCONTACTTYPEID] = [BLCONTACTTYPE].[BLCONTACTTYPEID]
END
GO

CREATE TRIGGER [TG_TXRMTCONTACTTYPEREF_DELETE] ON [TXRMTCONTACTTYPEREF]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON

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
			[TXREMITTANCETYPE].[TXREMITTANCETYPEID],
			[TXREMITTANCETYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Tax Remittance Type Contact Type Deleted',
			'',
			'',
			'Tax Remittance Type (' + [TXREMITTANCETYPE].[NAME] + '), Contact Type ('+ [BLCONTACTTYPE].[NAME] + ')',
			'41E1FC7D-1D43-499B-B40B-7AE70E72A922',
			3,
			0,
			[BLCONTACTTYPE].[NAME]
	FROM	[deleted]	
	INNER JOIN [TXREMITTANCETYPE] ON [deleted].[TXREMITTANCETYPEID] = [TXREMITTANCETYPE].[TXREMITTANCETYPEID]
	INNER JOIN [BLCONTACTTYPE] WITH (NOLOCK) ON [deleted].[BLCONTACTTYPEID] = [BLCONTACTTYPE].[BLCONTACTTYPEID]
END