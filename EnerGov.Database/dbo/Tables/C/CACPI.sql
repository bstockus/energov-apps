﻿CREATE TABLE [dbo].[CACPI] (
    [CACPIID]     CHAR (36)       NOT NULL,
    [NAME]        NVARCHAR (50)   NULL,
    [DESCRIPTION] NVARCHAR (255)  NULL,
    [STARTDATE]   DATETIME        NOT NULL,
    [ENDDATE]     DATETIME        NOT NULL,
    [CPIVALUE]    DECIMAL (20, 4) NOT NULL,
    CONSTRAINT [PK_CACPI] PRIMARY KEY NONCLUSTERED ([CACPIID] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE TRIGGER [TG_CACPI_UPDATE] ON CACPI
	AFTER UPDATE
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
			'Name',
			ISNULL([deleted].[NAME], '[none]'),
			ISNULL([inserted].[NAME], '[none]'),
			'CPI Type (' + [CACPITYPE].[NAME] + '), CPI Schedule (' + ISNULL([inserted].[NAME], '[none]') + ')',			
			'0958A99F-2DEB-405C-9E51-147581B13B91',			
			2,
			0,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CACPIID] = [inserted].[CACPIID]
	INNER JOIN CACPITYPEXREF ON CACPITYPEXREF.CACPIID = [deleted].CACPIID
	INNER JOIN CACPITYPE ON CACPITYPE.CACPITYPEID = CACPITYPEXREF.CACPITYPEID
	WHERE	ISNULL([deleted].[NAME], '') <> ISNULL([inserted].[NAME], '')
	UNION ALL
	
	SELECT
			[CACPITYPE].[CACPITYPEID],
			[CACPITYPE].[ROWVERSION],
			GETUTCDATE(),
			[CACPITYPE].LASTCHANGEDBY,
			'Description',
			ISNULL([deleted].[DESCRIPTION], '[none]'),
			ISNULL([inserted].[DESCRIPTION], '[none]'),
			'CPI Type (' + [CACPITYPE].[NAME] + '), CPI Schedule (' + ISNULL([inserted].[NAME], '[none]') + ')',			
			'0958A99F-2DEB-405C-9E51-147581B13B91',			
			2,
			0,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CACPIID] = [inserted].[CACPIID]
	INNER JOIN CACPITYPEXREF ON CACPITYPEXREF.CACPIID = [deleted].CACPIID
	INNER JOIN CACPITYPE ON CACPITYPE.CACPITYPEID = CACPITYPEXREF.CACPITYPEID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL

	SELECT
			[CACPITYPE].[CACPITYPEID],
			[CACPITYPE].[ROWVERSION],
			GETUTCDATE(),
			[CACPITYPE].[LASTCHANGEDBY],
			'Start Date',
			CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),
			'CPI Type (' + [CACPITYPE].[NAME] + '), CPI Schedule (' + ISNULL([inserted].[NAME], '[none]') + ')',			
			'0958A99F-2DEB-405C-9E51-147581B13B91',			
			2,
			0,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CACPIID] = [inserted].[CACPIID]
	INNER JOIN CACPITYPEXREF ON CACPITYPEXREF.CACPIID = [deleted].CACPIID
	INNER JOIN CACPITYPE ON CACPITYPE.CACPITYPEID = CACPITYPEXREF.CACPITYPEID
	WHERE	[deleted].[STARTDATE] <> [inserted].[STARTDATE]
	UNION ALL

	SELECT
			[CACPITYPE].[CACPITYPEID],
			[CACPITYPE].[ROWVERSION],
			GETUTCDATE(),
			[CACPITYPE].[LASTCHANGEDBY],
			'End Date',
			CONVERT(NVARCHAR(MAX), [deleted].[ENDDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[ENDDATE], 101),
			'CPI Type (' + [CACPITYPE].[NAME] + '), CPI Schedule (' + ISNULL([inserted].[NAME], '[none]') + ')',			
			'0958A99F-2DEB-405C-9E51-147581B13B91',			
			2,
			0,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CACPIID] = [inserted].[CACPIID]
	INNER JOIN CACPITYPEXREF ON CACPITYPEXREF.CACPIID = [deleted].CACPIID
	INNER JOIN CACPITYPE ON CACPITYPE.CACPITYPEID = CACPITYPEXREF.CACPITYPEID
	WHERE	[deleted].[ENDDATE] <> [inserted].[ENDDATE]
	UNION ALL

	SELECT
			[CACPITYPE].[CACPITYPEID],
			[CACPITYPE].[ROWVERSION],
			GETUTCDATE(),
			[CACPITYPE].[LASTCHANGEDBY],
			'Value',
			CONVERT(NVARCHAR(MAX), [deleted].[CPIVALUE]),
			CONVERT(NVARCHAR(MAX), [inserted].[CPIVALUE]),
			'CPI Type (' + [CACPITYPE].[NAME] + '), CPI Schedule (' + ISNULL([inserted].[NAME], '[none]') + ')',			
			'0958A99F-2DEB-405C-9E51-147581B13B91',			
			2,
			0,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CACPIID] = [inserted].[CACPIID]
	INNER JOIN CACPITYPEXREF ON CACPITYPEXREF.CACPIID = [deleted].CACPIID
	INNER JOIN CACPITYPE ON CACPITYPE.CACPITYPEID = CACPITYPEXREF.CACPITYPEID
	WHERE	[deleted].[CPIVALUE] <> [inserted].[CPIVALUE]

END