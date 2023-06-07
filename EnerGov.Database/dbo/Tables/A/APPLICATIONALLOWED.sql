﻿CREATE TABLE [dbo].[APPLICATIONALLOWED] (
    [APPLICATIONALLOWEDID]  CHAR (36) CONSTRAINT [DF_ApplicationAllowed_ApplicationAllowedID] DEFAULT (newid()) NOT NULL,
    [USERID]                CHAR (36) NOT NULL,
    [APPLICATIONID]         INT       NOT NULL,
    [APPLICATIONUSERTYPEID] CHAR (36) NOT NULL,
    [APPROVED]              BIT       CONSTRAINT [DF_ApplicationAllowed_Approved] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ApplicationAllowed] PRIMARY KEY CLUSTERED ([APPLICATIONALLOWEDID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ApplicationAllowed] FOREIGN KEY ([APPLICATIONID]) REFERENCES [dbo].[APPLICATION] ([APPLICATIONID]),
    CONSTRAINT [FK_ApplicationAllowed_Users] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_ApplicationAllowedType] FOREIGN KEY ([APPLICATIONUSERTYPEID]) REFERENCES [dbo].[APPLICATIONUSERTYPE] ([APPLICATIONUSERTYPEID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ApplicationAllowed]
    ON [dbo].[APPLICATIONALLOWED]([APPLICATIONID] ASC, [USERID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_APPLICATIONALLOWED_USERID]
    ON [dbo].[APPLICATIONALLOWED]([APPLICATIONID] ASC, [APPROVED] ASC, [USERID] ASC);


GO

CREATE TRIGGER [dbo].[TG_APPLICATIONALLOWED_UPDATE] on [dbo].[APPLICATIONALLOWED]   
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
			[USERS].[SUSERGUID],
			[USERS].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Approved Flag',
			CASE WHEN [deleted].[APPROVED] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[APPROVED] = 1 THEN 'Yes' ELSE 'No' END,
			'External User (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME], '') + ')',
			'48C46A90-2E32-439E-A00F-0C09C723809A',			
			2,
			1,
			[USERS].[LNAME] + COALESCE (', ' + [USERS].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[APPLICATIONALLOWEDID] = [inserted].[APPLICATIONALLOWEDID]
			INNER JOIN [USERS] ON [USERS].[SUSERGUID] = [inserted].[USERID]
	WHERE	[deleted].[APPROVED] <> [inserted].[APPROVED]
END