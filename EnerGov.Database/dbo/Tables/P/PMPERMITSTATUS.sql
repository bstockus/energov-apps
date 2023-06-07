CREATE TABLE [dbo].[PMPERMITSTATUS] (
    [PMPERMITSTATUSID]    CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [HOLDFLAG]            BIT            CONSTRAINT [DF_PMPermitStatus_HoldFlag] DEFAULT ((0)) NULL,
    [COMPLETEDFLAG]       BIT            CONSTRAINT [DF_PMPermitStatus_CompletedFlag] DEFAULT ((0)) NOT NULL,
    [ISSUEDFLAG]          BIT            CONSTRAINT [DF_PMPermitStatus_IssuedFlag] DEFAULT ((0)) NOT NULL,
    [FAILUREFLAG]         BIT            DEFAULT ((0)) NOT NULL,
    [CANCELLEDFLAG]       BIT            CONSTRAINT [DF_PMPermitStatus_CancelledFlag] DEFAULT ((0)) NOT NULL,
    [DESCRIPTION_SPANISH] NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_PMPermitStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_PMPermitStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitStatus] PRIMARY KEY CLUSTERED ([PMPERMITSTATUSID] ASC),
    CONSTRAINT [FK_PMPERMITSTATUS_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PMPERMITSTATUS_IX_QUERY]
    ON [dbo].[PMPERMITSTATUS]([PMPERMITSTATUSID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [TG_PMPERMITSTATUS_DELETE] ON PMPERMITSTATUS
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
			[deleted].[PMPERMITSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Permit Status Deleted',
			'',
			'',
			'Permit Status (' + [deleted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_PMPERMITSTATUS_UPDATE] ON PMPERMITSTATUS
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
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Hold Flag',
			CASE [deleted].[HOLDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[HOLDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	([deleted].[HOLDFLAG] <> [inserted].[HOLDFLAG]) OR ([deleted].[HOLDFLAG] IS NULL AND [inserted].[HOLDFLAG] IS NOT NULL)
			OR ([deleted].[HOLDFLAG] IS NOT NULL AND [inserted].[HOLDFLAG] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Completed Flag',
			CASE WHEN [deleted].[COMPLETEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[COMPLETEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	[deleted].[COMPLETEDFLAG] <> [inserted].[COMPLETEDFLAG]
	UNION ALL
	SELECT
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Issued Flag',
			CASE WHEN [deleted].[ISSUEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISSUEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	[deleted].[ISSUEDFLAG] <> [inserted].[ISSUEDFLAG]
	UNION ALL
	SELECT
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Failure Flag',
			CASE WHEN [deleted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	[deleted].[FAILUREFLAG] <> [inserted].[FAILUREFLAG]
	UNION ALL
	SELECT
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cancelled Flag',
			CASE WHEN [deleted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	[deleted].[CANCELLEDFLAG] <> [inserted].[CANCELLEDFLAG]
	UNION ALL
	SELECT
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Spanish Description',
			ISNULL([deleted].[DESCRIPTION_SPANISH],'[none]'),
			ISNULL([inserted].[DESCRIPTION_SPANISH],'[none]'),
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITSTATUSID = [inserted].PMPERMITSTATUSID
	WHERE	ISNULL([deleted].[DESCRIPTION_SPANISH], '') <> ISNULL([inserted].[DESCRIPTION_SPANISH], '')
END
GO

CREATE TRIGGER [TG_PMPERMITSTATUS_INSERT] ON PMPERMITSTATUS
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
			[inserted].[PMPERMITSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Permit Status Added',
			'',
			'',
			'Permit Status (' + [inserted].[NAME] + ')',
			'FB2F8995-A2AB-414E-B310-B829A652811D',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END