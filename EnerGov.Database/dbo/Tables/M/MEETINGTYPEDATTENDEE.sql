﻿CREATE TABLE [dbo].[MEETINGTYPEDATTENDEE] (
    [MEETINGTYPEDATTENDEEID] CHAR (36) NOT NULL,
    [MEETINGTYPEID]          CHAR (36) NULL,
    [ATTENDEEID]             CHAR (36) NULL,
    [ISUSER]                 BIT       NULL,
    [ISCONTACT]              BIT       NULL,
    CONSTRAINT [PK_MEETINGTYPEDATTENDEE] PRIMARY KEY CLUSTERED ([MEETINGTYPEDATTENDEEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MEETINGTYPEDATTENDEE_TYP] FOREIGN KEY ([MEETINGTYPEID]) REFERENCES [dbo].[MEETINGTYPE] ([MEETINGTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [MEETINGTYPEDATTENDEE_IX_MEETINGTYPEID]
    ON [dbo].[MEETINGTYPEDATTENDEE]([MEETINGTYPEID] ASC);


GO

CREATE TRIGGER [TG_MEETINGTYPEDATTENDEE_DELETE] ON [MEETINGTYPEDATTENDEE]
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
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Meeting Type ' + CASE WHEN [deleted].[ISUSER] = 1 THEN 'User ' ELSE 'Contact ' END + 'Deleted',
			'',
			'',
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), '+ CASE WHEN [deleted].[ISUSER] = 1 THEN 'User (' + [dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], '') ELSE 'Contact (' + [dbo].[GLOBALENTITY].[LASTNAME]+ ', '+ [dbo].[GLOBALENTITY].[FIRSTNAME] END + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			3,
			0,
			CASE WHEN [deleted].[ISUSER] = 1 THEN [dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], '') ELSE [dbo].[GLOBALENTITY].[LASTNAME]+ ', '+ [dbo].[GLOBALENTITY].[FIRSTNAME] END
	FROM	[deleted]	
	INNER JOIN MEETINGTYPE ON [deleted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
	LEFT JOIN USERS  WITH (NOLOCK) ON [deleted].[ATTENDEEID] = [USERS].[SUSERGUID]
	LEFT JOIN GLOBALENTITY  WITH (NOLOCK) ON [deleted].[ATTENDEEID] = [GLOBALENTITY].[GLOBALENTITYID]
END
GO

CREATE TRIGGER [TG_MEETINGTYPEDATTENDEE_INSERT] ON [MEETINGTYPEDATTENDEE]
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
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[MEETINGTYPE].[LASTCHANGEDBY],
			'Meeting Type ' + CASE WHEN [inserted].[ISUSER] = 1 THEN 'User ' ELSE 'Contact ' END + 'Added',
			'',
			'',
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), '+ CASE WHEN [inserted].[ISUSER] = 1 THEN 'User (' + [dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], '') ELSE 'Contact (' + [dbo].[GLOBALENTITY].[LASTNAME]+ ', '+ [dbo].[GLOBALENTITY].[FIRSTNAME] END + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			1,
			0,
			CASE WHEN [inserted].[ISUSER] = 1 THEN [dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], '') ELSE [dbo].[GLOBALENTITY].[LASTNAME]+ ', '+ [dbo].[GLOBALENTITY].[FIRSTNAME] END
	FROM	[inserted]
	INNER JOIN MEETINGTYPE ON [inserted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
	LEFT JOIN USERS  WITH (NOLOCK) ON [inserted].[ATTENDEEID] = [USERS].[SUSERGUID]
	LEFT JOIN GLOBALENTITY  WITH (NOLOCK) ON [inserted].[ATTENDEEID] = [GLOBALENTITY].[GLOBALENTITYID]
END