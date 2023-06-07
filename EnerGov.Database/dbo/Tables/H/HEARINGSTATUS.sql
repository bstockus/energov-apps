CREATE TABLE [dbo].[HEARINGSTATUS] (
    [HEARINGSTATUSID] CHAR (36)      NOT NULL,
    [NAME]            NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]     NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]   CHAR (36)      NULL,
    [LASTCHANGEDON]   DATETIME       CONSTRAINT [DF_HearingStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]      INT            CONSTRAINT [DF_HearingStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLPlanCaseHearingStatus] PRIMARY KEY CLUSTERED ([HEARINGSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HearingStatus_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [HEARINGSTATUS_IX_QUERY]
    ON [dbo].[HEARINGSTATUS]([HEARINGSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_HEARINGSTATUS_UPDATE] 
   ON  [dbo].[HEARINGSTATUS]
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
			[inserted].[HEARINGSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Hearing Status (' + [inserted].[NAME] + ')',
			'B1C7BD85-889A-412B-878B-E0589BA35E56',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].HEARINGSTATUSID = [inserted].HEARINGSTATUSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[HEARINGSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Hearing Status (' + [inserted].[NAME] + ')',
			'B1C7BD85-889A-412B-878B-E0589BA35E56',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].HEARINGSTATUSID = [inserted].HEARINGSTATUSID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO

CREATE TRIGGER [dbo].[TG_HEARINGSTATUS_INSERT] ON [dbo].[HEARINGSTATUS]
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
        [inserted].[HEARINGSTATUSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Hearing Status Added',
        '',
        '',
        'Hearing Status (' + [inserted].[NAME] + ')',
		'B1C7BD85-889A-412B-878B-E0589BA35E56',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_HEARINGSTATUS_DELETE]
   ON  [dbo].[HEARINGSTATUS]
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
			[deleted].[HEARINGSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Hearing Status Deleted',
			'',
			'',
			'Hearing Status (' + [deleted].[NAME] + ')',
			'B1C7BD85-889A-412B-878B-E0589BA35E56',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END