﻿CREATE TABLE [dbo].[CUSTOMFIELDOBJECT] (
    [GCUSTOMFIELD]                   CHAR (36)        NOT NULL,
    [FKGCUSTOMFIELDLAYOUT]           CHAR (36)        NOT NULL,
    [FKCUSTOMFIELDLAYOUTCONTROLTYPE] INT              NOT NULL,
    [SLABEL]                         NVARCHAR (50)    NULL,
    [FLEFTPOS]                       NUMERIC (29, 15) NULL,
    [FTOPPOS]                        NUMERIC (29, 15) NULL,
    [FHEIGHT]                        NUMERIC (29, 15) NULL,
    [FWIDTH]                         NUMERIC (29, 15) NULL,
    [BISINTABCONTROL]                BIT              NULL,
    [IPOSITION]                      INT              NULL,
    [FKGCUSTOMFIELD]                 CHAR (36)        NULL,
    [FKGPARENTCONTROL]               CHAR (36)        NULL,
    [TABINDEX]                       INT              CONSTRAINT [DF_CustomFieldObject_TabIndex] DEFAULT ((0)) NOT NULL,
    [LABELDATA]                      NVARCHAR (MAX)   CONSTRAINT [DF_CustomFieldObject_LabelData] DEFAULT ('') NOT NULL,
    [SDEFAULTVALUE]                  NVARCHAR (50)    NULL,
    [SFIELDTIP]                      NVARCHAR (MAX)   NULL,
    [BISREQUIRED]                    BIT              CONSTRAINT [DF_bIsRequired] DEFAULT ((0)) NOT NULL,
    [FORMULA]                        NVARCHAR (MAX)   NULL,
    [ISLABELSURPRESSED]              BIT              CONSTRAINT [DF_CustomFieldObject_IsLabelSurpressed] DEFAULT ((0)) NOT NULL,
    [CUSTOMIMAGE]                    VARBINARY (MAX)  NULL,
    [HYPERLINKDATA]                  NVARCHAR (MAX)   NULL,
    [COLUMNHEADERNAME]               NVARCHAR (50)    NULL,
    [SPANACROSSCOLUMN]               BIT              NULL,
    [BFOOTER]                        BIT              NULL,
    [COLUMNWIDTHS]                   NVARCHAR (MAX)   NULL,
    [NUMBEROFCOLUMNS]                INT              CONSTRAINT [DF_CustomFieldObject_NumberOfColumns] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CustomFields] PRIMARY KEY CLUSTERED ([GCUSTOMFIELD] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CustomFieldObjects_CF] FOREIGN KEY ([FKGCUSTOMFIELD]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD]),
    CONSTRAINT [FK_CustomFieldObjects_CFO] FOREIGN KEY ([FKGPARENTCONTROL]) REFERENCES [dbo].[CUSTOMFIELDOBJECT] ([GCUSTOMFIELD]),
    CONSTRAINT [FK_CustomFieldObjects_CustomFi] FOREIGN KEY ([FKCUSTOMFIELDLAYOUTCONTROLTYPE]) REFERENCES [dbo].[CUSTOMFIELDLAYOUTCONTROLTYPE] ([ICUSTOMFIELDLAYOUTCONTROLTYPE]),
    CONSTRAINT [FK_CustomFields_CustomFieldLay] FOREIGN KEY ([FKGCUSTOMFIELDLAYOUT]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);


GO
CREATE NONCLUSTERED INDEX [index_fkgCustomfield]
    ON [dbo].[CUSTOMFIELDOBJECT]([FKGCUSTOMFIELD] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTFLDOB_LAY_TPE]
    ON [dbo].[CUSTOMFIELDOBJECT]([FKGCUSTOMFIELDLAYOUT] ASC, [FKCUSTOMFIELDLAYOUTCONTROLTYPE] ASC, [GCUSTOMFIELD] ASC, [FKGCUSTOMFIELD] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTONFIELDOBJECT_LAYOUTCTRLTYPEID_LAYOUT_LABEL_ID]
    ON [dbo].[CUSTOMFIELDOBJECT]([FKCUSTOMFIELDLAYOUTCONTROLTYPE] ASC)
    INCLUDE([FKGCUSTOMFIELDLAYOUT], [SLABEL], [FKGCUSTOMFIELD]);


GO

CREATE TRIGGER [dbo].[TG_CUSTOMFIELDOBJECT_INSERT]
   ON  [dbo].[CUSTOMFIELDOBJECT]
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
        [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS], 
        [CUSTOMFIELDLAYOUT].[ROWVERSION],
        GETUTCDATE(),
        [CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],	
        'Custom Field Layout Field Added',
        '',
        '',       
		'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
		'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
		1,
		0,
		[inserted].[SLABEL]
    FROM [inserted]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	
END
GO
CREATE TRIGGER [dbo].[TG_CUSTOMFIELDOBJECT_UPDATE]
   ON  [dbo].[CUSTOMFIELDOBJECT] 
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
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Control Type',
			[OLD_TYPE].[SNAME],
			[NEW_TYPE].[SNAME],
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUTCONTROLTYPE] OLD_TYPE ON OLD_TYPE.[ICUSTOMFIELDLAYOUTCONTROLTYPE] = [deleted].[FKCUSTOMFIELDLAYOUTCONTROLTYPE]
	INNER JOIN [CUSTOMFIELDLAYOUTCONTROLTYPE] NEW_TYPE ON NEW_TYPE.[ICUSTOMFIELDLAYOUTCONTROLTYPE] = [inserted].[FKCUSTOMFIELDLAYOUTCONTROLTYPE]
	WHERE	[deleted].[FKCUSTOMFIELDLAYOUTCONTROLTYPE] <> [inserted].[FKCUSTOMFIELDLAYOUTCONTROLTYPE]
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Label',
			COALESCE([deleted].[SLABEL], '[none]'),
			COALESCE([inserted].[SLABEL], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[SLABEL], '') <> COALESCE([inserted].[SLABEL], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Left Position',
			CAST((CASE WHEN [deleted].[FLEFTPOS] IS  NULL THEN '[none]' ELSE CAST([deleted].[FLEFTPOS] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			CAST((CASE WHEN [inserted].[FLEFTPOS] IS  NULL THEN '[none]' ELSE CAST([inserted].[FLEFTPOS] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[FLEFTPOS], -1) <> COALESCE([inserted].[FLEFTPOS], -1)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Top Position',
			CAST((CASE WHEN [deleted].[FTOPPOS] IS  NULL THEN '[none]' ELSE CAST([deleted].[FTOPPOS] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			CAST((CASE WHEN [inserted].[FTOPPOS] IS  NULL THEN '[none]' ELSE CAST([inserted].[FTOPPOS] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[FTOPPOS], -1) <> COALESCE([inserted].[FTOPPOS], -1)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Height',
			CAST((CASE WHEN [deleted].[FHEIGHT] IS  NULL THEN '[none]' ELSE CAST([deleted].[FHEIGHT] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			CAST((CASE WHEN [inserted].[FHEIGHT] IS  NULL THEN '[none]' ELSE CAST([inserted].[FHEIGHT] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[FHEIGHT], -1) <> COALESCE([inserted].[FHEIGHT], -1)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Width',
			CAST((CASE WHEN [deleted].[FWIDTH] IS  NULL THEN '[none]' ELSE CAST([deleted].[FWIDTH] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			CAST((CASE WHEN [inserted].[FWIDTH] IS  NULL THEN '[none]' ELSE CAST([inserted].[FWIDTH] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[FWIDTH], -1) <> COALESCE([inserted].[FWIDTH], -1)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Inside Tab Flag',
			CASE [deleted].[BISINTABCONTROL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[BISINTABCONTROL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[BISINTABCONTROL], 0) <> COALESCE([inserted].[BISINTABCONTROL], 0)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Position',
			CAST((CASE WHEN [deleted].[IPOSITION] IS  NULL THEN '[none]' ELSE CAST([deleted].[IPOSITION] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			CAST((CASE WHEN [inserted].[IPOSITION] IS  NULL THEN '[none]' ELSE CAST([inserted].[IPOSITION] AS NVARCHAR(MAX)) END) AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[IPOSITION], -1) <> COALESCE([inserted].[IPOSITION], -1)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Parent',
			COALESCE(OLD_PARENT.[SLABEL], '[none]'),
			COALESCE(NEW_PARENT.[SLABEL], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	LEFT OUTER JOIN [CUSTOMFIELDOBJECT] OLD_PARENT ON OLD_PARENT.GCUSTOMFIELD = [deleted].[FKGPARENTCONTROL]
	LEFT OUTER JOIN [CUSTOMFIELDOBJECT] NEW_PARENT ON NEW_PARENT.GCUSTOMFIELD = [inserted].[FKGPARENTCONTROL]
	WHERE	COALESCE([deleted].[FKGPARENTCONTROL], '') <> COALESCE([inserted].[FKGPARENTCONTROL], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Tab Index',
			CAST([deleted].[TABINDEX] AS NVARCHAR(MAX)),
			CAST([inserted].[TABINDEX] AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	[deleted].[TABINDEX] <> [inserted].[TABINDEX]
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Label Data',
			[deleted].[LABELDATA],
			[inserted].[LABELDATA],
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	[deleted].[LABELDATA]  <> [inserted].[LABELDATA] 
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Default Value',
			COALESCE([deleted].[SDEFAULTVALUE], '[none]'),
			COALESCE([inserted].[SDEFAULTVALUE], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[SDEFAULTVALUE], '') <> COALESCE([inserted].[SDEFAULTVALUE], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Field Tip',
			COALESCE([deleted].[SFIELDTIP], '[none]'),
			COALESCE([inserted].[SFIELDTIP], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[SFIELDTIP], '') <> COALESCE([inserted].[SFIELDTIP], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Required Flag',
			CASE [deleted].[BISREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[BISREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	[deleted].[BISREQUIRED] <> [inserted].[BISREQUIRED]
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Formula',
			COALESCE([deleted].[FORMULA], '[none]'),
			COALESCE([inserted].[FORMULA], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[FORMULA], '') <> COALESCE([inserted].[FORMULA], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Label Hidden Flag',
			CASE [deleted].[ISLABELSURPRESSED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISLABELSURPRESSED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	[deleted].[ISLABELSURPRESSED] <> [inserted].[ISLABELSURPRESSED]
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Image',
			CASE WHEN [deleted].[CUSTOMIMAGE] IS NULL THEN '[none]' ELSE 'Image' END,
			CASE WHEN [inserted].[CUSTOMIMAGE] IS NULL THEN '[none]' ELSE 'Image' END,
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	[deleted].[CUSTOMIMAGE] <> [inserted].[CUSTOMIMAGE] OR 
			([deleted].[CUSTOMIMAGE] IS NULL AND [inserted].[CUSTOMIMAGE] IS NOT NULL) OR
			([deleted].[CUSTOMIMAGE] IS NOT NULL AND [inserted].[CUSTOMIMAGE] IS NULL)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Hyperlink',
			COALESCE([deleted].[HYPERLINKDATA], '[none]'),
			COALESCE([inserted].[HYPERLINKDATA], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[HYPERLINKDATA], '') <> COALESCE([inserted].[HYPERLINKDATA], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Column Header Name',
			COALESCE([deleted].[COLUMNHEADERNAME], '[none]'),
			COALESCE([inserted].[COLUMNHEADERNAME], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[COLUMNHEADERNAME], '') <> COALESCE([inserted].[COLUMNHEADERNAME], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Span Multiple Columns Flag',
			CASE [deleted].[SPANACROSSCOLUMN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[SPANACROSSCOLUMN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[SPANACROSSCOLUMN], 0) <> COALESCE([inserted].[SPANACROSSCOLUMN], 0)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Footer Flag',
			CASE [deleted].[BFOOTER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[BFOOTER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[BFOOTER], 0) <> COALESCE([inserted].[BFOOTER], 0)
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Column Widths',
			COALESCE([deleted].[COLUMNWIDTHS], '[none]'),
			COALESCE([inserted].[COLUMNWIDTHS], '[none]'),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	COALESCE([deleted].[COLUMNWIDTHS], '') <> COALESCE([inserted].[COLUMNWIDTHS], '')
    UNION ALL
    SELECT 
			[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[CUSTOMFIELDLAYOUT].[ROWVERSION],
			GETUTCDATE(),
			[CUSTOMFIELDLAYOUT].[LASTCHANGEDBY],
			'Number of Columns',
			CAST([deleted].[NUMBEROFCOLUMNS] AS NVARCHAR(MAX)),
			CAST([inserted].[NUMBEROFCOLUMNS] AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			0,
			[inserted].[SLABEL]
	FROM	[deleted]
	JOIN [inserted] ON [deleted].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [inserted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [inserted].[GCUSTOMFIELD]
	WHERE	[deleted].[NUMBEROFCOLUMNS] <> [inserted].[NUMBEROFCOLUMNS]
END
GO
CREATE TRIGGER [dbo].[TG_CUSTOMFIELDOBJECT_DELETE]  
    ON  [dbo].[CUSTOMFIELDOBJECT]
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
		[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
		[CUSTOMFIELDLAYOUT].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Custom Field Layout Field Deleted',
        '',
        '',       
		'Custom Field Layout (' + [CUSTOMFIELDLAYOUT].[SNAME] + '), Field (' + [CUSTOMFIELD].[SCUSTOMFIELD] +')',
		'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
		3,
		0,
		[deleted].[SLABEL]
    FROM [deleted]
	INNER JOIN [CUSTOMFIELDLAYOUT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [deleted].[FKGCUSTOMFIELDLAYOUT]
	INNER JOIN [CUSTOMFIELD] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [deleted].[GCUSTOMFIELD]
	
END