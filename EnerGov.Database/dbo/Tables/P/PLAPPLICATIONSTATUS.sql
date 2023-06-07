CREATE TABLE [dbo].[PLAPPLICATIONSTATUS] (
    [PLAPPLICATIONSTATUSID] CHAR (36)      NOT NULL,
    [STATUS]                NVARCHAR (255) NOT NULL,
    [DESCRIPTION]           NVARCHAR (255) NOT NULL,
    [SUCCESSFLAG]           BIT            CONSTRAINT [DF_PLApplicationStatus_SuccessFlag] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]         CHAR (36)      NULL,
    [LASTCHANGEDON]         DATETIME       CONSTRAINT [DF_PLApplicationStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT            CONSTRAINT [DF_PLApplicationStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLApplicationStatus] PRIMARY KEY CLUSTERED ([PLAPPLICATIONSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLApplicationStatus_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO

CREATE TRIGGER [TG_PLAPPLICATIONSTATUS_DELETE] ON PLAPPLICATIONSTATUS
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
			[deleted].[PLAPPLICATIONSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Application Status Deleted',
			'',
			'',
			'Application Status (' + [deleted].[STATUS] + ')',
			'A4BB1C4C-E10E-4BA0-A5AF-2E4B6C92A185',
			3,
			1,
			[deleted].[STATUS]
	FROM	[deleted]
END
GO
CREATE TRIGGER [TG_PLAPPLICATIONSTATUS_INSERT] ON PLAPPLICATIONSTATUS
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
        [inserted].[PLAPPLICATIONSTATUSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Application Status Added',
        '',
        '',
        'Application Status (' + [inserted].[STATUS] + ')',
		'A4BB1C4C-E10E-4BA0-A5AF-2E4B6C92A185',
        1,
		1,
		[inserted].[STATUS]
    FROM [inserted] 
END
GO

CREATE TRIGGER [TG_PLAPPLICATIONSTATUS_UPDATE] ON PLAPPLICATIONSTATUS
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
			[inserted].[PLAPPLICATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[STATUS],
			[inserted].[STATUS],
			'Application Status (' + [inserted].[STATUS] + ')',
			'A4BB1C4C-E10E-4BA0-A5AF-2E4B6C92A185',
			2,
			1,
			[inserted].[STATUS]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONSTATUSID] = [inserted].[PLAPPLICATIONSTATUSID]
	WHERE	[deleted].[STATUS] <> [inserted].[STATUS]
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Application Status (' + [inserted].[STATUS] + ')',
			'A4BB1C4C-E10E-4BA0-A5AF-2E4B6C92A185',
			2,
			1,
			[inserted].[STATUS]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONSTATUSID] = [inserted].[PLAPPLICATIONSTATUSID]
	WHERE	[deleted].[DESCRIPTION] <> [inserted].[DESCRIPTION]
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Complete Flag',
			CASE WHEN [deleted].[SUCCESSFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[SUCCESSFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Application Status (' + [inserted].[STATUS] + ')',
			'A4BB1C4C-E10E-4BA0-A5AF-2E4B6C92A185',
			2,
			1,
			[inserted].[STATUS]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONSTATUSID] = [inserted].[PLAPPLICATIONSTATUSID]
	WHERE	[deleted].[SUCCESSFLAG] <> [inserted].[SUCCESSFLAG]
END