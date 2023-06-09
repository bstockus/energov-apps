﻿CREATE TABLE [dbo].[PMPERMITTYPEWORKCLASS] (
    [PMPERMITTYPEWORKCLASSID]              CHAR (36) NOT NULL,
    [PMPERMITTYPEID]                       CHAR (36) NOT NULL,
    [PMPERMITWORKCLASSID]                  CHAR (36) NOT NULL,
    [WFTEMPLATEID]                         CHAR (36) NOT NULL,
    [CUSTOMFIELDLAYOUTID]                  CHAR (36) NULL,
    [CAFEETEMPLATEID]                      CHAR (36) NULL,
    [ONLINECUSTOMFIELDLAYOUTID]            CHAR (36) NULL,
    [INTERNETFLAG]                         BIT       NULL,
    [PMPERMITCAPAPPLICATIONTYPEID]         INT       CONSTRAINT [DF_PMPermitTypeWorkClass_CAPApplicationTypeID] DEFAULT ((0)) NOT NULL,
    [ISCAPADDRESSREQUIRED]                 BIT       CONSTRAINT [DF_PMPERMITTYPEWORKCLASS_ISCAPADDRESSREQUIRED] DEFAULT ((1)) NOT NULL,
    [RENEWALFEETEMPLATEID]                 CHAR (36) NULL,
    [PLREVIEWITEMCAPVISIBILITYID]          INT       CONSTRAINT [DF_PMPERMITTYPEWORKCLASS_PLREVIEWITEMCAPVISIBILITYID] DEFAULT ((1)) NOT NULL,
    [FILESETID]                            CHAR (36) NULL,
    [REQUIREALLCERTTYPE]                   BIT       CONSTRAINT [DF_PMPERMITTYPEWORKCLASS_REQUIREALLCERTTYPE] DEFAULT ((0)) NOT NULL,
    [DEFAULTCASEASSIGNEDTO]                CHAR (36) NULL,
    [VALIDATECERTIFICATIONSFORALLCONTACTS] BIT       CONSTRAINT [DF_PMPERMITTYPEWORKCLASS_VALIDATECERTIFICATIONSFORALLCONTACTS] DEFAULT ((0)) NOT NULL,
    [VALIDATEPROFLICENSESFORALLCONTACTS]   BIT       CONSTRAINT [DF_PMPERMITTYPEWORKCLASS_VALIDATEPROFLICENSESFORALLCONTACTS] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PMPermitTypeWorkClass] PRIMARY KEY CLUSTERED ([PMPERMITTYPEWORKCLASSID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PERMITTYPEWCLASS_CAP_VIS] FOREIGN KEY ([PLREVIEWITEMCAPVISIBILITYID]) REFERENCES [dbo].[PLREVIEWITEMCAPVISIBILITY] ([PLREVIEWITEMCAPVISIBILITYID]),
    CONSTRAINT [FK_PMPermitTypeWorkClass_CAPApplicationType] FOREIGN KEY ([PMPERMITCAPAPPLICATIONTYPEID]) REFERENCES [dbo].[PMPERMITCAPAPPLICATIONTYPE] ([PMPERMITCAPAPPLICATIONTYPEID]),
    CONSTRAINT [FK_PMPermitTypeWorkClass_Custom] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_PMPERMITTYPEWORKCLASS_DefaultCaseAssigned] FOREIGN KEY ([DEFAULTCASEASSIGNEDTO]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_PMPERMITTYPEWORKCLASS_FileSet] FOREIGN KEY ([FILESETID]) REFERENCES [dbo].[FILESET] ([FILESETID]),
    CONSTRAINT [FK_PMPermitTypeWorkClass_OnlineCustom] FOREIGN KEY ([ONLINECUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_PMTypeWorkClass_Type] FOREIGN KEY ([PMPERMITTYPEID]) REFERENCES [dbo].[PMPERMITTYPE] ([PMPERMITTYPEID]),
    CONSTRAINT [FK_PMTypeWorkClass_WFTemplate] FOREIGN KEY ([WFTEMPLATEID]) REFERENCES [dbo].[WFTEMPLATE] ([WFTEMPLATEID]),
    CONSTRAINT [FK_PMTypeWorkClass_WorkClass] FOREIGN KEY ([PMPERMITWORKCLASSID]) REFERENCES [dbo].[PMPERMITWORKCLASS] ([PMPERMITWORKCLASSID]),
    CONSTRAINT [FK_PMTypeWrkClass_FeeTemplate] FOREIGN KEY ([CAFEETEMPLATEID]) REFERENCES [dbo].[CAFEETEMPLATE] ([CAFEETEMPLATEID]),
    CONSTRAINT [FK_PMTYWC_PMRENEWALFEETEMP] FOREIGN KEY ([RENEWALFEETEMPLATEID]) REFERENCES [dbo].[CAFEETEMPLATE] ([CAFEETEMPLATEID])
);


GO
CREATE TRIGGER [dbo].[TG_PMPERMITTYPEWORKCLASS_UPDATE]
   ON  [dbo].[PMPERMITTYPEWORKCLASS] 
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
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Work Class',			
			[PMPERMITWORKCLASS_DELETED].[NAME],			
			[PMPERMITWORKCLASS_INSERTED].[NAME],
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS_INSERTED].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS_INSERTED].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] [PMPERMITWORKCLASS_DELETED] WITH (NOLOCK) ON [deleted].[PMPERMITWORKCLASSID] = [PMPERMITWORKCLASS_DELETED].[PMPERMITWORKCLASSID]
			INNER JOIN [PMPERMITWORKCLASS] [PMPERMITWORKCLASS_INSERTED] WITH (NOLOCK) ON [inserted].[PMPERMITWORKCLASSID] = [PMPERMITWORKCLASS_INSERTED].[PMPERMITWORKCLASSID]			
	WHERE	[deleted].[PMPERMITWORKCLASSID] <> [inserted].[PMPERMITWORKCLASSID]
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Workflow Template',			
			[WFTEMPLATE_DELETED].[NAME],			
			[WFTEMPLATE_INSERTED].[NAME],
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			INNER JOIN [WFTEMPLATE] [WFTEMPLATE_DELETED] WITH (NOLOCK) ON [deleted].[WFTEMPLATEID] = [WFTEMPLATE_DELETED].[WFTEMPLATEID]
			INNER JOIN [WFTEMPLATE] [WFTEMPLATE_INSERTED] WITH (NOLOCK) ON [inserted].[WFTEMPLATEID] = [WFTEMPLATE_INSERTED].[WFTEMPLATEID]
	WHERE	[deleted].WFTEMPLATEID <> [inserted].WFTEMPLATEID
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),		
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_DELETED] WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_INSERTED] WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID],'') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID],'')
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Online Custom Field Layout',
			ISNULL([ONLINECUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),		
			ISNULL([ONLINECUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [ONLINECUSTOMFIELDLAYOUT_DELETED] WITH (NOLOCK) ON [deleted].[ONLINECUSTOMFIELDLAYOUTID] = [ONLINECUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [ONLINECUSTOMFIELDLAYOUT_INSERTED] WITH (NOLOCK) ON [inserted].[ONLINECUSTOMFIELDLAYOUTID] = [ONLINECUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[ONLINECUSTOMFIELDLAYOUTID],'') <> ISNULL([inserted].[ONLINECUSTOMFIELDLAYOUTID],'')
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Allow Review in CAP',
			[PLREVIEWITEMCAPVISIBILITY_DELETED].[NAME],			
			[PLREVIEWITEMCAPVISIBILITY_INSERTED].[NAME],
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			INNER JOIN [PLREVIEWITEMCAPVISIBILITY] [PLREVIEWITEMCAPVISIBILITY_DELETED] WITH (NOLOCK) ON [deleted].[PLREVIEWITEMCAPVISIBILITYID] = [PLREVIEWITEMCAPVISIBILITY_DELETED].[PLREVIEWITEMCAPVISIBILITYID]
			INNER JOIN [PLREVIEWITEMCAPVISIBILITY] [PLREVIEWITEMCAPVISIBILITY_INSERTED] WITH (NOLOCK) ON [inserted].[PLREVIEWITEMCAPVISIBILITYID] = [PLREVIEWITEMCAPVISIBILITY_INSERTED].[PLREVIEWITEMCAPVISIBILITYID]
	WHERE	[deleted].[PLREVIEWITEMCAPVISIBILITYID] <> [inserted].[PLREVIEWITEMCAPVISIBILITYID]
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Fee Template',
			ISNULL([CAFEETEMPLATE_DELETED].[CAFEETEMPLATENAME],'[none]'),
			ISNULL([CAFEETEMPLATE_INSERTED].[CAFEETEMPLATENAME],'[none]'),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			LEFT JOIN [CAFEETEMPLATE] [CAFEETEMPLATE_DELETED] WITH (NOLOCK) ON [deleted].[CAFEETEMPLATEID] = [CAFEETEMPLATE_DELETED].[CAFEETEMPLATEID]
			LEFT JOIN [CAFEETEMPLATE] [CAFEETEMPLATE_INSERTED] WITH (NOLOCK) ON [inserted].[CAFEETEMPLATEID] = [CAFEETEMPLATE_INSERTED].[CAFEETEMPLATEID]
	WHERE	ISNULL([deleted].[CAFEETEMPLATEID],'') <> ISNULL([inserted].[CAFEETEMPLATEID],'')
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Renewal Fee Template',
			ISNULL([RENEWALFEETEMPLATE_DELETED].[CAFEETEMPLATENAME],'[none]'),
			ISNULL([RENEWALFEETEMPLATE_INSERTED].[CAFEETEMPLATENAME],'[none]'),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			LEFT JOIN [CAFEETEMPLATE] [RENEWALFEETEMPLATE_DELETED] WITH (NOLOCK) ON [deleted].[RENEWALFEETEMPLATEID] = [RENEWALFEETEMPLATE_DELETED].[CAFEETEMPLATEID]
			LEFT JOIN [CAFEETEMPLATE] [RENEWALFEETEMPLATE_INSERTED] WITH (NOLOCK) ON [inserted].[RENEWALFEETEMPLATEID] = [RENEWALFEETEMPLATE_INSERTED].[CAFEETEMPLATEID]	
	WHERE	ISNULL([deleted].[RENEWALFEETEMPLATEID],'') <> ISNULL([inserted].[RENEWALFEETEMPLATEID],'')
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Internet Flag Set',
			CASE [deleted].[INTERNETFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[INTERNETFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = [inserted].PMPERMITTYPEID
			INNER JOIN PMPERMITWORKCLASS WITH (NOLOCK) ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = [inserted].PMPERMITWORKCLASSID
	WHERE	[deleted].[INTERNETFLAG] <> [inserted].[INTERNETFLAG]
			OR ([deleted].[INTERNETFLAG] IS NULL AND [inserted].[INTERNETFLAG] IS NOT NULL)
			OR ([deleted].[INTERNETFLAG] IS NOT NULL AND [inserted].[INTERNETFLAG] IS NULL)
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Internet Apply Type',
			[PMPERMITCAPAPPLICATIONTYPE_DELETED].[NAME],
			[PMPERMITCAPAPPLICATIONTYPE_INSERTED].[NAME],
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			INNER JOIN [PMPERMITCAPAPPLICATIONTYPE] [PMPERMITCAPAPPLICATIONTYPE_DELETED] WITH (NOLOCK) ON [deleted].[PMPERMITCAPAPPLICATIONTYPEID] = [PMPERMITCAPAPPLICATIONTYPE_DELETED].[PMPERMITCAPAPPLICATIONTYPEID]
			INNER JOIN [PMPERMITCAPAPPLICATIONTYPE] [PMPERMITCAPAPPLICATIONTYPE_INSERTED] WITH (NOLOCK) ON [inserted].[PMPERMITCAPAPPLICATIONTYPEID] = [PMPERMITCAPAPPLICATIONTYPE_INSERTED].[PMPERMITCAPAPPLICATIONTYPEID]
	WHERE	[deleted].[PMPERMITCAPAPPLICATIONTYPEID] <> [inserted].[PMPERMITCAPAPPLICATIONTYPEID]
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'CAP Address Required Flag',
			CASE [deleted].[ISCAPADDRESSREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISCAPADDRESSREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
	WHERE	[deleted].[ISCAPADDRESSREQUIRED] <> [inserted].[ISCAPADDRESSREQUIRED]
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'File Set',
			ISNULL([FILESET_DELETED].[NAME],'[none]'),
			ISNULL([FILESET_INSERTED].[NAME],'[none]'),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			LEFT JOIN [FILESET] [FILESET_DELETED] WITH (NOLOCK) ON [deleted].[FILESETID] = [FILESET_DELETED].[FILESETID]
			LEFT JOIN [FILESET] [FILESET_INSERTED] WITH (NOLOCK) ON [inserted].[FILESETID] = [FILESET_INSERTED].[FILESETID]
	WHERE	ISNULL([deleted].[FILESETID],'') <> ISNULL([inserted].[FILESETID],'')
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Default Case Assigned To',
			ISNULL([USERS_DELETED].[LNAME] + COALESCE(', ' + [USERS_DELETED].[FNAME], ''),'[none]'),
            ISNULL([USERS_INSERTED].[LNAME] + COALESCE(', ' + [USERS_INSERTED].[FNAME], '') ,'[none]'),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			LEFT JOIN [USERS] [USERS_DELETED] WITH (NOLOCK) ON [deleted].[DEFAULTCASEASSIGNEDTO] = [USERS_DELETED].[SUSERGUID]
			LEFT JOIN [USERS] [USERS_INSERTED] WITH (NOLOCK) ON [inserted].[DEFAULTCASEASSIGNEDTO] = [USERS_INSERTED].[SUSERGUID]
	WHERE	ISNULL([deleted].[DEFAULTCASEASSIGNEDTO],'') <> ISNULL([inserted].[DEFAULTCASEASSIGNEDTO],'')
	UNION ALL
	SELECT
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Certification Require All',
			CASE [deleted].[REQUIREALLCERTTYPE]	 WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[REQUIREALLCERTTYPE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + ISNULL([PMPERMITWORKCLASS].[NAME],'[none]'),
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[PMPERMITWORKCLASS].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEWORKCLASSID] = [inserted].[PMPERMITTYPEWORKCLASSID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
			LEFT JOIN [USERS] [USERS_DELETED] WITH (NOLOCK) ON [deleted].[DEFAULTCASEASSIGNEDTO] = [USERS_DELETED].[SUSERGUID]
			LEFT JOIN [USERS] [USERS_INSERTED] WITH (NOLOCK) ON [inserted].[DEFAULTCASEASSIGNEDTO] = [USERS_INSERTED].[SUSERGUID]
	WHERE	[deleted].[REQUIREALLCERTTYPE] <> [inserted].[REQUIREALLCERTTYPE]
END
GO
CREATE TRIGGER [dbo].[TG_PMPERMITTYPEWORKCLASS_INSERT]
   ON  [dbo].[PMPERMITTYPEWORKCLASS]
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
        [PMPERMITTYPE].[PMPERMITTYPEID], 
        [PMPERMITTYPE].[ROWVERSION],
        GETUTCDATE(),
        [PMPERMITTYPE].[LASTCHANGEDBY],	
        'Permit Type Work Class Added',
        '',
        '',       
		'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
		'4976A4A9-20E8-4B8F-997D-CE244B540104',
		1,
		0,
		[PMPERMITWORKCLASS].[NAME]
    FROM [inserted]
	INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[PMPERMITWORKCLASSID]
END
GO
CREATE TRIGGER [dbo].[TG_PMPERMITTYPEWORKCLASS_DELETE]  
   ON  [dbo].[PMPERMITTYPEWORKCLASS] 
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
		[PMPERMITTYPE].[PMPERMITTYPEID],
		[PMPERMITTYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Permit Type Work Class Deleted',
        '',
        '',       
		'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +')',
		'4976A4A9-20E8-4B8F-997D-CE244B540104',
		3,
		0,
		[PMPERMITWORKCLASS].[NAME]
    FROM [deleted]
	INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [deleted].[PMPERMITTYPEID]
	INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [deleted].[PMPERMITWORKCLASSID]
END