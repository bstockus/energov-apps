﻿CREATE TABLE [dbo].[CACPITYPEXREF] (
    [CACPITYPEXREFID] CHAR (36) NOT NULL,
    [CACPITYPEID]     CHAR (36) NOT NULL,
    [CACPIID]         CHAR (36) NOT NULL,
    CONSTRAINT [PK_CACPITYPEXREF] PRIMARY KEY CLUSTERED ([CACPITYPEXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CACPITYPEXREF_CACPI] FOREIGN KEY ([CACPIID]) REFERENCES [dbo].[CACPI] ([CACPIID]),
    CONSTRAINT [FK_CACPITYPEXREF_CACPITYPE] FOREIGN KEY ([CACPITYPEID]) REFERENCES [dbo].[CACPITYPE] ([CACPITYPEID])
);


GO


CREATE TRIGGER [TG_CACPITYPEXREF_DELETE] ON CACPITYPEXREF
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
			[CACPITYPE].[CACPITYPEID],
			[CACPITYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'CPI Type - CPI Schedule Deleted',
			'',
			'',
			'CPI Type (' + [CACPITYPE].[NAME] + '), CPI Schedule (' + ISNULL([CACPI].[NAME], '[none]') + ')',
			'0958A99F-2DEB-405C-9E51-147581B13B91',			
			3,
			0,
			ISNULL([CACPI].[NAME], '[none]')
	FROM	[deleted]
	INNER JOIN CACPITYPE ON CACPITYPE.CACPITYPEID = [deleted].CACPITYPEID
	INNER JOIN CACPI ON  [deleted].CACPIID = CACPI.CACPIID
END
GO


CREATE TRIGGER [TG_CACPITYPEXREF_INSERT] ON CACPITYPEXREF
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
			[CACPITYPE].[CACPITYPEID],
			[CACPITYPE].[ROWVERSION],
			GETUTCDATE(),
			[CACPITYPE].[LASTCHANGEDBY],
			'CPI Type - CPI Schedule Added',
			'',
			'',			
			'CPI Type (' + [CACPITYPE].[NAME] + '), CPI Schedule (' + ISNULL([CACPI].[NAME], '[none]') + ')',
			'0958A99F-2DEB-405C-9E51-147581B13B91',			
			1,
			0,
			ISNULL([CACPI].[NAME], '[none]')
	FROM	[inserted]
	INNER JOIN CACPI ON [inserted].CACPIID = CACPI.CACPIID
	INNER JOIN CACPITYPE ON CACPITYPE.CACPITYPEID = [inserted].CACPITYPEID
END