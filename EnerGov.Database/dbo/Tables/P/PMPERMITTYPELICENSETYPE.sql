﻿CREATE TABLE [dbo].[PMPERMITTYPELICENSETYPE] (
    [PMPERMITTYPELICENSETYPEID] CHAR (36) NOT NULL,
    [PMPERMITTYPEID]            CHAR (36) NOT NULL,
    [PMPERMITWORKCLASSID]       CHAR (36) NOT NULL,
    [COSIMPLELICCERTTYPEID]     CHAR (36) NOT NULL,
    [REQUIREALLCERTCLASS]       BIT       CONSTRAINT [DF_PMPERMITTYPELICENSETYPE_REQUIREALLCERTCLASS] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PMPermitTypeLicenseType] PRIMARY KEY CLUSTERED ([PMPERMITTYPELICENSETYPEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PMTypeLicType_COLicType] FOREIGN KEY ([COSIMPLELICCERTTYPEID]) REFERENCES [dbo].[COLICENSECERTIFICATIONTYPE] ([COSIMPLELICCERTTYPEID]),
    CONSTRAINT [FK_PMTypeLicType_PMType] FOREIGN KEY ([PMPERMITTYPEID]) REFERENCES [dbo].[PMPERMITTYPE] ([PMPERMITTYPEID]),
    CONSTRAINT [FK_PMTypeLicType_PMWC] FOREIGN KEY ([PMPERMITWORKCLASSID]) REFERENCES [dbo].[PMPERMITWORKCLASS] ([PMPERMITWORKCLASSID])
);


GO
CREATE TRIGGER [dbo].[TG_PMPERMITTYPELICENSETYPE_INSERT]
   ON  [dbo].[PMPERMITTYPELICENSETYPE]
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
        [PMPERMITTYPE].[PMPERMITTYPEID], 
        [PMPERMITTYPE].[ROWVERSION],
        GETUTCDATE(),
        [PMPERMITTYPE].[LASTCHANGEDBY],	
        'Permit Type Certification Type Added',
        '',
        '',       
		'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + ISNULL([PMPERMITWORKCLASS].[NAME],'[none]') +'), Certification (' + [COLICENSECERTIFICATIONTYPE].[NAME] +')',
		'4976A4A9-20E8-4B8F-997D-CE244B540104',
		1,
		0,
		[COLICENSECERTIFICATIONTYPE].[NAME]
    FROM [inserted]
	INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	INNER JOIN [COLICENSECERTIFICATIONTYPE] WITH (NOLOCK) ON [COLICENSECERTIFICATIONTYPE].[COSIMPLELICCERTTYPEID] = [inserted].[COSIMPLELICCERTTYPEID]
	LEFT JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITTYPELICENSETYPE_UPDATE] ON [dbo].[PMPERMITTYPELICENSETYPE] 
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
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Require All',
			CASE [deleted].[REQUIREALLCERTCLASS]	 WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[REQUIREALLCERTCLASS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME]+'), Certification Type (' + [COLICENSECERTIFICATIONTYPE].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[COLICENSECERTIFICATIONTYPE].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPELICENSETYPEID] = [inserted].[PMPERMITTYPELICENSETYPEID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]	
			INNER JOIN [COLICENSECERTIFICATIONTYPE] WITH (NOLOCK) ON [COLICENSECERTIFICATIONTYPE].[COSIMPLELICCERTTYPEID] = [deleted].[COSIMPLELICCERTTYPEID]	
			LEFT JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
	WHERE	[deleted].[REQUIREALLCERTCLASS] <> [inserted].[REQUIREALLCERTCLASS]	
END
GO
CREATE TRIGGER [dbo].[TG_PMPERMITTYPELICENSETYPE_DELETE]  
    ON  [dbo].[PMPERMITTYPELICENSETYPE]
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
		[PMPERMITTYPE].[PMPERMITTYPEID],
		[PMPERMITTYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Permit Type Certification Type Deleted',
        '',
        '',       
		'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME]+'), Certification (' + [COLICENSECERTIFICATIONTYPE].[NAME] +')',
		'4976A4A9-20E8-4B8F-997D-CE244B540104',
		3,
		0,
		[COLICENSECERTIFICATIONTYPE].[NAME]
    FROM [deleted]
	INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [deleted].[PMPERMITTYPEID]
	INNER JOIN [COLICENSECERTIFICATIONTYPE] WITH (NOLOCK) ON [COLICENSECERTIFICATIONTYPE].[COSIMPLELICCERTTYPEID] = [deleted].[COSIMPLELICCERTTYPEID]
	LEFT JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [deleted].[PMPERMITWORKCLASSID]
END