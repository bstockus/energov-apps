﻿CREATE TABLE [dbo].[MAILMERGETEMPLATEUSER] (
    [MAILMERGETEMPLATEUSERID]     CHAR (36) NOT NULL,
    [MAILMERGETEMPLATEID]         CHAR (36) NOT NULL,
    [USERID]                      CHAR (36) NOT NULL,
    [MAILMERGETEMPLATEUSERTYPEID] INT       NOT NULL,
    CONSTRAINT [PK_MailMergeTemplateUsers] PRIMARY KEY CLUSTERED ([MAILMERGETEMPLATEUSERID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MailMergeTemplateUsers_Mail] FOREIGN KEY ([MAILMERGETEMPLATEID]) REFERENCES [dbo].[MAILMERGETEMPLATE] ([MAILMERGETEMPLATEID]),
    CONSTRAINT [FK_MailMergeTemplateUsers_User] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_MMTemplateUsers_UserType] FOREIGN KEY ([MAILMERGETEMPLATEUSERTYPEID]) REFERENCES [dbo].[MAILMERGETEMPLATEUSERTYPE] ([MAILMERGETEMPLATEUSERTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [MailMergeTemplateUser_MailMerg]
    ON [dbo].[MAILMERGETEMPLATEUSER]([MAILMERGETEMPLATEID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [MAILMERGETEMPLATEUSER_IX_MAILMERGETEMPLATEUSERTYPEID]
    ON [dbo].[MAILMERGETEMPLATEUSER]([MAILMERGETEMPLATEUSERTYPEID] ASC);


GO
CREATE NONCLUSTERED INDEX [MAILMERGETEMPLATEUSER_IX_USERID]
    ON [dbo].[MAILMERGETEMPLATEUSER]([USERID] ASC);


GO

CREATE TRIGGER [dbo].[TG_MAILMERGETEMPLATEUSER_DELETE]
   ON  [dbo].[MAILMERGETEMPLATEUSER]
   AFTER DELETE
AS 
BEGIN	
	SET NOCOUNT ON;
	DECLARE @CaseType VARCHAR(50) = (SELECT dbo.UFN_GET_CASE_FROM_CONTEXT_INFO())	
	 --Check if SETTINGS Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'SETTINGS'
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
				[deleted].[MAILMERGETEMPLATEID], 
				[SETTINGS].[ROWVERSION],
				GETUTCDATE(),
				[SETTINGS].[LASTCHANGEDBY],
				'Mail Merge Template ' + CASE WHEN [MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME] = 'Cc' OR [MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME] = 'Bcc' THEN UPPER([MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME]) ELSE [MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME] END + ' User Deleted',
				'',
				'',
				'System Settings (eReview Email), Mail Merge Template User (' + [USERS].[EMAIL] + ')',
				'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
				3,
				0,
				[USERS].[EMAIL]
		FROM	[deleted]
				INNER JOIN [MAILMERGETEMPLATE] WITH (NOLOCK) ON [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] = [deleted].[MAILMERGETEMPLATEID]
				LEFT JOIN [SETTINGS] WITH (NOLOCK) ON [SETTINGS].[STRINGVALUE] = [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID]
				INNER JOIN [MAILMERGETEMPLATEUSERTYPE] WITH (NOLOCK) ON [MAILMERGETEMPLATEUSERTYPE].[MAILMERGETEMPLATEUSERTYPEID] = [deleted].MAILMERGETEMPLATEUSERTYPEID
				INNER JOIN [USERS] WITH (NOLOCK) ON [USERS].[SUSERGUID] = [deleted].[USERID]

	END
	ELSE
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
			[WORKFLOW].[WORKFLOWID], 
			[WORKFLOW].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Mail Merge Template User Deleted',
			'',
			'',
			'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + '), User (' + COALESCE([MAILMERGETEMPLATEUSERTYPE].USERTYPENAME, '') +' ' + [USERS].[LNAME] + COALESCE(',' + [USERS].[FNAME],'') + COALESCE(' ' + [USERS].[EMAIL],'') + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			3,
			0,
			[WORKFLOWACTION].[ACTIONNAME]
	FROM	[deleted]
			INNER JOIN [MAILMERGETEMPLATE] ON [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] = [deleted].[MAILMERGETEMPLATEID]
			INNER JOIN [WORKFLOWACTIONMAILMERGETMPL] ON [WORKFLOWACTIONMAILMERGETMPL].[MAILMERGETEMPLATEID] = [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID]
			INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [WORKFLOWACTIONMAILMERGETMPL].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
			INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
			INNER JOIN [MAILMERGETEMPLATEUSERTYPE] WITH (NOLOCK) ON [MAILMERGETEMPLATEUSERTYPE].[MAILMERGETEMPLATEUSERTYPEID] = [deleted].MAILMERGETEMPLATEUSERTYPEID
			INNER JOIN [USERS] WITH (NOLOCK) ON [USERS].[SUSERGUID] = [deleted].[USERID]

	UNION ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Mail Merge Template User Deleted',
			'',
			'',
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + '), User (' + COALESCE([MAILMERGETEMPLATEUSERTYPE].USERTYPENAME, '') +' ' + [USERS].[LNAME] + COALESCE(',' + [USERS].[FNAME],'') + COALESCE(' ' + [USERS].[EMAIL],'') + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			3,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			INNER JOIN [MAILMERGETEMPLATE] ON [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] = [deleted].[MAILMERGETEMPLATEID]
			INNER JOIN [QUERYACTIONMAILMERGETMPL] ON [QUERYACTIONMAILMERGETMPL].[MAILMERGETEMPLATEID] = [deleted].[MAILMERGETEMPLATEID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [QUERYACTIONMAILMERGETMPL].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
			INNER JOIN [MAILMERGETEMPLATEUSERTYPE] WITH (NOLOCK) ON [MAILMERGETEMPLATEUSERTYPE].[MAILMERGETEMPLATEUSERTYPEID] = [deleted].MAILMERGETEMPLATEUSERTYPEID
			INNER JOIN [USERS] WITH (NOLOCK) ON [USERS].[SUSERGUID] = [deleted].[USERID]
	END
END
GO

CREATE TRIGGER [dbo].[TG_MAILMERGETEMPLATEUSER_INSERT]
   ON  [dbo].[MAILMERGETEMPLATEUSER]
   AFTER INSERT
AS 
BEGIN	
	SET NOCOUNT ON;
	DECLARE @CaseType VARCHAR(50) = (SELECT dbo.UFN_GET_CASE_FROM_CONTEXT_INFO())	
	 --Check if SETTINGS Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'SETTINGS'
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
				[inserted].[MAILMERGETEMPLATEID], 
				[SETTINGS].[ROWVERSION],
				GETUTCDATE(),
				[SETTINGS].[LASTCHANGEDBY],
				'Mail Merge Template ' + CASE WHEN [MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME] = 'Cc' OR [MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME] = 'Bcc' THEN UPPER([MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME]) ELSE [MAILMERGETEMPLATEUSERTYPE].[USERTYPENAME] END + ' User Added',
				'',
				'',
				'System Settings (eReview Email), Mail Merge Template User (' + [USERS].[EMAIL] + ')',
				'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
				1,
				0,
				[USERS].[EMAIL]
		FROM	[inserted]
				INNER JOIN [MAILMERGETEMPLATE] WITH (NOLOCK) ON [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] = [inserted].[MAILMERGETEMPLATEID]
				LEFT JOIN [SETTINGS] WITH (NOLOCK) ON [SETTINGS].[STRINGVALUE] = [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID]
				INNER JOIN [MAILMERGETEMPLATEUSERTYPE] WITH (NOLOCK) ON [MAILMERGETEMPLATEUSERTYPE].[MAILMERGETEMPLATEUSERTYPEID] = [inserted].MAILMERGETEMPLATEUSERTYPEID
				INNER JOIN [USERS] WITH (NOLOCK) ON [USERS].[SUSERGUID] = [inserted].[USERID]
	END
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
				[WORKFLOW].[WORKFLOWID], 
				[WORKFLOW].[ROWVERSION],
				GETUTCDATE(),
				[WORKFLOW].[LASTCHANGEDBY],
				'Mail Merge Template User Added',
				'',
				'',
				'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + '), User (' + COALESCE([MAILMERGETEMPLATEUSERTYPE].USERTYPENAME, '') +' ' + [USERS].[LNAME] + COALESCE(',' + [USERS].[FNAME],'') + COALESCE(' ' +[USERS].[EMAIL],'') + ')',
				'F053A756-19BE-4A42-A70D-185D5B01C31A',
				1,
				0,
				[WORKFLOWACTION].[ACTIONNAME]
		FROM	[inserted] 
				INNER JOIN [MAILMERGETEMPLATE] ON [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] = [inserted].[MAILMERGETEMPLATEID]
				INNER JOIN [WORKFLOWACTIONMAILMERGETMPL] ON [WORKFLOWACTIONMAILMERGETMPL].[MAILMERGETEMPLATEID] = [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID]
				INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [WORKFLOWACTIONMAILMERGETMPL].[WORKFLOWACTIONID]
				INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
				INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
				INNER JOIN [MAILMERGETEMPLATEUSERTYPE] WITH (NOLOCK) ON [MAILMERGETEMPLATEUSERTYPE].[MAILMERGETEMPLATEUSERTYPEID] = [inserted].MAILMERGETEMPLATEUSERTYPEID
				INNER JOIN [USERS] WITH (NOLOCK) ON [USERS].[SUSERGUID] = [inserted].[USERID]

		UNION ALL
		SELECT
				[QUERY].[QUERYID], 
				[QUERY].[ROWVERSION],
				GETUTCDATE(),
				[QUERY].[LASTCHANGEDBY],
				'Mail Merge Template User Added',
				'',
				'',
				'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + '), User (' + COALESCE([MAILMERGETEMPLATEUSERTYPE].USERTYPENAME, '') +' ' + [USERS].[LNAME] + COALESCE(',' + [USERS].[FNAME],'') + COALESCE(' ' + [USERS].[EMAIL],'') + ')',
				'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
				1,
				0,
				[QUERYACTION].[ACTIONNAME]
		FROM	[inserted]
				INNER JOIN [MAILMERGETEMPLATE] ON [MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] = [inserted].[MAILMERGETEMPLATEID]
				INNER JOIN [QUERYACTIONMAILMERGETMPL] ON [QUERYACTIONMAILMERGETMPL].[MAILMERGETEMPLATEID] = [inserted].[MAILMERGETEMPLATEID]
				INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [QUERYACTIONMAILMERGETMPL].[QUERYACTIONID]
				INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
				INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
				INNER JOIN [MAILMERGETEMPLATEUSERTYPE] WITH (NOLOCK) ON [MAILMERGETEMPLATEUSERTYPE].[MAILMERGETEMPLATEUSERTYPEID] = [inserted].MAILMERGETEMPLATEUSERTYPEID
				INNER JOIN [USERS] WITH (NOLOCK) ON [USERS].[SUSERGUID] = [inserted].[USERID]
	END
END