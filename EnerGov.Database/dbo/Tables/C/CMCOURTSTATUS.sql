CREATE TABLE [dbo].[CMCOURTSTATUS] (
    [CMCOURTSTATUSID] CHAR (36)      NOT NULL,
    [NAME]            NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]     NVARCHAR (MAX) NULL,
    [ISCLOSED]        BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]   CHAR (36)      NOT NULL,
    [LASTCHANGEDON]   DATETIME       CONSTRAINT [DF_CMCourtStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]      INT            CONSTRAINT [DF_CMCourtStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CMCOURTSTATUS] PRIMARY KEY CLUSTERED ([CMCOURTSTATUSID] ASC),
    CONSTRAINT [FK_CMCOURTSTATUS_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [UC_CMCOURTSTATUS_NAME] UNIQUE NONCLUSTERED ([NAME] ASC)
);


GO
CREATE NONCLUSTERED INDEX [CMCOURTSTATUS_IX_QUERY]
    ON [dbo].[CMCOURTSTATUS]([CMCOURTSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_CMCOURTSTATUS_INSERT] ON CMCOURTSTATUS
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
			[inserted].[CMCOURTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Court Status Added',
			'',
			[inserted].[NAME],
			'Court Status (' + [inserted].[NAME] + ')',
			'3d57877c-cf9e-4f77-ab4d-b2ea9fd7e52f',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_CMCOURTSTATUS_UPDATE] ON CMCOURTSTATUS
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
			[inserted].[CMCOURTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Court Status name updated (' + [inserted].[NAME] + ')',
			'3d57877c-cf9e-4f77-ab4d-b2ea9fd7e52f',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCOURTSTATUSID = [inserted].CMCOURTSTATUSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[CMCOURTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Court Status description updated (' + [inserted].[NAME] + ')',
			'3d57877c-cf9e-4f77-ab4d-b2ea9fd7e52f',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCOURTSTATUSID = [inserted].CMCOURTSTATUSID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[CMCOURTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Closed',
			CASE [deleted].[ISCLOSED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[ISCLOSED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Court Status closed updated (' + [inserted].[NAME] + ')',
			'3d57877c-cf9e-4f77-ab4d-b2ea9fd7e52f',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCOURTSTATUSID = [inserted].CMCOURTSTATUSID
	WHERE	([deleted].[ISCLOSED] <> [inserted].[ISCLOSED]) OR ([deleted].[ISCLOSED] IS NULL AND [inserted].[ISCLOSED] IS NOT NULL)
			OR ([deleted].[ISCLOSED] IS NOT NULL AND [inserted].[ISCLOSED] IS NULL)
END
GO


CREATE TRIGGER [TG_CMCOURTSTATUS_DELETE] ON CMCOURTSTATUS
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
			[deleted].[CMCOURTSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Court Status Deleted',
			'',
			'',
			'Court Status deleted (' + [deleted].[NAME] + ')',
			'3d57877c-cf9e-4f77-ab4d-b2ea9fd7e52f',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END