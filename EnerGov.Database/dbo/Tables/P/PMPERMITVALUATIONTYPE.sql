CREATE TABLE [dbo].[PMPERMITVALUATIONTYPE] (
    [PMPERMITVALUATIONTYPEID] CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_PMPermitValuationType_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_PMPermitValuationType_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitValuationType] PRIMARY KEY CLUSTERED ([PMPERMITVALUATIONTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PMPERMITVALUATIONTYPE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO

CREATE TRIGGER [dbo].[TG_PMPERMITVALUATIONTYPE_DELETE]
   ON  [dbo].[PMPERMITVALUATIONTYPE]
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
			[deleted].[PMPERMITVALUATIONTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Permit Valuation Type Deleted',
			'',
			'',
			'Permit Valuation Type (' + [deleted].[NAME] + ')',
			'CB9C06B5-52A4-4986-BD8B-2606AF32F484',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITVALUATIONTYPE_INSERT] ON [dbo].[PMPERMITVALUATIONTYPE]
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
        [inserted].[PMPERMITVALUATIONTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Permit Valuation Type Added',
        '',
        '',
        'Permit Valuation Type (' + [inserted].[NAME] + ')',
		'CB9C06B5-52A4-4986-BD8B-2606AF32F484',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITVALUATIONTYPE_UPDATE] 
   ON  [dbo].[PMPERMITVALUATIONTYPE]
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
			[inserted].[PMPERMITVALUATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Valuation Type (' + [inserted].[NAME] + ')',
			'CB9C06B5-52A4-4986-BD8B-2606AF32F484',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITVALUATIONTYPEID = [inserted].PMPERMITVALUATIONTYPEID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PMPERMITVALUATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Permit Valuation Type (' + [inserted].[NAME] + ')',
			'CB9C06B5-52A4-4986-BD8B-2606AF32F484',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITVALUATIONTYPEID = [inserted].PMPERMITVALUATIONTYPEID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END