CREATE TABLE [dbo].[ATTACHMENTGROUP] (
    [ATTACHMENTGROUPID]         CHAR (36)      NOT NULL,
    [NAME]                      NVARCHAR (100) NOT NULL,
    [DESCRIPTION]               NVARCHAR (250) NULL,
    [AVAILINPERMIT]             BIT            CONSTRAINT [DF_AttachmentGroup_AvailInPermit] DEFAULT ((0)) NOT NULL,
    [AVAILINPLAN]               BIT            CONSTRAINT [DF_AttachmentGroup_AvailInPlan] DEFAULT ((0)) NOT NULL,
    [AVAILINCODE]               BIT            CONSTRAINT [DF_AttachmentGroup_AvailInCode] DEFAULT ((0)) NOT NULL,
    [AVAILINCRM]                BIT            CONSTRAINT [DF_AttachmentGroup_AvailInCRM] DEFAULT ((0)) NOT NULL,
    [AVAILINPROJECT]            BIT            CONSTRAINT [DF_AttachmentGroup_AvailInProject] DEFAULT ((0)) NOT NULL,
    [AVAILINWORKORDER]          BIT            CONSTRAINT [DF_AttachmentGroup_AvailInWorkOrder] DEFAULT ((0)) NOT NULL,
    [AVAILINASSET]              BIT            CONSTRAINT [DF_AttachmentGroup_AvailInAsset] DEFAULT ((0)) NOT NULL,
    [AVAILININVOICE]            BIT            CONSTRAINT [DF_AttachmentGroup_AvailInInvoice] DEFAULT ((0)) NOT NULL,
    [AVAILINPAYMENT]            BIT            CONSTRAINT [DF_AttachmentGroup_AvailInPayment] DEFAULT ((0)) NOT NULL,
    [AVAILININSPECTION]         BIT            CONSTRAINT [DF_AttachmentGroup_AvailInInspection] DEFAULT ((0)) NOT NULL,
    [AVAILINCONTACT]            BIT            CONSTRAINT [DF_AttachmentGroup_AvailInContact] DEFAULT ((0)) NOT NULL,
    [AVAILINBUSINESSLICENSE]    BIT            CONSTRAINT [DF_AttachmentGroup_AvailInBusinessLicense] DEFAULT ((0)) NOT NULL,
    [AVAILINBUSINESS]           BIT            CONSTRAINT [DF_AttachmentGroup_AvailInBusiness] DEFAULT ((0)) NOT NULL,
    [AVAILINPROLICENSE]         BIT            CONSTRAINT [DF_AttachmentGroup_AvailInProLicense] DEFAULT ((0)) NOT NULL,
    [AVAILINEXAMSITTING]        BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINEXAMREQUEST]        BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINEXAMLANDLORD]       BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINEXAMRENTALPROPERTY] BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINEXAMTAXREMITTANCE]  BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINCAP]                BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINCAPCONTACTS]        BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINOBJEC]              BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINIMPACTCASE]         BIT            DEFAULT ((0)) NOT NULL,
    [AVAILINFIREOCCUPANCY]      BIT            DEFAULT ((0)) NOT NULL,
    [RECORDEDFILE]              BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]             CHAR (36)      NULL,
    [LASTCHANGEDON]             DATETIME       CONSTRAINT [DF_AttachmentGroup_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                INT            CONSTRAINT [DF_AttachmentGroup_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_AttachmentGroup] PRIMARY KEY CLUSTERED ([ATTACHMENTGROUPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ATTACHMENTGROUP_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [AttachmentGroup_IX_QUERY]
    ON [dbo].[ATTACHMENTGROUP]([ATTACHMENTGROUPID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_ATTACHMENTGROUP_UPDATE] ON  [dbo].[ATTACHMENTGROUP]
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
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Permit Flag',
			CASE WHEN [deleted].[AVAILINPERMIT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINPERMIT] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINPERMIT] <> [inserted].[AVAILINPERMIT]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Plan Flag',
			CASE WHEN [deleted].[AVAILINPLAN] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINPLAN] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINPLAN] <> [inserted].[AVAILINPLAN]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Code Flag',
			CASE WHEN [deleted].[AVAILINCODE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINCODE] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINCODE] <> [inserted].[AVAILINCODE]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available in Request Management Flag',
			CASE WHEN [deleted].[AVAILINCRM] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINCRM] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINCRM] <> [inserted].[AVAILINCRM]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Project Flag',
			CASE WHEN [deleted].[AVAILINPROJECT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINPROJECT] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINPROJECT] <> [inserted].[AVAILINPROJECT]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Work Order Flag',
			CASE WHEN [deleted].[AVAILINWORKORDER] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINWORKORDER] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINWORKORDER] <> [inserted].[AVAILINWORKORDER]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Asset Flag',
			CASE WHEN [deleted].[AVAILINASSET] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINASSET] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINASSET] <> [inserted].[AVAILINASSET]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Invoice Flag',
			CASE WHEN [deleted].[AVAILININVOICE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILININVOICE] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILININVOICE] <> [inserted].[AVAILININVOICE]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Payment Flag',
			CASE WHEN [deleted].[AVAILINPAYMENT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINPAYMENT] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINPAYMENT] <> [inserted].[AVAILINPAYMENT]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Inspection Flag',
			CASE WHEN [deleted].[AVAILININSPECTION] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILININSPECTION] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILININSPECTION] <> [inserted].[AVAILININSPECTION]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Contact Flag',
			CASE WHEN [deleted].[AVAILINCONTACT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINCONTACT] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINCONTACT] <> [inserted].[AVAILINCONTACT]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Business License Flag',
			CASE WHEN [deleted].[AVAILINBUSINESSLICENSE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINBUSINESSLICENSE] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINBUSINESSLICENSE] <> [inserted].[AVAILINBUSINESSLICENSE]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Business Flag',
			CASE WHEN [deleted].[AVAILINBUSINESS] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINBUSINESS] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINBUSINESS] <> [inserted].[AVAILINBUSINESS]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Professional License Flag',
			CASE WHEN [deleted].[AVAILINPROLICENSE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINPROLICENSE] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINPROLICENSE] <> [inserted].[AVAILINPROLICENSE]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Exam Sitting Flag',
			CASE WHEN [deleted].[AVAILINEXAMSITTING] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINEXAMSITTING] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINEXAMSITTING] <> [inserted].[AVAILINEXAMSITTING]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Exam Request Flag',
			CASE WHEN [deleted].[AVAILINEXAMREQUEST] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINEXAMREQUEST] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINEXAMREQUEST] <> [inserted].[AVAILINEXAMREQUEST]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Landlord License Flag',
			CASE WHEN [deleted].[AVAILINEXAMLANDLORD] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINEXAMLANDLORD] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINEXAMLANDLORD] <> [inserted].[AVAILINEXAMLANDLORD]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Rental Property Flag',
			CASE WHEN [deleted].[AVAILINEXAMRENTALPROPERTY] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINEXAMRENTALPROPERTY] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINEXAMRENTALPROPERTY] <> [inserted].[AVAILINEXAMRENTALPROPERTY]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Tax Remittance Account Flag',
			CASE WHEN [deleted].[AVAILINEXAMTAXREMITTANCE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINEXAMTAXREMITTANCE] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINEXAMTAXREMITTANCE] <> [inserted].[AVAILINEXAMTAXREMITTANCE]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In CAP Flag',
			CASE WHEN [deleted].[AVAILINCAP] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINCAP] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINCAP] <> [inserted].[AVAILINCAP]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Associated CAP Contacts Flag',
			CASE WHEN [deleted].[AVAILINCAPCONTACTS] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINCAPCONTACTS] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINCAPCONTACTS] <> [inserted].[AVAILINCAPCONTACTS]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Object Flag',
			CASE WHEN [deleted].[AVAILINOBJEC] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINOBJEC] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINOBJEC] <> [inserted].[AVAILINOBJEC]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Impact Case Flag',
			CASE WHEN [deleted].[AVAILINIMPACTCASE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINIMPACTCASE] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINIMPACTCASE] <> [inserted].[AVAILINIMPACTCASE]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Available In Fire Occupancy Flag',
			CASE WHEN [deleted].[AVAILINFIREOCCUPANCY] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AVAILINFIREOCCUPANCY] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[AVAILINFIREOCCUPANCY] <> [inserted].[AVAILINFIREOCCUPANCY]
	UNION ALL
	SELECT
			[inserted].[ATTACHMENTGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recorded File Flag',
			CASE WHEN [deleted].[RECORDEDFILE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[RECORDEDFILE] = 1 THEN 'Yes' ELSE 'No' END,
			'Attachment Group (' + [inserted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
	WHERE	[deleted].[RECORDEDFILE] <> [inserted].[RECORDEDFILE]
END
GO


CREATE TRIGGER [dbo].[TG_ATTACHMENTGROUP_INSERT] ON [dbo].[ATTACHMENTGROUP]
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
        [inserted].[ATTACHMENTGROUPID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Attachment Group Added',
        '',
        '',
        'Attachment Group (' + [inserted].[NAME] + ')',
		'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_ATTACHMENTGROUP_DELETE]  ON  [dbo].[ATTACHMENTGROUP]
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
			[deleted].[ATTACHMENTGROUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			 'Attachment Group Deleted',
			'',
			'',
			'Attachment Group (' + [deleted].[NAME] + ')',
			'3B6CC0E9-9146-4D92-88AB-C3D8415F12EA',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END