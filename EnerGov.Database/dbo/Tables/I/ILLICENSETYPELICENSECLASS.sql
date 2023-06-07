﻿CREATE TABLE [dbo].[ILLICENSETYPELICENSECLASS] (
    [ILLICENSETYPELICENSECLASSID]   CHAR (36) NOT NULL,
    [ILLICENSECLASSIFICATIONID]     CHAR (36) NOT NULL,
    [ILLICENSETYPEID]               CHAR (36) NOT NULL,
    [LICENSECYCLEID]                CHAR (36) NULL,
    [CUSTOMFIELDLAYOUTID]           CHAR (36) NULL,
    [WFTEMPLATEID]                  CHAR (36) NOT NULL,
    [CAFEETEMPLATEID]               CHAR (36) NULL,
    [ILLICENSECAPAPPLICATIONTYPEID] INT       NOT NULL,
    [INTERNETFLAG]                  BIT       NOT NULL,
    [ONLINECUSTOMFIELDLAYOUTID]     CHAR (36) NULL,
    [WFTEMPLATERENEWALID]           CHAR (36) NULL,
    [RENEWALDAYSPRIORTOEXPIRE]      INT       NULL,
    [CAPADDRESSREQUIRED]            BIT       DEFAULT ((0)) NOT NULL,
    [CANRENEWONLINE]                BIT       DEFAULT ((0)) NOT NULL,
    [CAPRENEWALAPPLICATIONTYPEID]   INT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ILLICENSETYPELICENSECLASS_1] PRIMARY KEY CLUSTERED ([ILLICENSETYPELICENSECLASSID] ASC),
    CONSTRAINT [FK_FEETEMPLATEID_FEETEMPLATE] FOREIGN KEY ([CAFEETEMPLATEID]) REFERENCES [dbo].[CAFEETEMPLATE] ([CAFEETEMPLATEID]),
    CONSTRAINT [FK_ILLICTYPECLASS_CAPAPPTYPE] FOREIGN KEY ([ILLICENSECAPAPPLICATIONTYPEID]) REFERENCES [dbo].[ILLICENSECAPAPPLICATIONTYPE] ([ILLICENSECAPAPPLICATIONTYPEID]),
    CONSTRAINT [FK_ILLICTYPELICCLASS_CAPRENEWAPPTYPE] FOREIGN KEY ([CAPRENEWALAPPLICATIONTYPEID]) REFERENCES [dbo].[ILLICENSECAPAPPLICATIONTYPE] ([ILLICENSECAPAPPLICATIONTYPEID]),
    CONSTRAINT [FK_ILLICTYPELICCLASS_LAYOUT] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_ILLICTYPELICCLASS_LICCYCLE] FOREIGN KEY ([LICENSECYCLEID]) REFERENCES [dbo].[LICENSECYCLE] ([LICENSECYCLEID]),
    CONSTRAINT [FK_ILLICTYPELICCLASS_WEBLAYOUT] FOREIGN KEY ([ONLINECUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_LicTypeLicClass_LicClass] FOREIGN KEY ([ILLICENSECLASSIFICATIONID]) REFERENCES [dbo].[ILLICENSECLASSIFICATION] ([ILLICENSECLASSIFICATIONID]),
    CONSTRAINT [FK_LicTypeLicClass_LicType] FOREIGN KEY ([ILLICENSETYPEID]) REFERENCES [dbo].[ILLICENSETYPE] ([ILLICENSETYPEID]),
    CONSTRAINT [FK_WFTEMPLATEID_WFTEMPLATE] FOREIGN KEY ([WFTEMPLATEID]) REFERENCES [dbo].[WFTEMPLATE] ([WFTEMPLATEID]),
    CONSTRAINT [FK_WFTEMPLATEID_WFTEMPLATE2] FOREIGN KEY ([WFTEMPLATERENEWALID]) REFERENCES [dbo].[WFTEMPLATE] ([WFTEMPLATEID])
);


GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPELICENSECLASS_DELETE]  ON  [dbo].[ILLICENSETYPELICENSECLASS] 
   AFTER DELETE
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
		[ILLICENSETYPE].[ILLICENSETYPEID],
		[ILLICENSETYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Professional License Type License Classification Deleted',
        '',
        '',       
		'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
		'67978C16-D720-4F8E-8120-E00FBB732A77',
		3,
		0,
		[ILLICENSECLASSIFICATION].[NAME]
    FROM [deleted]
	INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [deleted].[ILLICENSETYPEID]
	INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [deleted].[ILLICENSECLASSIFICATIONID]
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPELICENSECLASS_INSERT] ON  [dbo].[ILLICENSETYPELICENSECLASS]
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
        [ILLICENSETYPE].[ILLICENSETYPEID], 
        [ILLICENSETYPE].[ROWVERSION],
        GETUTCDATE(),
        [ILLICENSETYPE].[LASTCHANGEDBY],	
        'Professional License Type License Classification Added',
        '',
        '',       
		'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
		'67978C16-D720-4F8E-8120-E00FBB732A77',
		1,
		0,
		[ILLICENSECLASSIFICATION].[NAME]
    FROM [inserted]
	INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPELICENSECLASS_UPDATE] ON  [dbo].[ILLICENSETYPELICENSECLASS] 
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
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Classification Name',			
			[ILLICENSECLASSIFICATION_DELETED].[NAME],	
			[ILLICENSECLASSIFICATION_INSERTED].[NAME],	
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION_INSERTED].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION_INSERTED].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] AS [ILLICENSECLASSIFICATION_DELETED] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION_DELETED].[ILLICENSECLASSIFICATIONID] = [deleted].[ILLICENSECLASSIFICATIONID]
			INNER JOIN [ILLICENSECLASSIFICATION] AS [ILLICENSECLASSIFICATION_INSERTED] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION_INSERTED].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]					
	WHERE	[deleted].[ILLICENSECLASSIFICATIONID] <> [inserted].[ILLICENSECLASSIFICATIONID]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Cycle Name',			
			ISNULL([LICENSECYCLE_DELETED].[NAME],'[none]'),	
			ISNULL([LICENSECYCLE_INSERTED].[NAME],'[none]'),	
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [LICENSECYCLE] [LICENSECYCLE_DELETED] WITH (NOLOCK) ON [deleted].[LICENSECYCLEID] = [LICENSECYCLE_DELETED].[LICENSECYCLEID]
			LEFT JOIN [LICENSECYCLE] [LICENSECYCLE_INSERTED] WITH (NOLOCK) ON [inserted].[LICENSECYCLEID] = [LICENSECYCLE_INSERTED].[LICENSECYCLEID]			
	WHERE	ISNULL([deleted].[LICENSECYCLEID],'') <> ISNULL([inserted].[LICENSECYCLEID],'')
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Initial Workflow Template',	
			ISNULL([WFTEMPLATE_DELETED].[NAME],'[none]'),
			ISNULL([WFTEMPLATE_INSERTED].[NAME],'[none]'),				
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [WFTEMPLATE] [WFTEMPLATE_DELETED] WITH (NOLOCK) ON [deleted].[WFTEMPLATEID] = [WFTEMPLATE_DELETED].[WFTEMPLATEID]
			LEFT JOIN [WFTEMPLATE] [WFTEMPLATE_INSERTED] WITH (NOLOCK) ON [inserted].[WFTEMPLATEID] = [WFTEMPLATE_INSERTED].[WFTEMPLATEID]
	WHERE	[deleted].[WFTEMPLATEID] <> [inserted].[WFTEMPLATEID]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Renewal Workflow Template',		
			ISNULL([WFTEMPLATE_DELETED].[NAME],'[none]'),
			ISNULL([WFTEMPLATE_INSERTED].[NAME],'[none]'),	
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [WFTEMPLATE] [WFTEMPLATE_DELETED] WITH (NOLOCK) ON [deleted].[WFTEMPLATERENEWALID] = [WFTEMPLATE_DELETED].[WFTEMPLATEID]
			LEFT JOIN [WFTEMPLATE] [WFTEMPLATE_INSERTED] WITH (NOLOCK) ON [inserted].[WFTEMPLATERENEWALID] = [WFTEMPLATE_INSERTED].[WFTEMPLATEID]
	WHERE	ISNULL([deleted].[WFTEMPLATERENEWALID],'') <> ISNULL([inserted].[WFTEMPLATERENEWALID],'')
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),		
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_DELETED] WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_INSERTED] WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID],'') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID],'')
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Online Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),		
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_DELETED] WITH (NOLOCK) ON [deleted].[ONLINECUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_INSERTED] WITH (NOLOCK) ON [inserted].[ONLINECUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[ONLINECUSTOMFIELDLAYOUTID],'') <> ISNULL([inserted].[ONLINECUSTOMFIELDLAYOUTID],'')
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Fee Template',
			ISNULL([CAFEETEMPLATE_DELETED].[CAFEETEMPLATENAME],'[none]'),
			ISNULL([CAFEETEMPLATE_INSERTED].[CAFEETEMPLATENAME],'[none]'),
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [CAFEETEMPLATE] [CAFEETEMPLATE_DELETED] WITH (NOLOCK) ON [deleted].[CAFEETEMPLATEID] = [CAFEETEMPLATE_DELETED].[CAFEETEMPLATEID]
			LEFT JOIN [CAFEETEMPLATE] [CAFEETEMPLATE_INSERTED] WITH (NOLOCK) ON [inserted].[CAFEETEMPLATEID] = [CAFEETEMPLATE_INSERTED].[CAFEETEMPLATEID]
	WHERE	ISNULL([deleted].[CAFEETEMPLATEID],'') <> ISNULL([inserted].[CAFEETEMPLATEID],'')
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Internet Flag',
			CASE [deleted].[INTERNETFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[INTERNETFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].ILLICENSECLASSIFICATIONID = [inserted].ILLICENSECLASSIFICATIONID
	WHERE	[deleted].[INTERNETFLAG] <> [inserted].[INTERNETFLAG]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Online Apply Type Name',
			ISNULL([ILLICENSECAPAPPLICATIONTYPE_DELETED].[NAME],'[none]'),
			ISNULL([ILLICENSECAPAPPLICATIONTYPE_INSERTED].[NAME],'[none]'),
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [ILLICENSECAPAPPLICATIONTYPE] [ILLICENSECAPAPPLICATIONTYPE_DELETED] WITH (NOLOCK) ON [ILLICENSECAPAPPLICATIONTYPE_DELETED].[ILLICENSECAPAPPLICATIONTYPEID] = [deleted].[ILLICENSECAPAPPLICATIONTYPEID]
			LEFT JOIN [ILLICENSECAPAPPLICATIONTYPE] [ILLICENSECAPAPPLICATIONTYPE_INSERTED] WITH (NOLOCK) ON [ILLICENSECAPAPPLICATIONTYPE_INSERTED].[ILLICENSECAPAPPLICATIONTYPEID] = [inserted].[ILLICENSECAPAPPLICATIONTYPEID]
	WHERE	[deleted].[ILLICENSECAPAPPLICATIONTYPEID] <> [inserted].[ILLICENSECAPAPPLICATIONTYPEID]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Renew Online Flag',
			CASE [deleted].[CANRENEWONLINE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[CANRENEWONLINE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].ILLICENSETYPEID = [inserted].ILLICENSETYPEID
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
	WHERE	[deleted].[CANRENEWONLINE] <> [inserted].[CANRENEWONLINE]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Online Renew Type Name',
			ISNULL([ILLICENSECAPAPPLICATIONTYPE_DELETED].[NAME],'[none]'),
			ISNULL([ILLICENSECAPAPPLICATIONTYPE_INSERTED].[NAME],'[none]'),
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].ILLICENSETYPEID = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
			LEFT JOIN [ILLICENSECAPAPPLICATIONTYPE] [ILLICENSECAPAPPLICATIONTYPE_DELETED] WITH (NOLOCK) ON [ILLICENSECAPAPPLICATIONTYPE_DELETED].[ILLICENSECAPAPPLICATIONTYPEID] = [deleted].[CAPRENEWALAPPLICATIONTYPEID]
			LEFT JOIN [ILLICENSECAPAPPLICATIONTYPE] [ILLICENSECAPAPPLICATIONTYPE_INSERTED] WITH (NOLOCK) ON [ILLICENSECAPAPPLICATIONTYPE_INSERTED].[ILLICENSECAPAPPLICATIONTYPEID] = [inserted].[CAPRENEWALAPPLICATIONTYPEID]
	WHERE	[deleted].[CAPRENEWALAPPLICATIONTYPEID] <> [inserted].[CAPRENEWALAPPLICATIONTYPEID]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'CAP Address Required Flag',
			CASE [deleted].[CAPADDRESSREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[CAPADDRESSREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
	WHERE	[deleted].[CAPADDRESSREQUIRED] <> [inserted].[CAPADDRESSREQUIRED]	
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID],
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Early Renewal Buffer Days',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[RENEWALDAYSPRIORTOEXPIRE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[RENEWALDAYSPRIORTOEXPIRE]),'[none]'),			
			'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[ILLICENSECLASSIFICATION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPELICENSECLASSID] = [inserted].[ILLICENSETYPELICENSECLASSID]
			INNER JOIN [ILLICENSETYPE] ON [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
	WHERE	ISNULL([deleted].[RENEWALDAYSPRIORTOEXPIRE],'') <> ISNULL([inserted].[RENEWALDAYSPRIORTOEXPIRE],'')
END