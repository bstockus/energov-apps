CREATE TABLE [dbo].[HOLDTYPESETUPS] (
    [HOLDSETUPID]                   CHAR (36)     NOT NULL,
    [HOLDTYPEID]                    INT           NULL,
    [DESCRIPTION]                   VARCHAR (255) NULL,
    [MODULEID]                      INT           NULL,
    [ACTIVE]                        BIT           NULL,
    [ALLOWHOLDOVERRIDES]            BIT           NULL,
    [DISPLAYHOLDMESSAGEONBAR]       BIT           NULL,
    [RESTRICTHOLDRELEASE]           BIT           NULL,
    [ALERTMESSAGE]                  VARCHAR (MAX) NULL,
    [PERMITNEW]                     BIT           NULL,
    [PERMITISSUANCE]                BIT           NULL,
    [PERMITINSPECTION]              BIT           NULL,
    [PERMITFLAGSTATUS]              CHAR (36)     NULL,
    [PLANNEW]                       BIT           NULL,
    [PLANCOMPLETE]                  BIT           NULL,
    [PLANWFSUBREVIVIEW]             BIT           NULL,
    [PLANINSPECTION]                BIT           NULL,
    [PLANFLAGSTATUS]                CHAR (36)     NULL,
    [PROJECTNEWCHILD]               BIT           NULL,
    [PROJECTCOMPLETE]               BIT           NULL,
    [PROJECTINSPECTION]             BIT           NULL,
    [PROJECTEXTENDHOLDTOCHILD]      BIT           NULL,
    [PROJECTFLAGSTATUS]             CHAR (36)     NULL,
    [ENTCREDITCARDPAY]              BIT           NULL,
    [ENTCHECKPAY]                   BIT           NULL,
    [ENTONLINEPERMITAPPLICANT]      BIT           NULL,
    [ENTONLINEPLANAPPLICANT]        BIT           NULL,
    [ENTONLINEINSPECTIONREQUEST]    BIT           NULL,
    [ENTBUSINESSLICRENEWAL]         BIT           NULL,
    [ENTPROLICRENEWAL]              BIT           NULL,
    [PERMITFINALING]                BIT           NULL,
    [PARCELENFORESTARTENDDT]        BIT           NULL,
    [PARCELENFORCEMAINPARCELONLY]   BIT           NULL,
    [PARCELENFORCEPERM]             BIT           NULL,
    [PARCELENFORCEPLAN]             BIT           NULL,
    [PARCELENFORCEPROJECT]          BIT           NULL,
    [NAME]                          VARCHAR (50)  NULL,
    [BNEWLICENSE]                   BIT           NULL,
    [BRENEWLICENSE]                 BIT           NULL,
    [BUSINESSINSP]                  BIT           NULL,
    [BLEXTSTATUSID]                 CHAR (36)     NULL,
    [BLRENEW]                       BIT           NULL,
    [BLWF]                          BIT           NULL,
    [BLPULLPERMIT]                  BIT           NULL,
    [BLPULLPLAN]                    BIT           NULL,
    [BLSTATUS]                      CHAR (36)     NULL,
    [PLRENEW]                       BIT           NULL,
    [ILWF]                          BIT           NULL,
    [ILPULLPERMIT]                  BIT           NULL,
    [ILPULLPLAN]                    BIT           NULL,
    [ILPULLBL]                      BIT           NULL,
    [ILSTATUS]                      CHAR (36)     NULL,
    [RPLANDLORDLICENSESTATUSID]     CHAR (36)     NULL,
    [ALLOWNEWRENTALPROPERTY]        BIT           NULL,
    [RPPROPERTYSTATUSID]            CHAR (36)     NULL,
    [ALLOWRENTALPROPERTYINSPECTION] BIT           NULL,
    [PERMITRENEWALRESTRICTION]      BIT           NULL,
    [PERMITWFSUBREVIEW]             BIT           NULL,
    [LASTCHANGEDBY]                 CHAR (36)     NULL,
    [LASTCHANGEDON]                 DATETIME      CONSTRAINT [DF_HOLDTYPESETUPS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                    INT           CONSTRAINT [DF_HOLDTYPESETUPS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_HoldTypeSetups] PRIMARY KEY CLUSTERED ([HOLDSETUPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HOLDTYPESETUP_LLSTATUS] FOREIGN KEY ([RPLANDLORDLICENSESTATUSID]) REFERENCES [dbo].[RPLANDLORDLICENSESTATUS] ([RPLANDLORDLICENSESTATUSID]),
    CONSTRAINT [FK_HOLDTYPESETUP_RPSTATUS] FOREIGN KEY ([RPPROPERTYSTATUSID]) REFERENCES [dbo].[RPPROPERTYSTATUS] ([RPPROPERTYSTATUSID]),
    CONSTRAINT [FK_HoldTypeSetups_BLStatus] FOREIGN KEY ([BLSTATUS]) REFERENCES [dbo].[BLLICENSESTATUS] ([BLLICENSESTATUSID]),
    CONSTRAINT [FK_HoldTypeSetups_BStatus] FOREIGN KEY ([BLEXTSTATUSID]) REFERENCES [dbo].[BLEXTSTATUS] ([BLEXTSTATUSID]),
    CONSTRAINT [FK_HoldTypeSetups_HoldMod] FOREIGN KEY ([MODULEID]) REFERENCES [dbo].[HOLDMODULELIST] ([MODULEID]),
    CONSTRAINT [FK_HoldTypeSetups_HoldType] FOREIGN KEY ([HOLDTYPEID]) REFERENCES [dbo].[HOLDTYPE] ([HOLDTYPEID]),
    CONSTRAINT [FK_HoldTypeSetups_ILStatus] FOREIGN KEY ([ILSTATUS]) REFERENCES [dbo].[ILLICENSESTATUS] ([ILLICENSESTATUSID]),
    CONSTRAINT [FK_HoldTypeSetups_PLStatus] FOREIGN KEY ([PLANFLAGSTATUS]) REFERENCES [dbo].[PLPLANSTATUS] ([PLPLANSTATUSID]),
    CONSTRAINT [FK_HoldTypeSetups_PMStatus] FOREIGN KEY ([PERMITFLAGSTATUS]) REFERENCES [dbo].[PMPERMITSTATUS] ([PMPERMITSTATUSID]),
    CONSTRAINT [FK_HoldTypeSetups_PRStatus] FOREIGN KEY ([PROJECTFLAGSTATUS]) REFERENCES [dbo].[PRPROJECTSTATUS] ([PRPROJECTSTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [IX_HOLDTYPESETUPS_MODULEID_INC_NAME]
    ON [dbo].[HOLDTYPESETUPS]([MODULEID] ASC)
    INCLUDE([NAME]);


GO

CREATE TRIGGER [dbo].[TG_HOLDTYPESETUPS_DELETE]
    ON [dbo].[HOLDTYPESETUPS]
    AFTER DELETE
    AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [HISTORYSYSTEMSETUP]
    ([ID],
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
     [RECORDNAME])
    SELECT [deleted].[HOLDSETUPID],
           [deleted].[ROWVERSION],
           GETUTCDATE(),
           (SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
           'Hold Type Deleted',
           '',
           '',
           'Hold Type (' + ISNULL([deleted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           3,
           1,
           ISNULL([deleted].[NAME], '[none]')
    FROM [deleted]
END
GO

CREATE TRIGGER [dbo].[TG_HOLDTYPESETUPS_UPDATE]
    ON [dbo].[HOLDTYPESETUPS]
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    -- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of HOLDTYPESETUPS table with USERS table.
    IF EXISTS(SELECT *
              FROM inserted
                       LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
              WHERE inserted.LASTCHANGEDBY IS NOT NULL
                AND USERS.SUSERGUID IS NULL)
        BEGIN
            RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
            ROLLBACK;
            RETURN;
        END

    INSERT INTO [HISTORYSYSTEMSETUP]
    ([ID],
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
     [RECORDNAME])
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Name',
           ISNULL([deleted].[NAME], '[none]'),
           ISNULL([inserted].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ISNULL([deleted].[NAME], '') <> ISNULL([inserted].[NAME], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Hold Type',
           ISNULL([HOLDTYPE_DELETED].[HOLDTYPENAME], '[none]'),
           ISNULL([HOLDTYPE_INSERTED].[HOLDTYPENAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
             LEFT JOIN [HOLDTYPE] HOLDTYPE_DELETED WITH (NOLOCK)
                       ON [deleted].[HOLDTYPEID] = HOLDTYPE_DELETED.[HOLDTYPEID]
             LEFT JOIN [HOLDTYPE] HOLDTYPE_INSERTED WITH (NOLOCK)
                       ON [inserted].[HOLDTYPEID] = HOLDTYPE_INSERTED.[HOLDTYPEID]
    WHERE ISNULL([deleted].[HOLDTYPEID], '') <> ISNULL([inserted].[HOLDTYPEID], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Description',
           ISNULL([deleted].[DESCRIPTION], '[none]'),
           ISNULL([inserted].[DESCRIPTION], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Module',
           ISNULL([HOLDMODULELIST_DELETED].[MODULENAME], '[none]'),
           ISNULL([HOLDMODULELIST_INSERTED].[MODULENAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
             LEFT JOIN [HOLDMODULELIST] HOLDMODULELIST_DELETED WITH (NOLOCK)
                       ON [deleted].[MODULEID] = HOLDMODULELIST_DELETED.[MODULEID]
             LEFT JOIN [HOLDMODULELIST] HOLDMODULELIST_INSERTED WITH (NOLOCK)
                       ON [inserted].[MODULEID] = HOLDMODULELIST_INSERTED.[MODULEID]
    WHERE ISNULL([deleted].[MODULEID], '') <> ISNULL([inserted].[MODULEID], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Active Flag',
           CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ACTIVE] <> [inserted].[ACTIVE])
       OR ([deleted].[ACTIVE] IS NULL AND [inserted].[ACTIVE] IS NOT NULL)
       OR ([deleted].[ACTIVE] IS NOT NULL AND [inserted].[ACTIVE] IS NULL)
    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Allow Hold Override Flag',
           CASE [deleted].[ALLOWHOLDOVERRIDES] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ALLOWHOLDOVERRIDES] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ALLOWHOLDOVERRIDES] <> [inserted].[ALLOWHOLDOVERRIDES])
       OR ([deleted].[ALLOWHOLDOVERRIDES] IS NULL AND [inserted].[ALLOWHOLDOVERRIDES] IS NOT NULL)
       OR ([deleted].[ALLOWHOLDOVERRIDES] IS NOT NULL AND [inserted].[ALLOWHOLDOVERRIDES] IS NULL)
    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Display Active Hold Message On Bar Flag',
           CASE [deleted].[DISPLAYHOLDMESSAGEONBAR] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[DISPLAYHOLDMESSAGEONBAR] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[DISPLAYHOLDMESSAGEONBAR] <> [inserted].[DISPLAYHOLDMESSAGEONBAR])
       OR ([deleted].[DISPLAYHOLDMESSAGEONBAR] IS NULL AND [inserted].[DISPLAYHOLDMESSAGEONBAR] IS NOT NULL)
       OR ([deleted].[DISPLAYHOLDMESSAGEONBAR] IS NOT NULL AND [inserted].[DISPLAYHOLDMESSAGEONBAR] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Restrict Hold Release Flag',
           CASE [deleted].[RESTRICTHOLDRELEASE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[RESTRICTHOLDRELEASE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[RESTRICTHOLDRELEASE] <> [inserted].[RESTRICTHOLDRELEASE])
       OR ([deleted].[RESTRICTHOLDRELEASE] IS NULL AND [inserted].[RESTRICTHOLDRELEASE] IS NOT NULL)
       OR ([deleted].[RESTRICTHOLDRELEASE] IS NOT NULL AND [inserted].[RESTRICTHOLDRELEASE] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Alert Message',
           ISNULL([deleted].[ALERTMESSAGE], '[none]'),
           ISNULL([inserted].[ALERTMESSAGE], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ISNULL([deleted].[ALERTMESSAGE], '') <> ISNULL([inserted].[ALERTMESSAGE], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'New Permit Flag',
           CASE [deleted].[PERMITNEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PERMITNEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PERMITNEW] <> [inserted].[PERMITNEW])
       OR ([deleted].[PERMITNEW] IS NULL AND [inserted].[PERMITNEW] IS NOT NULL)
       OR ([deleted].[PERMITNEW] IS NOT NULL AND [inserted].[PERMITNEW] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Issue Existing Permit Flag',
           CASE [deleted].[PERMITISSUANCE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PERMITISSUANCE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PERMITISSUANCE] <> [inserted].[PERMITISSUANCE])
       OR ([deleted].[PERMITISSUANCE] IS NULL AND [inserted].[PERMITISSUANCE] IS NOT NULL)
       OR ([deleted].[PERMITISSUANCE] IS NOT NULL AND [inserted].[PERMITISSUANCE] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Permit Inspection Flag',
           CASE [deleted].[PERMITINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PERMITINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PERMITINSPECTION] <> [inserted].[PERMITINSPECTION])
       OR ([deleted].[PERMITINSPECTION] IS NULL AND [inserted].[PERMITINSPECTION] IS NOT NULL)
       OR ([deleted].[PERMITINSPECTION] IS NOT NULL AND [inserted].[PERMITINSPECTION] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Permit Status to',
           ISNULL([DELETED_PMPERMITSTATUS].[NAME], '[none]'),
           ISNULL([INSERTED_PMPERMITSTATUS].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
			 LEFT JOIN [dbo].[PMPERMITSTATUS] AS [INSERTED_PMPERMITSTATUS] WITH (NOLOCK) ON [inserted].[PERMITFLAGSTATUS]= [INSERTED_PMPERMITSTATUS].[PMPERMITSTATUSID]
			 LEFT JOIN [dbo].[PMPERMITSTATUS] AS [DELETED_PMPERMITSTATUS] WITH (NOLOCK) ON [deleted].[PERMITFLAGSTATUS]= [DELETED_PMPERMITSTATUS] .[PMPERMITSTATUSID]
    WHERE ISNULL([deleted].[PERMITFLAGSTATUS], '') <> ISNULL([inserted].[PERMITFLAGSTATUS], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'New Plan Flag',
           CASE [deleted].[PLANNEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PLANNEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PLANNEW] <> [inserted].[PLANNEW])
       OR ([deleted].[PLANNEW] IS NULL AND [inserted].[PLANNEW] IS NOT NULL)
       OR ([deleted].[PLANNEW] IS NOT NULL AND [inserted].[PLANNEW] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Complete Existing Plan Flag',
           CASE [deleted].[PLANCOMPLETE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PLANCOMPLETE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PLANCOMPLETE] <> [inserted].[PLANCOMPLETE])
       OR ([deleted].[PLANCOMPLETE] IS NULL AND [inserted].[PLANCOMPLETE] IS NOT NULL)
       OR ([deleted].[PLANCOMPLETE] IS NOT NULL AND [inserted].[PLANCOMPLETE] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Plan Workflow Submittals & Reviews Flag',
           CASE [deleted].[PLANWFSUBREVIVIEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PLANWFSUBREVIVIEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PLANWFSUBREVIVIEW] <> [inserted].[PLANWFSUBREVIVIEW])
       OR ([deleted].[PLANWFSUBREVIVIEW] IS NULL AND [inserted].[PLANWFSUBREVIVIEW] IS NOT NULL)
       OR ([deleted].[PLANWFSUBREVIVIEW] IS NOT NULL AND [inserted].[PLANWFSUBREVIVIEW] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Plan Inspections Flag',
           CASE [deleted].[PLANINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PLANINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PLANINSPECTION] <> [inserted].[PLANINSPECTION])
       OR ([deleted].[PLANINSPECTION] IS NULL AND [inserted].[PLANINSPECTION] IS NOT NULL)
       OR ([deleted].[PLANINSPECTION] IS NOT NULL AND [inserted].[PLANINSPECTION] IS NULL)
    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Plan Statuses to',
           ISNULL([DELETED_PLPLANSTATUS].[NAME], '[none]'),
           ISNULL([INSERTED_PLPLANSTATUS].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
			 LEFT JOIN [dbo].[PLPLANSTATUS] AS [INSERTED_PLPLANSTATUS] WITH (NOLOCK) ON [inserted].[PLANFLAGSTATUS]= [INSERTED_PLPLANSTATUS].[PLPLANSTATUSID]
			 LEFT JOIN [dbo].[PLPLANSTATUS] AS [DELETED_PLPLANSTATUS] WITH (NOLOCK) ON [deleted].[PLANFLAGSTATUS]= [DELETED_PLPLANSTATUS].[PLPLANSTATUSID]
    WHERE ISNULL([deleted].[PLANFLAGSTATUS], '') <> ISNULL([inserted].[PLANFLAGSTATUS], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'New Child Projects Flag',
           CASE [deleted].[PROJECTNEWCHILD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PROJECTNEWCHILD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PROJECTNEWCHILD] <> [inserted].[PROJECTNEWCHILD])
       OR ([deleted].[PROJECTNEWCHILD] IS NULL AND [inserted].[PROJECTNEWCHILD] IS NOT NULL)
       OR ([deleted].[PROJECTNEWCHILD] IS NOT NULL AND [inserted].[PROJECTNEWCHILD] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Complete Projects Flag',
           CASE [deleted].[PROJECTCOMPLETE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PROJECTCOMPLETE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PROJECTCOMPLETE] <> [inserted].[PROJECTCOMPLETE])
       OR ([deleted].[PROJECTCOMPLETE] IS NULL AND [inserted].[PROJECTCOMPLETE] IS NOT NULL)
       OR ([deleted].[PROJECTCOMPLETE] IS NOT NULL AND [inserted].[PROJECTCOMPLETE] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Project Inspections Flag',
           CASE [deleted].[PROJECTINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PROJECTINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PROJECTINSPECTION] <> [inserted].[PROJECTINSPECTION])
       OR ([deleted].[PROJECTINSPECTION] IS NULL AND [inserted].[PROJECTINSPECTION] IS NOT NULL)
       OR ([deleted].[PROJECTINSPECTION] IS NOT NULL AND [inserted].[PROJECTINSPECTION] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Extend Hold to Child Projects Flag',
           CASE [deleted].[PROJECTEXTENDHOLDTOCHILD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PROJECTEXTENDHOLDTOCHILD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PROJECTEXTENDHOLDTOCHILD] <> [inserted].[PROJECTEXTENDHOLDTOCHILD])
       OR ([deleted].[PROJECTEXTENDHOLDTOCHILD] IS NULL AND [inserted].[PROJECTEXTENDHOLDTOCHILD] IS NOT NULL)
       OR ([deleted].[PROJECTEXTENDHOLDTOCHILD] IS NOT NULL AND [inserted].[PROJECTEXTENDHOLDTOCHILD] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Project Statuses To',
           ISNULL([DELETED_PRPROJECTSTATUS].[NAME], '[none]'),
           ISNULL([INSERTED_PRPROJECTSTATUS].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
			 LEFT JOIN [dbo].[PRPROJECTSTATUS] AS [INSERTED_PRPROJECTSTATUS] WITH (NOLOCK) ON [inserted].[PROJECTFLAGSTATUS]= [INSERTED_PRPROJECTSTATUS].[PRPROJECTSTATUSID]
			 LEFT JOIN [dbo].[PRPROJECTSTATUS] AS [DELETED_PRPROJECTSTATUS] WITH (NOLOCK) ON [deleted].[PROJECTFLAGSTATUS]= [DELETED_PRPROJECTSTATUS].[PRPROJECTSTATUSID]
    WHERE ISNULL([deleted].[PROJECTFLAGSTATUS], '') <> ISNULL([inserted].[PROJECTFLAGSTATUS], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Credit Card Payments Flag',
           CASE [deleted].[ENTCREDITCARDPAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ENTCREDITCARDPAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ENTCREDITCARDPAY] <> [inserted].[ENTCREDITCARDPAY])
       OR ([deleted].[ENTCREDITCARDPAY] IS NULL AND [inserted].[ENTCREDITCARDPAY] IS NOT NULL)
       OR ([deleted].[ENTCREDITCARDPAY] IS NOT NULL AND [inserted].[ENTCREDITCARDPAY] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Check Payments Flag',
           CASE [deleted].[ENTCHECKPAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ENTCHECKPAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ENTCHECKPAY] <> [inserted].[ENTCHECKPAY])
       OR ([deleted].[ENTCHECKPAY] IS NULL AND [inserted].[ENTCHECKPAY] IS NOT NULL)
       OR ([deleted].[ENTCHECKPAY] IS NOT NULL AND [inserted].[ENTCHECKPAY] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Online Permit Applications Flag',
           CASE [deleted].[ENTONLINEPERMITAPPLICANT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ENTONLINEPERMITAPPLICANT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ENTONLINEPERMITAPPLICANT] <> [inserted].[ENTONLINEPERMITAPPLICANT])
       OR ([deleted].[ENTONLINEPERMITAPPLICANT] IS NULL AND [inserted].[ENTONLINEPERMITAPPLICANT] IS NOT NULL)
       OR ([deleted].[ENTONLINEPERMITAPPLICANT] IS NOT NULL AND [inserted].[ENTONLINEPERMITAPPLICANT] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Online Plan Applications Flag',
           CASE [deleted].[ENTONLINEPLANAPPLICANT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ENTONLINEPLANAPPLICANT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ENTONLINEPLANAPPLICANT] <> [inserted].[ENTONLINEPLANAPPLICANT])
       OR ([deleted].[ENTONLINEPLANAPPLICANT] IS NULL AND [inserted].[ENTONLINEPLANAPPLICANT] IS NOT NULL)
       OR ([deleted].[ENTONLINEPLANAPPLICANT] IS NOT NULL AND [inserted].[ENTONLINEPLANAPPLICANT] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Online Inspection Requests Flag',
           CASE [deleted].[ENTONLINEINSPECTIONREQUEST] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ENTONLINEINSPECTIONREQUEST] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ENTONLINEINSPECTIONREQUEST] <> [inserted].[ENTONLINEINSPECTIONREQUEST])
       OR ([deleted].[ENTONLINEINSPECTIONREQUEST] IS NULL AND [inserted].[ENTONLINEINSPECTIONREQUEST] IS NOT NULL)
       OR ([deleted].[ENTONLINEINSPECTIONREQUEST] IS NOT NULL AND [inserted].[ENTONLINEINSPECTIONREQUEST] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'New Business Flag',
           CASE [deleted].[ENTBUSINESSLICRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ENTBUSINESSLICRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ENTBUSINESSLICRENEWAL] <> [inserted].[ENTBUSINESSLICRENEWAL])
       OR ([deleted].[ENTBUSINESSLICRENEWAL] IS NULL AND [inserted].[ENTBUSINESSLICRENEWAL] IS NOT NULL)
       OR ([deleted].[ENTBUSINESSLICRENEWAL] IS NOT NULL AND [inserted].[ENTBUSINESSLICRENEWAL] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'New Proffessional License Flag',
           CASE [deleted].[ENTPROLICRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ENTPROLICRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ENTPROLICRENEWAL] <> [inserted].[ENTPROLICRENEWAL])
       OR ([deleted].[ENTPROLICRENEWAL] IS NULL AND [inserted].[ENTPROLICRENEWAL] IS NOT NULL)
       OR ([deleted].[ENTPROLICRENEWAL] IS NOT NULL AND [inserted].[ENTPROLICRENEWAL] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Final Existing Permit Flag',
           CASE [deleted].[PERMITFINALING] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PERMITFINALING] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PERMITFINALING] <> [inserted].[PERMITFINALING])
       OR ([deleted].[PERMITFINALING] IS NULL AND [inserted].[PERMITFINALING] IS NOT NULL)
       OR ([deleted].[PERMITFINALING] IS NOT NULL AND [inserted].[PERMITFINALING] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Enforce Effective Start End Date Flag',
           CASE [deleted].[PARCELENFORESTARTENDDT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PARCELENFORESTARTENDDT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PARCELENFORESTARTENDDT] <> [inserted].[PARCELENFORESTARTENDDT])
       OR ([deleted].[PARCELENFORESTARTENDDT] IS NULL AND [inserted].[PARCELENFORESTARTENDDT] IS NOT NULL)
       OR ([deleted].[PARCELENFORESTARTENDDT] IS NOT NULL AND [inserted].[PARCELENFORESTARTENDDT] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Enforce Main Parcel Only Flag',
           CASE [deleted].[PARCELENFORCEMAINPARCELONLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PARCELENFORCEMAINPARCELONLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PARCELENFORCEMAINPARCELONLY] <> [inserted].[PARCELENFORCEMAINPARCELONLY])
       OR ([deleted].[PARCELENFORCEMAINPARCELONLY] IS NULL AND [inserted].[PARCELENFORCEMAINPARCELONLY] IS NOT NULL)
       OR ([deleted].[PARCELENFORCEMAINPARCELONLY] IS NOT NULL AND [inserted].[PARCELENFORCEMAINPARCELONLY] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Parcel Enforce Permit Flag',
           CASE [deleted].[PARCELENFORCEPERM] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PARCELENFORCEPERM] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PARCELENFORCEPERM] <> [inserted].[PARCELENFORCEPERM])
       OR ([deleted].[PARCELENFORCEPERM] IS NULL AND [inserted].[PARCELENFORCEPERM] IS NOT NULL)
       OR ([deleted].[PARCELENFORCEPERM] IS NOT NULL AND [inserted].[PARCELENFORCEPERM] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Parcel Enforce Plan Flag',
           CASE [deleted].[PARCELENFORCEPLAN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PARCELENFORCEPLAN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PARCELENFORCEPLAN] <> [inserted].[PARCELENFORCEPLAN])
       OR ([deleted].[PARCELENFORCEPLAN] IS NULL AND [inserted].[PARCELENFORCEPLAN] IS NOT NULL)
       OR ([deleted].[PARCELENFORCEPLAN] IS NOT NULL AND [inserted].[PARCELENFORCEPLAN] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Parcel Enforce Project Flag',
           CASE [deleted].[PARCELENFORCEPROJECT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PARCELENFORCEPROJECT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PARCELENFORCEPROJECT] <> [inserted].[PARCELENFORCEPROJECT])
       OR ([deleted].[PARCELENFORCEPROJECT] IS NULL AND [inserted].[PARCELENFORCEPROJECT] IS NOT NULL)
       OR ([deleted].[PARCELENFORCEPROJECT] IS NOT NULL AND [inserted].[PARCELENFORCEPROJECT] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'New License Flag',
           CASE [deleted].[BNEWLICENSE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[BNEWLICENSE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[BNEWLICENSE] <> [inserted].[BNEWLICENSE])
       OR ([deleted].[BNEWLICENSE] IS NULL AND [inserted].[BNEWLICENSE] IS NOT NULL)
       OR ([deleted].[BNEWLICENSE] IS NOT NULL AND [inserted].[BNEWLICENSE] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Business Control Renew License Flag',
           CASE [deleted].[BRENEWLICENSE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[BRENEWLICENSE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[BRENEWLICENSE] <> [inserted].[BRENEWLICENSE])
       OR ([deleted].[BRENEWLICENSE] IS NULL AND [inserted].[BRENEWLICENSE] IS NOT NULL)
       OR ([deleted].[BRENEWLICENSE] IS NOT NULL AND [inserted].[BRENEWLICENSE] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Business Inspection Flag',
           CASE [deleted].[BUSINESSINSP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[BUSINESSINSP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[BUSINESSINSP] <> [inserted].[BUSINESSINSP])
       OR ([deleted].[BUSINESSINSP] IS NULL AND [inserted].[BUSINESSINSP] IS NOT NULL)
       OR ([deleted].[BUSINESSINSP] IS NOT NULL AND [inserted].[BUSINESSINSP] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Business Status to',
           ISNULL([BLEXTSTATUS_DELETED].[NAME], '[none]'),
           ISNULL([BLEXTSTATUS_INSERTED].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
             LEFT JOIN [BLEXTSTATUS] BLEXTSTATUS_DELETED WITH (NOLOCK)
                       ON [deleted].[BLEXTSTATUSID] = BLEXTSTATUS_DELETED.[BLEXTSTATUSID]
             LEFT JOIN [BLEXTSTATUS] BLEXTSTATUS_INSERTED WITH (NOLOCK)
                       ON [inserted].[BLEXTSTATUSID] = BLEXTSTATUS_INSERTED.[BLEXTSTATUSID]
    WHERE ISNULL([deleted].[BLEXTSTATUSID], '') <> ISNULL([inserted].[BLEXTSTATUSID], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Business License Renew License Flag',
           CASE [deleted].[BLRENEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[BLRENEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[BLRENEW] <> [inserted].[BLRENEW])
       OR ([deleted].[BLRENEW] IS NULL AND [inserted].[BLRENEW] IS NOT NULL)
       OR ([deleted].[BLRENEW] IS NOT NULL AND [inserted].[BLRENEW] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Business License Workflow Management Flag',
           CASE [deleted].[BLWF] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[BLWF] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[BLWF] <> [inserted].[BLWF])
       OR ([deleted].[BLWF] IS NULL AND [inserted].[BLWF] IS NOT NULL)
       OR ([deleted].[BLWF] IS NOT NULL AND [inserted].[BLWF] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Business License Pull Permits Flag',
           CASE [deleted].[BLPULLPERMIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[BLPULLPERMIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[BLPULLPERMIT] <> [inserted].[BLPULLPERMIT])
       OR ([deleted].[BLPULLPERMIT] IS NULL AND [inserted].[BLPULLPERMIT] IS NOT NULL)
       OR ([deleted].[BLPULLPERMIT] IS NOT NULL AND [inserted].[BLPULLPERMIT] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Business License Pull Plans Flag',
           CASE [deleted].[BLPULLPLAN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[BLPULLPLAN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[BLPULLPLAN] <> [inserted].[BLPULLPLAN])
       OR ([deleted].[BLPULLPLAN] IS NULL AND [inserted].[BLPULLPLAN] IS NOT NULL)
       OR ([deleted].[BLPULLPLAN] IS NOT NULL AND [inserted].[BLPULLPLAN] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Business License Status to',
           ISNULL([BLLICENSESTATUS_DELETED].[NAME], '[none]'),
           ISNULL([BLLICENSESTATUS_INSERTED].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
             LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_DELETED WITH (NOLOCK)
                       ON [deleted].[BLSTATUS] = BLLICENSESTATUS_DELETED.[BLLICENSESTATUSID]
             LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_INSERTED WITH (NOLOCK)
                       ON [inserted].[BLSTATUS] = BLLICENSESTATUS_INSERTED.[BLLICENSESTATUSID]
    WHERE ISNULL([deleted].[BLSTATUS], '') <> ISNULL([inserted].[BLSTATUS], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Renew License Flag',
           CASE [deleted].[PLRENEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PLRENEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PLRENEW] <> [inserted].[PLRENEW])
       OR ([deleted].[PLRENEW] IS NULL AND [inserted].[PLRENEW] IS NOT NULL)
       OR ([deleted].[PLRENEW] IS NOT NULL AND [inserted].[PLRENEW] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Professional License Workflow Management Flag',
           CASE [deleted].[ILWF] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ILWF] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ILWF] <> [inserted].[ILWF])
       OR ([deleted].[ILWF] IS NULL AND [inserted].[ILWF] IS NOT NULL)
       OR ([deleted].[ILWF] IS NOT NULL AND [inserted].[ILWF] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Pull Permits Flag',
           CASE [deleted].[ILPULLPERMIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ILPULLPERMIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ILPULLPERMIT] <> [inserted].[ILPULLPERMIT])
       OR ([deleted].[ILPULLPERMIT] IS NULL AND [inserted].[ILPULLPERMIT] IS NOT NULL)
       OR ([deleted].[ILPULLPERMIT] IS NOT NULL AND [inserted].[ILPULLPERMIT] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Pull Plans Flag',
           CASE [deleted].[ILPULLPLAN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ILPULLPLAN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ILPULLPLAN] <> [inserted].[ILPULLPLAN])
       OR ([deleted].[ILPULLPLAN] IS NULL AND [inserted].[ILPULLPLAN] IS NOT NULL)
       OR ([deleted].[ILPULLPLAN] IS NOT NULL AND [inserted].[ILPULLPLAN] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Pull Business License Flag',
           CASE [deleted].[ILPULLBL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ILPULLBL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ILPULLBL] <> [inserted].[ILPULLBL])
       OR ([deleted].[ILPULLBL] IS NULL AND [inserted].[ILPULLBL] IS NOT NULL)
       OR ([deleted].[ILPULLBL] IS NOT NULL AND [inserted].[ILPULLBL] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Professional License Statuses to',
           ISNULL([ILLICENSESTATUS_DELETED].[NAME], '[none]'),
           ISNULL([ILLICENSESTATUS_INSERTED].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
             LEFT JOIN [ILLICENSESTATUS] ILLICENSESTATUS_DELETED WITH (NOLOCK)
                       ON [deleted].[ILSTATUS] = ILLICENSESTATUS_DELETED.[ILLICENSESTATUSID]
             LEFT JOIN [ILLICENSESTATUS] ILLICENSESTATUS_INSERTED WITH (NOLOCK)
                       ON [inserted].[ILSTATUS] = ILLICENSESTATUS_INSERTED.[ILLICENSESTATUSID]
    WHERE ISNULL([deleted].[ILSTATUS], '') <> ISNULL([inserted].[ILSTATUS], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Landlord License Status to',
           ISNULL([RPLANDLORDLICENSESTATUS_DELETED].[NAME], '[none]'),
           ISNULL([RPLANDLORDLICENSESTATUS_INSERTED].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
             LEFT JOIN [RPLANDLORDLICENSESTATUS] RPLANDLORDLICENSESTATUS_DELETED WITH (NOLOCK)
                       ON [deleted].[RPLANDLORDLICENSESTATUSID] =
                          RPLANDLORDLICENSESTATUS_DELETED.[RPLANDLORDLICENSESTATUSID]
             LEFT JOIN [RPLANDLORDLICENSESTATUS] RPLANDLORDLICENSESTATUS_INSERTED WITH (NOLOCK)
                       ON [inserted].[RPLANDLORDLICENSESTATUSID] =
                          RPLANDLORDLICENSESTATUS_INSERTED.[RPLANDLORDLICENSESTATUSID]
    WHERE ISNULL([deleted].[RPLANDLORDLICENSESTATUSID], '') <> ISNULL([inserted].[RPLANDLORDLICENSESTATUSID], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'New Rental Property Flag',
           CASE [deleted].[ALLOWNEWRENTALPROPERTY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ALLOWNEWRENTALPROPERTY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ALLOWNEWRENTALPROPERTY] <> [inserted].[ALLOWNEWRENTALPROPERTY])
       OR ([deleted].[ALLOWNEWRENTALPROPERTY] IS NULL AND [inserted].[ALLOWNEWRENTALPROPERTY] IS NOT NULL)
       OR ([deleted].[ALLOWNEWRENTALPROPERTY] IS NOT NULL AND [inserted].[ALLOWNEWRENTALPROPERTY] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Set Rental Property Statuses to',
           ISNULL([RPPROPERTYSTATUS_DELETED].[NAME], '[none]'),
           ISNULL([RPPROPERTYSTATUS_INSERTED].[NAME], '[none]'),
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
             LEFT JOIN [RPPROPERTYSTATUS] RPPROPERTYSTATUS_DELETED WITH (NOLOCK)
                       ON [deleted].[RPPROPERTYSTATUSID] =
                          RPPROPERTYSTATUS_DELETED.[RPPROPERTYSTATUSID]
             LEFT JOIN [RPPROPERTYSTATUS] RPPROPERTYSTATUS_INSERTED WITH (NOLOCK)
                       ON [inserted].[RPPROPERTYSTATUSID] =
                          RPPROPERTYSTATUS_INSERTED.[RPPROPERTYSTATUSID]
    WHERE ISNULL([deleted].[RPPROPERTYSTATUSID], '') <> ISNULL([inserted].[RPPROPERTYSTATUSID], '')

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Rental Property Inspections Flag',
           CASE [deleted].[ALLOWRENTALPROPERTYINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[ALLOWRENTALPROPERTYINSPECTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[ALLOWRENTALPROPERTYINSPECTION] <> [inserted].[ALLOWRENTALPROPERTYINSPECTION])
       OR ([deleted].[ALLOWRENTALPROPERTYINSPECTION] IS NULL AND [inserted].[ALLOWRENTALPROPERTYINSPECTION] IS NOT NULL)
       OR ([deleted].[ALLOWRENTALPROPERTYINSPECTION] IS NOT NULL AND [inserted].[ALLOWRENTALPROPERTYINSPECTION] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Restrict Permit Renewal Flag',
           CASE [deleted].[PERMITRENEWALRESTRICTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PERMITRENEWALRESTRICTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PERMITRENEWALRESTRICTION] <> [inserted].[PERMITRENEWALRESTRICTION])
       OR ([deleted].[PERMITRENEWALRESTRICTION] IS NULL AND [inserted].[PERMITRENEWALRESTRICTION] IS NOT NULL)
       OR ([deleted].[PERMITRENEWALRESTRICTION] IS NOT NULL AND [inserted].[PERMITRENEWALRESTRICTION] IS NULL)

    UNION ALL
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Permit Workflow Submittals & Reviews Flag',
           CASE [deleted].[PERMITWFSUBREVIEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           CASE [inserted].[PERMITWFSUBREVIEW] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           2,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [deleted]
             JOIN [inserted] ON [deleted].[HOLDSETUPID] = [inserted].[HOLDSETUPID]
    WHERE ([deleted].[PERMITWFSUBREVIEW] <> [inserted].[PERMITWFSUBREVIEW])
       OR ([deleted].[PERMITWFSUBREVIEW] IS NULL AND [inserted].[PERMITWFSUBREVIEW] IS NOT NULL)
       OR ([deleted].[PERMITWFSUBREVIEW] IS NOT NULL AND [inserted].[PERMITWFSUBREVIEW] IS NULL)
END
GO

CREATE TRIGGER [dbo].[TG_HOLDTYPESETUPS_INSERT]
    ON [dbo].[HOLDTYPESETUPS]
    FOR INSERT
    AS
BEGIN
    SET NOCOUNT ON;

    -- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of HOLDTYPESETUPS table with USERS table
    IF EXISTS(SELECT *
              FROM inserted
                       LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
              WHERE inserted.LASTCHANGEDBY IS NOT NULL
                AND USERS.SUSERGUID IS NULL)
        BEGIN
            RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
            ROLLBACK;
            RETURN;
        END

    INSERT INTO [HISTORYSYSTEMSETUP]
    ([ID],
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
     [RECORDNAME])
    SELECT [inserted].[HOLDSETUPID],
           [inserted].[ROWVERSION],
           GETUTCDATE(),
           [inserted].[LASTCHANGEDBY],
           'Hold Type Added',
           '',
           '',
           'Hold Type (' + ISNULL([inserted].[NAME], '[none]') + ')',
           'AB739006-4ADE-45D1-9393-6435B751FD10',
           1,
           1,
           ISNULL([inserted].[NAME], '[none]')
    FROM [inserted]
END