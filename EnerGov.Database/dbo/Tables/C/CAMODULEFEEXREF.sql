﻿CREATE TABLE [dbo].[CAMODULEFEEXREF] (
    [CAMODULEFEEXREFID]                    CHAR (36) NOT NULL,
    [CAMODULEID]                           INT       NOT NULL,
    [CAFEEID]                              CHAR (36) NOT NULL,
    [CACPIREFERENCEDATEID]                 CHAR (36) NULL,
    [CACOMPOUNDINGINTERESTREFERENCEDATEID] CHAR (36) NULL,
    CONSTRAINT [PK_CAModuleFeeXRef] PRIMARY KEY CLUSTERED ([CAMODULEFEEXREFID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CAMODFEEXREF_CACPIREFDATE] FOREIGN KEY ([CACPIREFERENCEDATEID]) REFERENCES [dbo].[CACPIREFERENCEDATE] ([CACPIREFERENCEDATEID]),
    CONSTRAINT [FK_CAMODULEFEEXREF_CACOMPOUNDINGINTREFDATE] FOREIGN KEY ([CACOMPOUNDINGINTERESTREFERENCEDATEID]) REFERENCES [dbo].[CACOMPOUNDINGINTERESTREFERENCEDATE] ([CACOMPOUNDINGINTERESTREFERENCEDATEID]),
    CONSTRAINT [FK_CAModuleFeeXRef_CAFee] FOREIGN KEY ([CAFEEID]) REFERENCES [dbo].[CAFEE] ([CAFEEID]),
    CONSTRAINT [FK_CAModuleFeeXRef_CAModule] FOREIGN KEY ([CAMODULEID]) REFERENCES [dbo].[CAMODULE] ([CAMODULEID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CAModuleFeeXRef]
    ON [dbo].[CAMODULEFEEXREF]([CAFEEID] ASC, [CAMODULEID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CAMODULEFEEXREF_CAFEEID]
    ON [dbo].[CAMODULEFEEXREF]([CAMODULEID] ASC)
    INCLUDE([CAFEEID]);


GO

CREATE TRIGGER [TG_CAMODULEFEEXREF_DELETE] ON [CAMODULEFEEXREF]
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
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Fee Module Deleted',
			'',
			'',
			'Fee (' + [CAFEE].[NAME] + '), Module (' + [CAMODULE].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			3,
			0,
			[CAMODULE].[NAME]
	FROM	[deleted]	
	INNER JOIN [CAFEE] ON [deleted].[CAFEEID] = [CAFEE].[CAFEEID]
	LEFT JOIN [CAMODULE] ON [deleted].[CAMODULEID] = [CAMODULE].[CAMODULEID]
END
GO
CREATE TRIGGER [TG_CAMODULEFEEXREF_INSERT] ON [CAMODULEFEEXREF]
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
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Fee Module Added',
			'',
			'',
			'Fee (' + [CAFEE].[NAME] + '), Module (' + [CAMODULE].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			1,
			0,
			[CAMODULE].[NAME]
	FROM	[inserted]
	INNER JOIN [CAFEE] ON [inserted].[CAFEEID] = [CAFEE].[CAFEEID]
	LEFT JOIN [CAMODULE] ON [inserted].[CAMODULEID] = [CAMODULE].[CAMODULEID]	
END
GO

CREATE TRIGGER [TG_CAMODULEFEEXREF_UPDATE] ON [CAMODULEFEEXREF]
   AFTER UPDATE
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
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Module',
			[CAMODULE_DELETED].[NAME],
			[CAMODULE_INSERTED].[NAME],
			'Fee (' + [CAFEE].[NAME] + '), Module (' + [CAMODULE_INSERTED].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			[CAMODULE_INSERTED].[NAME]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]		
	INNER JOIN [CAFEE] ON [inserted].[CAFEEID] = [CAFEE].[CAFEEID]	
	INNER JOIN CAMODULE CAMODULE_DELETED WITH (NOLOCK) ON [deleted].[CAMODULEID] = [CAMODULE_DELETED].[CAMODULEID]
	INNER JOIN CAMODULE CAMODULE_INSERTED WITH (NOLOCK) ON [inserted].[CAMODULEID] = [CAMODULE_INSERTED].[CAMODULEID]
	WHERE	[deleted].[CAMODULEID] <> [inserted].[CAMODULEID]
	UNION ALL

	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'CPI Reference Date',
			ISNULL([CACPIREFERENCEDATE_DELETED].[DATEOBJECTFRIENDLYNAME], '[none]'),
			ISNULL([CACPIREFERENCEDATE_INSERTED].[DATEOBJECTFRIENDLYNAME], '[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Module (' + [CAMODULE].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			[CAMODULE].[NAME]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]		
	INNER JOIN [CAFEE] ON [inserted].[CAFEEID] = [CAFEE].[CAFEEID]
	INNER JOIN [CAMODULE] ON [inserted].[CAMODULEID] = [CAMODULE].[CAMODULEID]
	LEFT JOIN CACPIREFERENCEDATE CACPIREFERENCEDATE_DELETED WITH (NOLOCK) ON [deleted].[CACPIREFERENCEDATEID] = [CACPIREFERENCEDATE_DELETED].[CACPIREFERENCEDATEID]
	LEFT JOIN CACPIREFERENCEDATE CACPIREFERENCEDATE_INSERTED WITH (NOLOCK) ON [inserted].[CACPIREFERENCEDATEID] = [CACPIREFERENCEDATE_INSERTED].[CACPIREFERENCEDATEID]
	WHERE	ISNULL([deleted].[CACPIREFERENCEDATEID], '') <> ISNULL([inserted].[CACPIREFERENCEDATEID], '')
	UNION ALL

	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Compounding Interest Reference Date',
			ISNULL([CACOMPOUNDINGINTERESTREFERENCEDATE_DELETED].[DATEOBJECTFRIENDLYNAME], '[none]'),
			ISNULL([CACOMPOUNDINGINTERESTREFERENCEDATE_INSERTED].[DATEOBJECTFRIENDLYNAME], '[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Module (' + [CAMODULE].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			[CAMODULE].[NAME]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]		
	INNER JOIN [CAFEE] ON [inserted].[CAFEEID] = [CAFEE].[CAFEEID]
	INNER JOIN [CAMODULE] ON [inserted].[CAMODULEID] = [CAMODULE].[CAMODULEID]
	LEFT JOIN CACOMPOUNDINGINTERESTREFERENCEDATE CACOMPOUNDINGINTERESTREFERENCEDATE_DELETED WITH (NOLOCK) ON [deleted].[CACOMPOUNDINGINTERESTREFERENCEDATEID] = [CACOMPOUNDINGINTERESTREFERENCEDATE_DELETED].[CACOMPOUNDINGINTERESTREFERENCEDATEID]
	LEFT JOIN CACOMPOUNDINGINTERESTREFERENCEDATE CACOMPOUNDINGINTERESTREFERENCEDATE_INSERTED WITH (NOLOCK) ON [inserted].[CACOMPOUNDINGINTERESTREFERENCEDATEID] = [CACOMPOUNDINGINTERESTREFERENCEDATE_INSERTED].[CACOMPOUNDINGINTERESTREFERENCEDATEID]
	WHERE	ISNULL([deleted].[CACOMPOUNDINGINTERESTREFERENCEDATEID], '') <> ISNULL([inserted].[CACOMPOUNDINGINTERESTREFERENCEDATEID], '')
END