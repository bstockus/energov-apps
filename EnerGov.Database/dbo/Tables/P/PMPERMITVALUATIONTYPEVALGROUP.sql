﻿CREATE TABLE [dbo].[PMPERMITVALUATIONTYPEVALGROUP] (
    [PMPERMITVALTYPEVALGRPID] CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (255) NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [EFFECTIVEDATE]           DATETIME       NOT NULL,
    [EXPIRATIONDATE]          DATETIME       NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_PMPERMITVALUATIONTYPEVALGROUP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_PMPERMITVALUATIONTYPEVALGROUP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitValuationTypeValGroup] PRIMARY KEY CLUSTERED ([PMPERMITVALTYPEVALGRPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PMPERMITVALUATIONTYPEVALGROUP_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE TRIGGER [TG_PMPERMITVALUATIONTYPEVALGROUP_DELETE] ON PMPERMITVALUATIONTYPEVALGROUP
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
			[deleted].[PMPERMITVALTYPEVALGRPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Valuation Calculator Deleted',
			'',
			'',
			'Valuation Calculator (' + [deleted].[NAME] + ')',
			'9A2DA686-151E-43F3-9366-5E73A0666F95',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [TG_PMPERMITVALUATIONTYPEVALGROUP_INSERT] ON PMPERMITVALUATIONTYPEVALGROUP
   FOR INSERT
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
			[inserted].[PMPERMITVALTYPEVALGRPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Valuation Calculator Added',
			'',
			'',
			'Valuation Calculator (' + [inserted].[NAME] + ')',
			'9A2DA686-151E-43F3-9366-5E73A0666F95',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_PMPERMITVALUATIONTYPEVALGROUP_UPDATE] ON PMPERMITVALUATIONTYPEVALGROUP
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
			[inserted].[PMPERMITVALTYPEVALGRPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Valuation Calculator (' + [inserted].[NAME] + ')',
			'9A2DA686-151E-43F3-9366-5E73A0666F95',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITVALTYPEVALGRPID = [inserted].PMPERMITVALTYPEVALGRPID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[PMPERMITVALTYPEVALGRPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Valuation Calculator (' + [inserted].[NAME] + ')',
			'9A2DA686-151E-43F3-9366-5E73A0666F95',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITVALTYPEVALGRPID] = [inserted].[PMPERMITVALTYPEVALGRPID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[PMPERMITVALTYPEVALGRPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Effective Date',
			CONVERT(NVARCHAR(MAX), [deleted].[EFFECTIVEDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[EFFECTIVEDATE], 101),
			'Valuation Calculator (' + [inserted].[NAME] + ')',
			'9A2DA686-151E-43F3-9366-5E73A0666F95',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITVALTYPEVALGRPID] = [inserted].[PMPERMITVALTYPEVALGRPID]
	WHERE	[deleted].[EFFECTIVEDATE] <> [inserted].[EFFECTIVEDATE]
	UNION ALL
	SELECT
			[inserted].[PMPERMITVALTYPEVALGRPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Expiration Date',
			 (CASE WHEN [deleted].[EXPIRATIONDATE] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[EXPIRATIONDATE], 101) END  ),
			(CASE WHEN [deleted].[EXPIRATIONDATE] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[EXPIRATIONDATE], 101) END  ),
			'Valuation Calculator (' + [inserted].[NAME] + ')',
			'9A2DA686-151E-43F3-9366-5E73A0666F95',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITVALTYPEVALGRPID] = [inserted].[PMPERMITVALTYPEVALGRPID]
	WHERE	ISNULL([deleted].[EXPIRATIONDATE], '') <> ISNULL([inserted].[EXPIRATIONDATE], '')
END