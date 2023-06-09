﻿CREATE TABLE [dbo].[LICENSECYCLE] (
    [LICENSECYCLEID]    CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    [CHARGERENEWALFEE]  BIT            NOT NULL,
    [RENEWALCYCLEID]    CHAR (36)      NOT NULL,
    [RENEWALDEADLINEID] CHAR (36)      NULL,
    [INVOICEDEADLINEID] CHAR (36)      NULL,
    [LASTCHANGEDON]     DATETIME       CONSTRAINT [DF_LICENSECYCLE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]        INT            CONSTRAINT [DF_LICENSECYCLE_RowVersion] DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDBY]     CHAR (36)      NULL,
    CONSTRAINT [PK_LicenseCycle] PRIMARY KEY CLUSTERED ([LICENSECYCLEID] ASC),
    CONSTRAINT [FK_Cycle_InvoiceDeadline] FOREIGN KEY ([INVOICEDEADLINEID]) REFERENCES [dbo].[LICENSECYCLERECURRENCESETUP] ([LICENSECYCLERECURRENCESETUPID]),
    CONSTRAINT [FK_Cycle_RenewalDeadline] FOREIGN KEY ([RENEWALDEADLINEID]) REFERENCES [dbo].[LICENSECYCLERECURRENCESETUP] ([LICENSECYCLERECURRENCESETUPID]),
    CONSTRAINT [FK_LicenseCycle_RenewalCycle] FOREIGN KEY ([RENEWALCYCLEID]) REFERENCES [dbo].[LICENSECYCLERECURRENCESETUP] ([LICENSECYCLERECURRENCESETUPID]),
    CONSTRAINT [FK_LicenseCycleUsers] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [LICENSECYCLE_IX_QUERY]
    ON [dbo].[LICENSECYCLE]([LICENSECYCLEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_LICENSECYCLE_UPDATE] ON  [dbo].[LICENSECYCLE]
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
			[inserted].[LICENSECYCLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'License Cycle (' + [inserted].[NAME] + ')',
			'77752A68-D59D-4B52-A7FD-372B45A9AF80',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLEID] = [inserted].[LICENSECYCLEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[LICENSECYCLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'License Cycle (' + [inserted].[NAME] + ')',
			'77752A68-D59D-4B52-A7FD-372B45A9AF80',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLEID] = [inserted].[LICENSECYCLEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	
	UNION ALL
	SELECT
			[inserted].[LICENSECYCLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Renewal Cycle',
			[LICENSECYCLERECURRENCESETUP_DELETED].[NAME],
			[LICENSECYCLERECURRENCESETUP_INSERTED].[NAME],
			'License Cycle (' + [inserted].[NAME] + ')',
			'77752A68-D59D-4B52-A7FD-372B45A9AF80',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLEID] = [inserted].[LICENSECYCLEID]
			JOIN LICENSECYCLERECURRENCESETUP LICENSECYCLERECURRENCESETUP_DELETED  WITH (NOLOCK) ON [deleted].[RENEWALCYCLEID] = [LICENSECYCLERECURRENCESETUP_DELETED].[LICENSECYCLERECURRENCESETUPID]
			JOIN LICENSECYCLERECURRENCESETUP LICENSECYCLERECURRENCESETUP_INSERTED  WITH (NOLOCK) ON [inserted].[RENEWALCYCLEID] = [LICENSECYCLERECURRENCESETUP_INSERTED].[LICENSECYCLERECURRENCESETUPID]
	WHERE	[deleted].[RENEWALCYCLEID] <> [inserted].[RENEWALCYCLEID]

	UNION ALL
	SELECT
			[inserted].[LICENSECYCLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Renewal Deadline',
			ISNULL([LICENSECYCLERECURRENCESETUP_DELETED].[NAME], '[none]'),
			ISNULL([LICENSECYCLERECURRENCESETUP_INSERTED].[NAME], '[none]'),
			'License Cycle (' + [inserted].[NAME] + ')',
			'77752A68-D59D-4B52-A7FD-372B45A9AF80',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLEID] = [inserted].[LICENSECYCLEID]
			LEFT JOIN LICENSECYCLERECURRENCESETUP LICENSECYCLERECURRENCESETUP_DELETED WITH (NOLOCK) ON [deleted].[RENEWALDEADLINEID] = [LICENSECYCLERECURRENCESETUP_DELETED].[LICENSECYCLERECURRENCESETUPID]
			LEFT JOIN LICENSECYCLERECURRENCESETUP LICENSECYCLERECURRENCESETUP_INSERTED WITH (NOLOCK) ON [inserted].[RENEWALDEADLINEID] = [LICENSECYCLERECURRENCESETUP_INSERTED].[LICENSECYCLERECURRENCESETUPID]
	WHERE	ISNULL([deleted].[RENEWALDEADLINEID], '') <> ISNULL([inserted].[RENEWALDEADLINEID], '')

	UNION ALL
	SELECT
			[inserted].[LICENSECYCLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Invoice Deadline',
			ISNULL([LICENSECYCLERECURRENCESETUP_DELETED].[NAME], '[none]'),
			ISNULL([LICENSECYCLERECURRENCESETUP_INSERTED].[NAME], '[none]'),
			'License Cycle (' + [inserted].[NAME] + ')',
			'77752A68-D59D-4B52-A7FD-372B45A9AF80',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLEID] = [inserted].[LICENSECYCLEID]
			LEFT JOIN LICENSECYCLERECURRENCESETUP LICENSECYCLERECURRENCESETUP_DELETED WITH (NOLOCK) ON [deleted].[INVOICEDEADLINEID] = [LICENSECYCLERECURRENCESETUP_DELETED].[LICENSECYCLERECURRENCESETUPID]
			LEFT JOIN LICENSECYCLERECURRENCESETUP LICENSECYCLERECURRENCESETUP_INSERTED WITH (NOLOCK) ON [inserted].[INVOICEDEADLINEID] = [LICENSECYCLERECURRENCESETUP_INSERTED].[LICENSECYCLERECURRENCESETUPID]
	WHERE	ISNULL([deleted].[INVOICEDEADLINEID], '') <> ISNULL([inserted].[INVOICEDEADLINEID], '')

	UNION ALL
	SELECT
			[inserted].[LICENSECYCLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Charge Renewal Fee Flag',
			CASE [deleted].[CHARGERENEWALFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[CHARGERENEWALFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'License Cycle (' + [inserted].[NAME] + ')',
			'77752A68-D59D-4B52-A7FD-372B45A9AF80',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLEID] = [inserted].[LICENSECYCLEID]
	 WHERE	[deleted].[CHARGERENEWALFEE] <> [inserted].[CHARGERENEWALFEE]
END
GO

CREATE TRIGGER [dbo].[TG_[LICENSECYCLE_INSERT] ON [dbo].[LICENSECYCLE]
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
        [inserted].[LICENSECYCLEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'License Cycle Added',
        '',
        '',
        'License Cycle (' + [inserted].[NAME] + ')',
		'77752A68-D59D-4B52-A7FD-372B45A9AF80',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_LICENSECYCLE_DELETE] ON  [dbo].[LICENSECYCLE]
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
			[deleted].[LICENSECYCLEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'License Cycle Deleted',
			'',
			'',
			'License Cycle (' + [deleted].[NAME] + ')',
			'77752A68-D59D-4B52-A7FD-372B45A9AF80',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END