﻿CREATE TABLE [dbo].[IMINSPECTORTYPEUSER] (
    [INSPECTORTYPEID]  CHAR (36) NOT NULL,
    [USERID]           CHAR (36) NOT NULL,
    [PRIMARYINSPECTOR] BIT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_IMInspectorTypeUser] PRIMARY KEY CLUSTERED ([INSPECTORTYPEID] ASC, [USERID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_InspectorTypeUser_tor] FOREIGN KEY ([INSPECTORTYPEID]) REFERENCES [dbo].[IMINSPECTORTYPE] ([IMINSPECTORTYPEID]),
    CONSTRAINT [FK_InspectorTypeUser_User] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTORTYPEUSER_IX_USERID]
    ON [dbo].[IMINSPECTORTYPEUSER]([USERID] ASC)
    INCLUDE([INSPECTORTYPEID], [PRIMARYINSPECTOR]);


GO

CREATE TRIGGER [TG_IMINSPECTORTYPEUSER_DELETE] ON [IMINSPECTORTYPEUSER]
	AFTER DELETE
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
			[USERS].[SUSERGUID],
			[USERS].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'User Inspector Type Deleted',
			'',
			'',
			'User (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME], '') + '), Inspector Type ('+ [IMINSPECTORTYPE].[SNAME] + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			3,
			0,
			[IMINSPECTORTYPE].[SNAME]
	FROM	[deleted]	
	INNER JOIN [USERS] ON [deleted].[USERID] = [USERS].[SUSERGUID]
	INNER JOIN [IMINSPECTORTYPE] WITH (NOLOCK) ON [deleted].[INSPECTORTYPEID] = [IMINSPECTORTYPE].[IMINSPECTORTYPEID]
END
GO

CREATE TRIGGER [TG_IMINSPECTORTYPEUSER_INSERT] ON [IMINSPECTORTYPEUSER]
	AFTER INSERT
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
			[USERS].[SUSERGUID],
			[USERS].[ROWVERSION],
			GETUTCDATE(),
			[USERS].[LASTCHANGEDBY],
			'User Inspector Type Added',
			'',
			'',
			'User (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME], '') + '), Inspector Type ('+ [IMINSPECTORTYPE].[SNAME] + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			1,
			0,
			[IMINSPECTORTYPE].[SNAME]
	FROM	[inserted]
	INNER JOIN [USERS] ON [inserted].[USERID] = [USERS].[SUSERGUID]
	INNER JOIN [IMINSPECTORTYPE] WITH (NOLOCK) ON [inserted].[INSPECTORTYPEID] = [IMINSPECTORTYPE].[IMINSPECTORTYPEID]
END
GO

CREATE TRIGGER [TG_IMINSPECTORTYPEUSER_UPDATE] ON [IMINSPECTORTYPEUSER]
	AFTER UPDATE
AS
BEGIN
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
			[USERS].[SUSERGUID],
			[USERS].[ROWVERSION],
			GETUTCDATE(),
			[USERS].[LASTCHANGEDBY],
			'Primary Flag',
			CASE [deleted].[PRIMARYINSPECTOR] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[PRIMARYINSPECTOR] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME], '') + '), Inspector Type ('+ [IMINSPECTORTYPE].[SNAME] + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			0,
			[IMINSPECTORTYPE].[SNAME]
	FROM	[deleted]	
			INNER JOIN [inserted] on [inserted].[USERID] = [deleted].[USERID] AND [inserted].[INSPECTORTYPEID] = [deleted].[INSPECTORTYPEID] 
            INNER JOIN [USERS] ON [deleted].[USERID] = [USERS].[SUSERGUID]
            INNER JOIN [IMINSPECTORTYPE] WITH (NOLOCK) ON [deleted].[INSPECTORTYPEID] = [IMINSPECTORTYPE].[IMINSPECTORTYPEID]
	WHERE	[deleted].[PRIMARYINSPECTOR] <> [inserted].[PRIMARYINSPECTOR]
	
END