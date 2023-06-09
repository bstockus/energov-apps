﻿CREATE TABLE [dbo].[PMPERMITVALUATIONGROUP] (
    [PMPERMITVALUATIONGROUPID] CHAR (36)      NOT NULL,
    [NAME]                     NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]              NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]            CHAR (36)      NULL,
    [LASTCHANGEDON]            DATETIME       CONSTRAINT [DF_PMPERMITVALUATIONGROUP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT            CONSTRAINT [DF_PMPERMITVALUATIONGROUP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitValuationGroup] PRIMARY KEY CLUSTERED ([PMPERMITVALUATIONGROUPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PMPERMITVALUATIONGROUP_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE TRIGGER [dbo].[TG_PMPERMITVALUATIONGROUP_DELETE]   ON [dbo].[PMPERMITVALUATIONGROUP]
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
			[deleted].[PMPERMITVALUATIONGROUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Permit Valuation Group Deleted',
			'',
			'',
			'Permit Valuation Group (' + [deleted].[NAME] + ')',
			'D4B518E6-4B7F-46E1-AA2E-4F81586296EB',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_PMPERMITVALUATIONGROUP_UPDATE] ON [dbo].[PMPERMITVALUATIONGROUP]
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
			[inserted].[PMPERMITVALUATIONGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Valuation Group (' + [inserted].[NAME] + ')',
			'D4B518E6-4B7F-46E1-AA2E-4F81586296EB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITVALUATIONGROUPID = [inserted].PMPERMITVALUATIONGROUPID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[PMPERMITVALUATIONGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Permit Valuation Group (' + [inserted].[NAME] + ')',
			'D4B518E6-4B7F-46E1-AA2E-4F81586296EB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITVALUATIONGROUPID = [inserted].PMPERMITVALUATIONGROUPID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
END
GO
CREATE TRIGGER [dbo].[TG_PMPERMITVALUATIONGROUP_INSERT] ON  [dbo].[PMPERMITVALUATIONGROUP]
   AFTER INSERT
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
			[inserted].[PMPERMITVALUATIONGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Permit Valuation Group Added',
			'',
			'',
			'Permit Valuation Group (' + [inserted].[NAME] + ')',
			'D4B518E6-4B7F-46E1-AA2E-4F81586296EB',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END