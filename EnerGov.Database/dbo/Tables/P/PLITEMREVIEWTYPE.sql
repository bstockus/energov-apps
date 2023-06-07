CREATE TABLE [dbo].[PLITEMREVIEWTYPE] (
    [PLITEMREVIEWTYPEID]           CHAR (36)      NOT NULL,
    [NAME]                         NVARCHAR (100) NOT NULL,
    [DESCRIPTION]                  NVARCHAR (MAX) NULL,
    [DEPARTMENTID]                 CHAR (36)      NULL,
    [PLITEMREVIEWSTATUSID]         CHAR (36)      NULL,
    [DAYSUNTILDUE]                 INT            CONSTRAINT [DF_PLItemReviewType_DaysUntilDue] DEFAULT ((0)) NOT NULL,
    [RESUMITALDAYSUNTILDUE]        INT            NULL,
    [INHERITSUBMITALDUE]           BIT            CONSTRAINT [DF_PLItemReviewType_InhSub] DEFAULT ((0)) NOT NULL,
    [GISZONEREVIEWITEMMAPPINGID]   CHAR (36)      NULL,
    [CODENAME]                     NVARCHAR (100) NULL,
    [CODEURL]                      NVARCHAR (250) NULL,
    [REASSIGNTOWHOCOMPLETEDREVIEW] BIT            DEFAULT ((0)) NOT NULL,
    [HIDERECOMMENDATIONS]          BIT            CONSTRAINT [DF_PLItemReviewType_HideRecommendations] DEFAULT ((0)) NOT NULL,
    [HIDECORRECTIONS]              BIT            CONSTRAINT [DF_PLItemReviewType_HideCorrections] DEFAULT ((0)) NOT NULL,
    [HIDECONDITIONS]               BIT            CONSTRAINT [DF_PLItemReviewType_HideConditions] DEFAULT ((0)) NOT NULL,
    [ASSIGNTOOBJECT]               INT            CONSTRAINT [DF_PLItemReviewType_ASSIGNTOOBJECT] DEFAULT ((1)) NOT NULL,
    [TEAMASSIGNEDTOID]             CHAR (36)      NULL,
    [LASTCHANGEDBY]                CHAR (36)      NULL,
    [LASTCHANGEDON]                DATETIME       CONSTRAINT [DF_PLITEMREVIEWTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                   INT            CONSTRAINT [DF_PLITEMREVIEWTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLItemReviewType] PRIMARY KEY CLUSTERED ([PLITEMREVIEWTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLITEMREVIEWTYPE_GISZONE] FOREIGN KEY ([GISZONEREVIEWITEMMAPPINGID]) REFERENCES [dbo].[GISZONEREVIEWITEMMAPPING] ([GISZONEREVIEWITEMMAPPINGID]),
    CONSTRAINT [FK_PLITEMREVIEWTYPE_TEAMASSIGNEDTO] FOREIGN KEY ([TEAMASSIGNEDTOID]) REFERENCES [dbo].[TEAM] ([TEAMID]),
    CONSTRAINT [FK_PLType_DefaultStatus] FOREIGN KEY ([PLITEMREVIEWSTATUSID]) REFERENCES [dbo].[PLITEMREVIEWSTATUS] ([PLITEMREVIEWSTATUSID]),
    CONSTRAINT [FK_PLType_Department] FOREIGN KEY ([DEPARTMENTID]) REFERENCES [dbo].[DEPARTMENT] ([DEPARTMENTID])
);


GO
CREATE NONCLUSTERED INDEX [PLITEMREVIEWTYPE_IX_QUERY]
    ON [dbo].[PLITEMREVIEWTYPE]([PLITEMREVIEWTYPEID] ASC, [NAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_PLITEMREVIEWTYPE_INSERT] ON [dbo].[PLITEMREVIEWTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLITEMREVIEWTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
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
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Item Review Type Added',
			'',
			'',
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO
CREATE TRIGGER [dbo].[TG_PLITEMREVIEWTYPE_UPDATE] ON [dbo].[PLITEMREVIEWTYPE]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLITEMREVIEWTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
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
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Code Name',
			ISNULL([deleted].[CODENAME],'[none]'),
			ISNULL([inserted].[CODENAME],'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	ISNULL([deleted].[CODENAME], '') <> ISNULL([inserted].[CODENAME], '')
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Code Url',
			ISNULL([deleted].[CODEURL],'[none]'),
			ISNULL([inserted].[CODEURL],'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	ISNULL([deleted].[CODEURL], '') <> ISNULL([inserted].[CODEURL], '')
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([PLITEMREVIEWSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([PLITEMREVIEWSTATUS_INSERTED].[NAME],'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]			
			LEFT JOIN [PLITEMREVIEWSTATUS] [PLITEMREVIEWSTATUS_INSERTED] WITH (NOLOCK) ON [PLITEMREVIEWSTATUS_INSERTED].[PLITEMREVIEWSTATUSID] = [inserted].[PLITEMREVIEWSTATUSID]
			LEFT JOIN [PLITEMREVIEWSTATUS] [PLITEMREVIEWSTATUS_DELETED] WITH (NOLOCK) ON [PLITEMREVIEWSTATUS_DELETED].[PLITEMREVIEWSTATUSID] = [deleted].[PLITEMREVIEWSTATUSID]
	WHERE	ISNULL([deleted].[PLITEMREVIEWSTATUSID], '') <> ISNULL([inserted].[PLITEMREVIEWSTATUSID], '')
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Department Name',
			ISNULL([DEPARTMENT_DELETED].[NAME],'[none]'),
			ISNULL([DEPARTMENT_INSERTED].[NAME],'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]			
			LEFT JOIN [DEPARTMENT] [DEPARTMENT_INSERTED] WITH (NOLOCK) ON [DEPARTMENT_INSERTED].[DEPARTMENTID] = [inserted].[DEPARTMENTID]
			LEFT JOIN [DEPARTMENT] [DEPARTMENT_DELETED] WITH (NOLOCK) ON [DEPARTMENT_DELETED].[DEPARTMENTID] = [deleted].[DEPARTMENTID]
	WHERE	ISNULL([deleted].[DEPARTMENTID], '') <> ISNULL([inserted].[DEPARTMENTID], '')	
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days Until Due',
			CONVERT(NVARCHAR(MAX),[deleted].[DAYSUNTILDUE]),
			CONVERT(NVARCHAR(MAX),[inserted].[DAYSUNTILDUE]),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[DAYSUNTILDUE] <> [inserted].[DAYSUNTILDUE]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Resubmit Days Until Due',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[RESUMITALDAYSUNTILDUE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[RESUMITALDAYSUNTILDUE]),'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	ISNULL([deleted].[RESUMITALDAYSUNTILDUE], '') <> ISNULL([inserted].[RESUMITALDAYSUNTILDUE], '')
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Inherit from Submittal''s Days Until Due Flag',
			CASE [deleted].[INHERITSUBMITALDUE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[INHERITSUBMITALDUE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[INHERITSUBMITALDUE] <> [inserted].[INHERITSUBMITALDUE]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GIS Zone Data Source',
			ISNULL([GISZONEREVIEWITEMMAPPING_DELETED].[SOURCENAME],'[none]'),
			ISNULL([GISZONEREVIEWITEMMAPPING_INSERTED].[SOURCENAME],'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
			LEFT JOIN [GISZONEREVIEWITEMMAPPING] [GISZONEREVIEWITEMMAPPING_INSERTED] WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING_INSERTED].[GISZONEREVIEWITEMMAPPINGID] = [inserted].[GISZONEREVIEWITEMMAPPINGID]
			LEFT JOIN [GISZONEREVIEWITEMMAPPING] [GISZONEREVIEWITEMMAPPING_DELETED] WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING_DELETED].[GISZONEREVIEWITEMMAPPINGID] = [deleted].[GISZONEREVIEWITEMMAPPINGID]
	WHERE	ISNULL([deleted].[GISZONEREVIEWITEMMAPPINGID], '') <> ISNULL([inserted].[GISZONEREVIEWITEMMAPPINGID], '')
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Reassign to User who Completed Review Flag',
			CASE [deleted].[REASSIGNTOWHOCOMPLETEDREVIEW] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[REASSIGNTOWHOCOMPLETEDREVIEW] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[REASSIGNTOWHOCOMPLETEDREVIEW] <> [inserted].[REASSIGNTOWHOCOMPLETEDREVIEW]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Hide Recommendations Flag',
			CASE [deleted].[HIDERECOMMENDATIONS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[HIDERECOMMENDATIONS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[HIDERECOMMENDATIONS] <> [inserted].[HIDERECOMMENDATIONS]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Hide Corrections Flag',
			CASE [deleted].[HIDECORRECTIONS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[HIDECORRECTIONS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[HIDECORRECTIONS] <> [inserted].[HIDECORRECTIONS]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Hide Conditions Flag',
			CASE [deleted].[HIDECONDITIONS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[HIDECONDITIONS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[HIDECONDITIONS] <> [inserted].[HIDECONDITIONS]
	
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Assign To',
			CASE [deleted].[ASSIGNTOOBJECT] WHEN 1 THEN 'User' ELSE 'Team' END,
			CASE [inserted].[ASSIGNTOOBJECT] WHEN 1 THEN 'User' ELSE 'Team' END,			
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]			
	WHERE	[deleted].[ASSIGNTOOBJECT] <> [inserted].[ASSIGNTOOBJECT]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Team Assigned To',
			ISNULL([TEAM_DELETED].[NAME],'[none]'),
			ISNULL([TEAM_INSERTED].[NAME],'[none]'),
			'Item Review Type (' + [inserted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]			
			LEFT JOIN [TEAM] [TEAM_INSERTED] WITH (NOLOCK) ON [TEAM_INSERTED].[TEAMID] = [inserted].[TEAMASSIGNEDTOID]
			LEFT JOIN [TEAM] [TEAM_DELETED] WITH (NOLOCK) ON [TEAM_DELETED].[TEAMID] = [deleted].[TEAMASSIGNEDTOID]
	WHERE	ISNULL([deleted].[TEAMASSIGNEDTOID], '') <> ISNULL([inserted].[TEAMASSIGNEDTOID], '')
END
GO
CREATE TRIGGER [dbo].[TG_PLITEMREVIEWTYPE_DELETE] ON [dbo].[PLITEMREVIEWTYPE]
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
			[deleted].[PLITEMREVIEWTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Item Review Type Deleted',
			'',
			'',
			'Item Review Type (' + [deleted].[NAME] + ')',
			'86195D62-AE88-4A8D-A015-6CCD233B4D64',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END