CREATE TABLE [dbo].[PLPLANSTATUS] (
    [PLPLANSTATUSID]      CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [SUCCESSFLAG]         BIT            NULL,
    [HOLDFLAG]            BIT            CONSTRAINT [DF_PLPlanStatus_HoldFlag] DEFAULT ((0)) NULL,
    [FAILUREFLAG]         BIT            DEFAULT ((0)) NOT NULL,
    [CANCELLEDFLAG]       BIT            CONSTRAINT [DF_PLPlanStatus_CancelledFlag] DEFAULT ((0)) NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [DESCRIPTION_SPANISH] NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_PLPlanStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_PLPlanStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLPlanStatus] PRIMARY KEY CLUSTERED ([PLPLANSTATUSID] ASC),
    CONSTRAINT [FK_PLPlanStatus_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PLPLANSTATUS_IX_QUERY]
    ON [dbo].[PLPLANSTATUS]([PLPLANSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_PLPLANSTATUS_UPDATE] ON PLPLANSTATUS
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
			[inserted].[PLPLANSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANSTATUSID] = [inserted].[PLPLANSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PLPLANSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANSTATUSID] = [inserted].[PLPLANSTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Hold Flag',
			CASE [deleted].[HOLDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[HOLDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANSTATUSID] = [inserted].[PLPLANSTATUSID]
	WHERE	([deleted].[HOLDFLAG] <> [inserted].[HOLDFLAG]) OR ([deleted].[HOLDFLAG] IS NULL AND [inserted].[HOLDFLAG] IS NOT NULL)
			OR ([deleted].[HOLDFLAG] IS NOT NULL AND [inserted].[HOLDFLAG] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Success Flag',
			CASE WHEN [deleted].[SUCCESSFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[SUCCESSFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANSTATUSID] = [inserted].[PLPLANSTATUSID]
	WHERE	[deleted].[SUCCESSFLAG] <> [inserted].[SUCCESSFLAG]
	UNION ALL	
	SELECT
			[inserted].[PLPLANSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Failure Flag',
			CASE WHEN [deleted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANSTATUSID] = [inserted].[PLPLANSTATUSID]
	WHERE	[deleted].[FAILUREFLAG] <> [inserted].[FAILUREFLAG]
	UNION ALL
	SELECT
			[inserted].[PLPLANSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cancelled Flag',
			CASE WHEN [deleted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANSTATUSID] = [inserted].[PLPLANSTATUSID]
	WHERE	[deleted].[CANCELLEDFLAG] <> [inserted].[CANCELLEDFLAG]
	UNION ALL
	SELECT
			[inserted].[PLPLANSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Spanish Description',
			ISNULL([deleted].[DESCRIPTION_SPANISH],'[none]'),
			ISNULL([inserted].[DESCRIPTION_SPANISH],'[none]'),
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANSTATUSID] = [inserted].[PLPLANSTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION_SPANISH], '') <> ISNULL([inserted].[DESCRIPTION_SPANISH], '')
END
GO

CREATE TRIGGER [TG_PLPLANSTATUS_INSERT] ON PLPLANSTATUS
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
			[inserted].PLPLANSTATUSID,
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Plan Status Added',
			'',
			'',
			'Plan Status (' + [inserted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO


CREATE TRIGGER [TG_PLPLANSTATUS_DELETE] ON PLPLANSTATUS
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
			[deleted].[PLPLANSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Plan Status Deleted',
			'',
			'',
			'Plan Status (' + [deleted].[NAME] + ')',
			'56E06167-682C-4E47-9307-70C7A07A27E8',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END