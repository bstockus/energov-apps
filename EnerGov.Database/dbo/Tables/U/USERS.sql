CREATE TABLE [dbo].[USERS] (
    [SUSERGUID]                 CHAR (36)      CONSTRAINT [DF_Users_guID] DEFAULT (newid()) NOT NULL,
    [SROLEID]                   CHAR (36)      NULL,
    [SITEID]                    NVARCHAR (10)  NULL,
    [ID]                        NVARCHAR (254) CONSTRAINT [DF_Users_ID] DEFAULT (newid()) NOT NULL,
    [FNAME]                     NVARCHAR (30)  NULL,
    [LNAME]                     NVARCHAR (30)  NOT NULL,
    [PASSWORD]                  NVARCHAR (100) NOT NULL,
    [PHONE]                     NVARCHAR (40)  NULL,
    [EMAIL]                     NVARCHAR (80)  NULL,
    [BACTIVE]                   BIT            CONSTRAINT [DF_Users_bActive] DEFAULT ((1)) NOT NULL,
    [BGETINTERNETNOTES]         BIT            CONSTRAINT [DF_Users_bGetInternetNot] DEFAULT ((0)) NOT NULL,
    [BGETBUSINESSNOTES]         BIT            CONSTRAINT [DF_Users_bGetBusinessNotes] DEFAULT ((0)) NOT NULL,
    [BGETCODENEITES]            BIT            CONSTRAINT [DF_Users_bGetCodeNeites] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDON]             DATETIME       CONSTRAINT [DF_USERS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [LASTCHANGEDBY]             CHAR (36)      NULL,
    [GMAPID]                    CHAR (36)      NULL,
    [GLOBALENTITYID]            CHAR (36)      NULL,
    [MAILINGADDRESSID]          CHAR (36)      NULL,
    [ROWVERSION]                INT            CONSTRAINT [DF_Users_iRevision] DEFAULT ((0)) NOT NULL,
    [ISPASSWORDCHANGEREQUIRED]  BIT            CONSTRAINT [DF__Users__IsPasswor__4773309F] DEFAULT ((0)) NOT NULL,
    [APPLICATIONERRORS]         BIT            CONSTRAINT [DF__Users__ShowAppli__351F763A] DEFAULT ((0)) NOT NULL,
    [SECURITYISACTIVEDIRECTORY] BIT            CONSTRAINT [DF__Users__SecurityI__36139A73] DEFAULT ((0)) NOT NULL,
    [COMPANY]                   NVARCHAR (100) NULL,
    [MIDDLENAME]                NVARCHAR (50)  NULL,
    [CREATEDON]                 DATETIME       NULL,
    [TITLE]                     VARCHAR (50)   CONSTRAINT [DF_Users_Title] DEFAULT ('') NOT NULL,
    [CREDENTIALS]               VARCHAR (50)   CONSTRAINT [DF_Users_Credentials] DEFAULT ('') NOT NULL,
    [OFFICEID]                  CHAR (36)      NULL,
    [LICENSE_SUITE]             NVARCHAR (MAX) NULL,
    [MAINMAPSORTORDER]          INT            CONSTRAINT [DF_USERS_DYNAMICMAPSORTORDER] DEFAULT ((0)) NOT NULL,
    [GLOBALPREFFERCOMMID]       INT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([SUSERGUID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_USER_PREFERCOMMID] FOREIGN KEY ([GLOBALPREFFERCOMMID]) REFERENCES [dbo].[GLOBALPREFFERCOMM] ([GLOBALPREFFERCOMMID]),
    CONSTRAINT [FK_Users_GISMap] FOREIGN KEY ([GMAPID]) REFERENCES [dbo].[GISMAP] ([GMAPID]),
    CONSTRAINT [FK_Users_GlobalEntity] FOREIGN KEY ([GLOBALENTITYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID]),
    CONSTRAINT [FK_Users_MailingAddress] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_USERS_OFFICE] FOREIGN KEY ([OFFICEID]) REFERENCES [dbo].[OFFICE] ([OFFICEID]),
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([SROLEID]) REFERENCES [dbo].[ROLES] ([SROLEGUID]),
    CONSTRAINT [FK_Users_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users]
    ON [dbo].[USERS]([ID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_1]
    ON [dbo].[USERS]([EMAIL] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_USERS_ACTIVE_ALL]
    ON [dbo].[USERS]([BACTIVE] ASC)
    INCLUDE([ID], [FNAME], [LNAME], [EMAIL]);


GO
CREATE NONCLUSTERED INDEX [IX_USERS_GLOBALENTITYID]
    ON [dbo].[USERS]([GLOBALENTITYID] ASC);


GO

CREATE TRIGGER [TG_USERS_DELETE] ON USERS 
AFTER DELETE
AS
BEGIN
       SET NOCOUNT ON; 
	  
       IF EXISTS (SELECT OFFICE.LASTCHANGEDBY FROM OFFICE WHERE OFFICE.LASTCHANGEDBY IN (SELECT DELETED.SUSERGUID FROM DELETED))
       BEGIN
              RAISERROR('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table OFFICE', 16, 1)
              ROLLBACK;              
			  RETURN;
       END      

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
			[deleted].[SUSERGUID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'User Deleted',
			'',
			'',
			'User (' + [deleted].[LNAME] + COALESCE(', ' + [deleted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			3,
			1,
			[deleted].[LNAME] + COALESCE (', ' + [deleted].[FNAME], '')
	FROM	[deleted]
END
GO
                                                      
CREATE TRIGGER [TG_USERS_INSERT] ON USERS
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
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'User Added',
			'',
			'',
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			1,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_USERS_UPDATE] ON USERS
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
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Role',
			ISNULL([ROLES_DELETED].[ID], '[none]'),
			ISNULL([ROLES_INSERTED].[ID], '[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
			LEFT JOIN ROLES ROLES_DELETED WITH (NOLOCK) ON [deleted].[SROLEID] = [ROLES_DELETED].[SROLEGUID]
			LEFT JOIN ROLES ROLES_INSERTED WITH (NOLOCK) ON [inserted].[SROLEID] = [ROLES_INSERTED].[SROLEGUID]
	WHERE	ISNULL([deleted].[SROLEID], '') <> ISNULL([inserted].[SROLEID], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Site',
			ISNULL([deleted].[SITEID],'[none]'),
			ISNULL([inserted].[SITEID],'[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	ISNULL([deleted].[SITEID], '') <> ISNULL([inserted].[SITEID], '')	
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'User ID',
			[deleted].[ID],
			[inserted].[ID],
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[ID] <> [inserted].[ID]	
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'First Name',
			ISNULL([deleted].[FNAME], '[none]'),
			ISNULL([inserted].[FNAME], '[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	ISNULL([deleted].[FNAME], '') <> ISNULL([inserted].[FNAME], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Last Name',
			[deleted].[LNAME],
			[inserted].[LNAME],
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[LNAME] <> [inserted].[LNAME]
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Password',
			'******',
			'******',
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[PASSWORD] <> [inserted].[PASSWORD]
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Phone',
			ISNULL([deleted].[PHONE],'[none]'),
			ISNULL([inserted].[PHONE],'[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	ISNULL([deleted].[PHONE], '') <> ISNULL([inserted].[PHONE], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Email',
			ISNULL([deleted].[EMAIL],'[none]'),
			ISNULL([inserted].[EMAIL],'[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	ISNULL([deleted].[EMAIL], '') <> ISNULL([inserted].[EMAIL], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE WHEN [deleted].[BACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[BACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[BACTIVE] <> [inserted].[BACTIVE]
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Get Internet Notes Flag',
			CASE WHEN [deleted].[BGETINTERNETNOTES] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[BGETINTERNETNOTES] = 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[BGETINTERNETNOTES] <> [inserted].[BGETINTERNETNOTES]
		UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Get Business Notes Flag',
			CASE WHEN [deleted].[BGETBUSINESSNOTES] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[BGETBUSINESSNOTES] = 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[BGETBUSINESSNOTES] <> [inserted].[BGETBUSINESSNOTES]
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Get Code Neites Flag',
			CASE WHEN [deleted].[BGETCODENEITES] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[BGETCODENEITES] = 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[BGETCODENEITES] <> [inserted].[BGETCODENEITES]	
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GIS Map Name',
			ISNULL([GISMAP_DELETED].[SMAPNAME], '[none]'),
			ISNULL([GISMAP_INSERTED].[SMAPNAME], '[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
			LEFT JOIN GISMAP GISMAP_DELETED WITH (NOLOCK) ON [deleted].[GMAPID] = [GISMAP_DELETED].[GMAPID]
			LEFT JOIN GISMAP GISMAP_INSERTED WITH (NOLOCK) ON [inserted].[GMAPID] = [GISMAP_INSERTED].[GMAPID]
	WHERE	ISNULL([deleted].[GMAPID], '') <> ISNULL([inserted].[GMAPID], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Global Entity Name',
			ISNULL([GLOBALENTITY_DELETED].[GLOBALENTITYNAME], '[none]'),
			ISNULL([GLOBALENTITY_INSERTED].[GLOBALENTITYNAME], '[none]'),
			'External User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'48C46A90-2E32-439E-A00F-0C09C723809A',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
			LEFT JOIN GLOBALENTITY GLOBALENTITY_DELETED WITH (NOLOCK) ON [deleted].[GLOBALENTITYID] = [GLOBALENTITY_DELETED].[GLOBALENTITYID]
			LEFT JOIN GLOBALENTITY GLOBALENTITY_INSERTED WITH (NOLOCK) ON [inserted].[GLOBALENTITYID] = [GLOBALENTITY_INSERTED].[GLOBALENTITYID]
	WHERE	ISNULL([deleted].[GLOBALENTITYID], '') <> ISNULL([inserted].[GLOBALENTITYID], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Mailing Address',
			ISNULL([MAILINGADDRESS_DELETED].[ADDRESSLINE1] + COALESCE(', ' + [MAILINGADDRESS_DELETED].[ADDRESSLINE2], ''), '[none]'),
			ISNULL([MAILINGADDRESS_INSERTED].[ADDRESSLINE1] + COALESCE(', ' + [MAILINGADDRESS_INSERTED].[ADDRESSLINE2], ''), '[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
			LEFT JOIN MAILINGADDRESS MAILINGADDRESS_DELETED WITH (NOLOCK) ON [deleted].[MAILINGADDRESSID] = [MAILINGADDRESS_DELETED].[MAILINGADDRESSID]
			LEFT JOIN MAILINGADDRESS MAILINGADDRESS_INSERTED WITH (NOLOCK) ON [inserted].[MAILINGADDRESSID] = [MAILINGADDRESS_INSERTED].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[MAILINGADDRESSID], '') <> ISNULL([inserted].[MAILINGADDRESSID], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Change Password Flag',
			CASE WHEN [deleted].[ISPASSWORDCHANGEREQUIRED] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISPASSWORDCHANGEREQUIRED] = 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[ISPASSWORDCHANGEREQUIRED] <> [inserted].[ISPASSWORDCHANGEREQUIRED]	
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Application Errors Flag',
			CASE WHEN [deleted].[APPLICATIONERRORS] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[APPLICATIONERRORS] = 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[APPLICATIONERRORS] <> [inserted].[APPLICATIONERRORS]	
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use Active Directory For Security Flag',
			CASE WHEN [deleted].[SECURITYISACTIVEDIRECTORY] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[SECURITYISACTIVEDIRECTORY] = 1 THEN 'Yes' ELSE 'No' END,
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[SECURITYISACTIVEDIRECTORY] <> [inserted].[SECURITYISACTIVEDIRECTORY]	
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Company',
			ISNULL([deleted].[COMPANY],'[none]'),
			ISNULL([inserted].[COMPANY],'[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	ISNULL([deleted].[COMPANY], '') <> ISNULL([inserted].[COMPANY], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Middle Name',
			ISNULL([deleted].[MIDDLENAME],'[none]'),
			ISNULL([inserted].[MIDDLENAME],'[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	ISNULL([deleted].[MIDDLENAME], '') <> ISNULL([inserted].[MIDDLENAME], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Title',
			[deleted].[TITLE],
			[inserted].[TITLE],			
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[TITLE] <> [inserted].[TITLE]
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Credentials',
			[deleted].[CREDENTIALS],
			[inserted].[CREDENTIALS],			
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[CREDENTIALS] <> [inserted].[CREDENTIALS]
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Office',
			ISNULL([OFFICE_DELETED].[NAME], '[none]'),
			ISNULL([OFFICE_INSERTED].[NAME], '[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
			LEFT JOIN OFFICE OFFICE_DELETED WITH (NOLOCK) ON [deleted].[OFFICEID] = [OFFICE_DELETED].[OFFICEID]
			LEFT JOIN OFFICE OFFICE_INSERTED WITH (NOLOCK) ON [inserted].[OFFICEID] = [OFFICE_INSERTED].[OFFICEID]
	WHERE	ISNULL([deleted].[OFFICEID], '') <> ISNULL([inserted].[OFFICEID], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'License Suite',
			ISNULL([deleted].[LICENSE_SUITE],'[none]'),
			ISNULL([inserted].[LICENSE_SUITE],'[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	ISNULL([deleted].[LICENSE_SUITE], '') <> ISNULL([inserted].[LICENSE_SUITE], '')
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Main Map Sort Order',
			CAST([deleted].[MAINMAPSORTORDER] AS NVARCHAR(MAX)),
			CAST([inserted].[MAINMAPSORTORDER] AS NVARCHAR(MAX)),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
	WHERE	[deleted].[MAINMAPSORTORDER] <> [inserted].[MAINMAPSORTORDER]
	UNION ALL
	SELECT
			[inserted].[SUSERGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Global Preference',
			ISNULL([GLOBALPREFFERCOMM_DELETED].[PREFNAME], '[none]'),
			ISNULL([GLOBALPREFFERCOMM_INSERTED].[PREFNAME], '[none]'),
			'User (' + [inserted].[LNAME] + COALESCE(', ' + [inserted].[FNAME], '') + ')',
			'4282BC67-F36D-41D4-9558-E8BD736B1204',
			2,
			1,
			[inserted].[LNAME] + COALESCE (', ' + [inserted].[FNAME], '')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SUSERGUID] = [inserted].[SUSERGUID]
			LEFT JOIN GLOBALPREFFERCOMM GLOBALPREFFERCOMM_DELETED WITH (NOLOCK) ON [deleted].[GLOBALPREFFERCOMMID] = [GLOBALPREFFERCOMM_DELETED].[GLOBALPREFFERCOMMID]
			LEFT JOIN GLOBALPREFFERCOMM GLOBALPREFFERCOMM_INSERTED WITH (NOLOCK) ON [inserted].[GLOBALPREFFERCOMMID] = [GLOBALPREFFERCOMM_INSERTED].[GLOBALPREFFERCOMMID]
	WHERE	ISNULL([deleted].[GLOBALPREFFERCOMMID], '') <> ISNULL([inserted].[GLOBALPREFFERCOMMID], '')
END