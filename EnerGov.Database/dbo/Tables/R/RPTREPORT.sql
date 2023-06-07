CREATE TABLE [dbo].[RPTREPORT] (
    [RPTREPORTID]                 CHAR (36)       NOT NULL,
    [RPTFRMTOBUSOBJMAPID]         CHAR (36)       NOT NULL,
    [REPORTNAME]                  NVARCHAR (255)  NULL,
    [FRIENDLYNAME]                NVARCHAR (255)  NULL,
    [SYSTEMREPORT]                BIT             NULL,
    [PROMPTINPUT]                 BIT             NULL,
    [IDENOBJPROPFRIENDLYNAME]     NVARCHAR (255)  NULL,
    [IDENTIFYOBJECTPROPERTYTOKEN] NVARCHAR (255)  NULL,
    [IDENTIFYOBJECTPROPERTYNAME]  NVARCHAR (255)  NULL,
    [IDENTIFYOBJECTPROPERTYVALUE] NVARCHAR (255)  NULL,
    [REPORTPREVIEWIMAGE]          VARBINARY (MAX) NULL,
    [MOBILEGOVREPORT]             BIT             DEFAULT ((0)) NULL,
    [ISSUBFOLDER]                 BIT             NULL,
    [RPTREPORTTYPEID]             INT             DEFAULT ((1)) NOT NULL,
    [REPORTVIRTUALPATH]           NVARCHAR (255)  NULL,
    [LASTCHANGEDBY]               CHAR (36)       NULL,
    [LASTCHANGEDON]               DATETIME        CONSTRAINT [DF_RPTREPORT_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                  INT             CONSTRAINT [DF_RPTREPORT_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RPTReport] PRIMARY KEY CLUSTERED ([RPTREPORTID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_RPTReport_RPTFormToBusinessObjectMapping] FOREIGN KEY ([RPTFRMTOBUSOBJMAPID]) REFERENCES [dbo].[RPTFORMTOBUSINESSOBJECTMAPPING] ([RPTFRMTOBUSOBJMAPID]),
    CONSTRAINT [FK_RPTREPORT_RPTREPORTTYPE] FOREIGN KEY ([RPTREPORTTYPEID]) REFERENCES [dbo].[RPTREPORTTYPE] ([RPTREPORTTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [RPTREPORT_IX_QUERY]
    ON [dbo].[RPTREPORT]([RPTREPORTID] ASC, [REPORTNAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_RPTREPORT_INSERT] ON [dbo].[RPTREPORT]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTREPORT table with USERS table.
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
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Added',
			'',
			'',
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			1,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[inserted]
END
GO

CREATE TRIGGER [dbo].[TG_RPTREPORT_UPDATE] ON [dbo].[RPTREPORT] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTREPORT table with USERS table.
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
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Select Form',
			ISNULL([RPTFORMTOBUSINESSOBJECTMAPPING_DELETED].[FORMNAME],'[none]'),
			ISNULL([RPTFORMTOBUSINESSOBJECTMAPPING_INSERTED].[FORMNAME],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
			INNER JOIN [RPTFORMTOBUSINESSOBJECTMAPPING] [RPTFORMTOBUSINESSOBJECTMAPPING_INSERTED] WITH (NOLOCK) ON [RPTFORMTOBUSINESSOBJECTMAPPING_INSERTED].[RPTFRMTOBUSOBJMAPID] = [inserted].[RPTFRMTOBUSOBJMAPID]
			INNER JOIN [RPTFORMTOBUSINESSOBJECTMAPPING] [RPTFORMTOBUSINESSOBJECTMAPPING_DELETED] WITH (NOLOCK) ON [RPTFORMTOBUSINESSOBJECTMAPPING_DELETED].[RPTFRMTOBUSOBJMAPID] = [deleted].[RPTFRMTOBUSOBJMAPID]
	WHERE	[deleted].[RPTFRMTOBUSOBJMAPID] <> [inserted].[RPTFRMTOBUSOBJMAPID]
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Name',
			ISNULL([deleted].[REPORTNAME],'[none]'),
			ISNULL([inserted].[REPORTNAME],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	ISNULL([deleted].[REPORTNAME], '') <> ISNULL([inserted].[REPORTNAME], '')
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Friendly Report Name',
			ISNULL([deleted].[FRIENDLYNAME],'[none]'),
			ISNULL([inserted].[FRIENDLYNAME],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	ISNULL([deleted].[FRIENDLYNAME], '') <> ISNULL([inserted].[FRIENDLYNAME], '')
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'System Report Flag',
			CASE [deleted].[SYSTEMREPORT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[SYSTEMREPORT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	([deleted].[SYSTEMREPORT] <> [inserted].[SYSTEMREPORT])
			OR ([deleted].[SYSTEMREPORT] IS NULL AND [inserted].[SYSTEMREPORT] <> NULL)
			OR ([deleted].[SYSTEMREPORT] <> NULL AND [inserted].[SYSTEMREPORT] IS NULL)
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prompt Input Flag',
			CASE [deleted].[PROMPTINPUT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[PROMPTINPUT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	([deleted].[PROMPTINPUT] <> [inserted].[PROMPTINPUT])
			OR ([deleted].[PROMPTINPUT] IS NULL AND [inserted].[PROMPTINPUT] <> NULL)
			OR ([deleted].[PROMPTINPUT] <> NULL AND [inserted].[PROMPTINPUT] IS NULL)
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Friendly Name',
			ISNULL([deleted].[IDENOBJPROPFRIENDLYNAME],'[none]'),
			ISNULL([inserted].[IDENOBJPROPFRIENDLYNAME],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	ISNULL([deleted].[IDENOBJPROPFRIENDLYNAME], '') <> ISNULL([inserted].[IDENOBJPROPFRIENDLYNAME], '')	
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Token',
			ISNULL([deleted].[IDENTIFYOBJECTPROPERTYTOKEN],'[none]'),
			ISNULL([inserted].[IDENTIFYOBJECTPROPERTYTOKEN],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	ISNULL([deleted].[IDENTIFYOBJECTPROPERTYTOKEN], '') <> ISNULL([inserted].[IDENTIFYOBJECTPROPERTYTOKEN], '')
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Identifying Property',
			ISNULL([deleted].[IDENTIFYOBJECTPROPERTYNAME],'[none]'),
			ISNULL([inserted].[IDENTIFYOBJECTPROPERTYNAME],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	ISNULL([deleted].[IDENTIFYOBJECTPROPERTYNAME], '') <> ISNULL([inserted].[IDENTIFYOBJECTPROPERTYNAME], '')
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Value',
			ISNULL([deleted].[IDENTIFYOBJECTPROPERTYVALUE],'[none]'),
			ISNULL([inserted].[IDENTIFYOBJECTPROPERTYVALUE],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	ISNULL([deleted].[IDENTIFYOBJECTPROPERTYVALUE], '') <> ISNULL([inserted].[IDENTIFYOBJECTPROPERTYVALUE], '')
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Set Image',
			CASE WHEN [deleted].[REPORTPREVIEWIMAGE] IS NULL THEN '[none]' ELSE 'Image' END,
			CASE WHEN [inserted].[REPORTPREVIEWIMAGE] IS NULL THEN '[none]' ELSE 'Image' END,
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	[deleted].[REPORTPREVIEWIMAGE] <> [inserted].[REPORTPREVIEWIMAGE] OR 
			([deleted].[REPORTPREVIEWIMAGE] IS NULL AND [inserted].[REPORTPREVIEWIMAGE] IS NOT NULL) OR
			([deleted].[REPORTPREVIEWIMAGE] IS NOT NULL AND [inserted].[REPORTPREVIEWIMAGE] IS NULL)
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'MobileGov Report Flag',
			CASE [deleted].[MOBILEGOVREPORT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[MOBILEGOVREPORT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	([deleted].[MOBILEGOVREPORT] <> [inserted].[MOBILEGOVREPORT])
			OR ([deleted].[MOBILEGOVREPORT] IS NULL AND [inserted].[MOBILEGOVREPORT] <> NULL)
			OR ([deleted].[MOBILEGOVREPORT] <> NULL AND [inserted].[MOBILEGOVREPORT] IS NULL)
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Add To Documents Subfolder Flag',
			CASE [deleted].[ISSUBFOLDER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ISSUBFOLDER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	([deleted].[ISSUBFOLDER] <> [inserted].[ISSUBFOLDER])
			OR ([deleted].[ISSUBFOLDER] IS NULL AND [inserted].[ISSUBFOLDER] <> NULL)
			OR ([deleted].[ISSUBFOLDER] <> NULL AND [inserted].[ISSUBFOLDER] IS NULL)
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Select Type',
			[RPTREPORTTYPE_DELETED].[TYPENAME],
			[RPTREPORTTYPE_INSERTED].[TYPENAME],
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
			INNER JOIN [RPTREPORTTYPE] [RPTREPORTTYPE_INSERTED] WITH (NOLOCK) ON [RPTREPORTTYPE_INSERTED].[RPTREPORTTYPEID] = [inserted].[RPTREPORTTYPEID]
			INNER JOIN [RPTREPORTTYPE] [RPTREPORTTYPE_DELETED] WITH (NOLOCK) ON [RPTREPORTTYPE_DELETED].[RPTREPORTTYPEID] = [deleted].[RPTREPORTTYPEID]
	WHERE	[deleted].[RPTREPORTTYPEID] <> [inserted].[RPTREPORTTYPEID]
	UNION ALL

	SELECT
			[inserted].[RPTREPORTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Virtual Path',
			ISNULL([deleted].[REPORTVIRTUALPATH],'[none]'),
			ISNULL([inserted].[REPORTVIRTUALPATH],'[none]'),
			'Report (' + ISNULL([inserted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			2,
			1,
			ISNULL([inserted].[REPORTNAME],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	ISNULL([deleted].[REPORTVIRTUALPATH], '') <> ISNULL([inserted].[REPORTVIRTUALPATH], '')

END
GO

CREATE TRIGGER [dbo].[TG_RPTREPORT_DELETE] ON [dbo].[RPTREPORT]
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
			[deleted].[RPTREPORTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Report Deleted',
			'',
			'',
			'Report (' + ISNULL([deleted].[REPORTNAME],'[none]') + ')',
			'0BF524E7-8340-4265-B97F-F6A04C18ADFA',
			3,
			1,
			ISNULL([deleted].[REPORTNAME],'[none]')
	FROM	[deleted]
END