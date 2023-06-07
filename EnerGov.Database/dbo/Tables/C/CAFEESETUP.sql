﻿CREATE TABLE [dbo].[CAFEESETUP] (
    [CAFEESETUPID]                    CHAR (36)       NOT NULL,
    [CAFEEID]                         CHAR (36)       NOT NULL,
    [CASCHEDULEID]                    CHAR (36)       NULL,
    [AMOUNT]                          MONEY           NOT NULL,
    [MINIMUMAMOUNT]                   MONEY           NOT NULL,
    [MAXIMUMAMOUNT]                   MONEY           NOT NULL,
    [COMPUTATIONVALUE]                DECIMAL (20, 4) NULL,
    [COMPUTATIONVALUENAME]            NVARCHAR (50)   NULL,
    [ROUNDINGTYPEID]                  INT             NOT NULL,
    [ROUNDINGVALUE]                   DECIMAL (20, 4) NULL,
    [ROWVERSION]                      INT             CONSTRAINT [DF_CAFeeSetup_Version] DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDBY]                   CHAR (36)       NOT NULL,
    [LASTCHANGEDON]                   DATETIME        CONSTRAINT [DF_CAFeeSetup_ChangedOn] DEFAULT (getdate()) NOT NULL,
    [CAPRORATESCHEDULEID]             CHAR (36)       NULL,
    [CAPRORATIONMODELID]              INT             DEFAULT ((0)) NOT NULL,
    [CACPITYPEID]                     CHAR (36)       NULL,
    [CPIORIGINALFEEDATE]              DATETIME        NULL,
    [CAFEECOMPOUNDINGFREQUENCYTYPEID] INT             NULL,
    CONSTRAINT [PK_CAFeeSetup] PRIMARY KEY CLUSTERED ([CAFEESETUPID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CAFEESETUP_CACPITYPE] FOREIGN KEY ([CACPITYPEID]) REFERENCES [dbo].[CACPITYPE] ([CACPITYPEID]),
    CONSTRAINT [FK_CAFeeSetup_ChangedBy] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CAFeeSetup_Fee] FOREIGN KEY ([CAFEEID]) REFERENCES [dbo].[CAFEE] ([CAFEEID]),
    CONSTRAINT [FK_CAFeeSetup_Rounding] FOREIGN KEY ([ROUNDINGTYPEID]) REFERENCES [dbo].[CAROUNDINGTYPE] ([CAROUNDINGTYPEID]),
    CONSTRAINT [FK_CAFeeSetup_Schedule] FOREIGN KEY ([CASCHEDULEID]) REFERENCES [dbo].[CASCHEDULE] ([CASCHEDULEID]),
    CONSTRAINT [FK_CAPRORATEMOEL_CAFEESETUP] FOREIGN KEY ([CAPRORATIONMODELID]) REFERENCES [dbo].[CAPRORATIONMODEL] ([CAPRORATIONMODELID]),
    CONSTRAINT [FK_CAPRORATESCH_CAFEESETUP] FOREIGN KEY ([CAPRORATESCHEDULEID]) REFERENCES [dbo].[CAPRORATESCHEDULE] ([CAPRORATESCHEDULEID]),
    CONSTRAINT [UK_CAFeeSetup_Schedule] UNIQUE NONCLUSTERED ([CAFEEID] ASC, [CASCHEDULEID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [CAFEESETUP_IX_CAFEEID]
    ON [dbo].[CAFEESETUP]([CAFEEID] ASC);


GO
CREATE TRIGGER [TG_CAFEESETUP_INSERT] ON [CAFEESETUP]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

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
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Fee - Fee Setup Added',
			'',
			'',
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			1,
			0,
			ISNULL([CASCHEDULE].[NAME], '[none]')
	FROM	[inserted]
	INNER JOIN [CAFEE] ON [inserted].[CAFEEID] = [CAFEE].[CAFEEID]
	LEFT JOIN [CASCHEDULE] WITH (NOLOCK) ON [CASCHEDULE].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
END
GO

CREATE TRIGGER [dbo].[TG_CAFEESETUP_UPDATE] ON  [dbo].[CAFEESETUP]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	DECLARE @Old_Value NVARCHAR(MAX) = ''
	DECLARE @New_Value NVARCHAR(MAX) = ''
	
	SELECT TOP 1 @Old_Value = ISNULL([HISTORYSYSTEMSETUP].[OLDVALUE], [CACOMPUTATIONTYPE].[NAME]), 
				 @New_Value = ISNULL([HISTORYSYSTEMSETUP].[NEWVALUE], [CACOMPUTATIONTYPE].[NAME]) 
	FROM		CAFEE
				JOIN inserted ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
				JOIN CACOMPUTATIONTYPE ON [CACOMPUTATIONTYPE].[CACOMPUTATIONTYPEID] = [CAFEE].[CACOMPUTATIONTYPEID]
				LEFT JOIN HISTORYSYSTEMSETUP WITH (NOLOCK) ON [CAFEE].[CAFEEID] = [HISTORYSYSTEMSETUP].[ID]
						AND [CAFEE].[ROWVERSION] = [HISTORYSYSTEMSETUP].[ROWVERSION]
						AND [HISTORYSYSTEMSETUP].[FIELDNAME] = 'Fee Type' 
	                    AND [HISTORYSYSTEMSETUP].[FORMID] = 'A66F715D-7817-4C5C-8D32-D9B22581828C'
						
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
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Fee Schedule',
			ISNULL([CASCHEDULE_DELETED].[NAME], '[none]'),
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEESETUPID] = [inserted].[CAFEESETUPID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_DELETED WITH (NOLOCK) ON [CASCHEDULE_DELETED].[CASCHEDULEID] = [deleted].[CASCHEDULEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	ISNULL([deleted].[CASCHEDULEID], '') <> ISNULL([inserted].[CASCHEDULEID], '')

	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			CASE WHEN @New_Value = 'Percentage' THEN 'Percentage' ELSE 'Amount' END,
			CASE WHEN @Old_Value = 'Percentage' THEN CAST(CONVERT(DECIMAL(19,4), [deleted].[AMOUNT]) AS NVARCHAR(MAX)) + '%' 
				 ELSE CAST(FORMAT([deleted].[AMOUNT], 'C4') AS NVARCHAR(MAX)) 
				 END,
			CASE WHEN @New_Value = 'Percentage' THEN CAST(CONVERT(DECIMAL(19,4), [inserted].[AMOUNT]) AS NVARCHAR(MAX)) + '%' 
				 ELSE CAST(FORMAT([inserted].[AMOUNT], 'C4') AS NVARCHAR(MAX)) 
				 END,
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEESETUPID] = [inserted].[CAFEESETUPID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	([deleted].[AMOUNT] <> [inserted].[AMOUNT]) OR (@Old_Value <> @New_Value AND (@Old_Value = 'Percentage' OR @New_Value = 'Percentage'))
	
	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Minimum',
			CAST([deleted].[MINIMUMAMOUNT] AS NVARCHAR(MAX)),
            CAST([inserted].[MINIMUMAMOUNT] AS NVARCHAR(MAX)),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	[deleted].[MINIMUMAMOUNT] <> [inserted].[MINIMUMAMOUNT]

	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Maximum',
			CAST([deleted].[MAXIMUMAMOUNT] AS NVARCHAR(MAX)),
            CAST([inserted].[MAXIMUMAMOUNT] AS NVARCHAR(MAX)),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	[deleted].[MAXIMUMAMOUNT] <> [inserted].[MAXIMUMAMOUNT]

	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Computation Value',
			ISNULL(CAST([deleted].[COMPUTATIONVALUE] AS NVARCHAR(MAX)),'[none]'),
			ISNULL(CAST([inserted].[COMPUTATIONVALUE] AS NVARCHAR(MAX)),'[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE ([deleted].[COMPUTATIONVALUE] <> [inserted].[COMPUTATIONVALUE]
		OR ([deleted].[COMPUTATIONVALUE] IS NULL AND [inserted].[COMPUTATIONVALUE] IS NOT NULL)
		OR ([deleted].[COMPUTATIONVALUE] IS NOT NULL AND [inserted].[COMPUTATIONVALUE] IS NULL))  
	
	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Computation Value Name',
			ISNULL([deleted].[COMPUTATIONVALUENAME],'[none]'),
			ISNULL([inserted].[COMPUTATIONVALUENAME],'[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	ISNULL([deleted].[COMPUTATIONVALUENAME],'') <> ISNULL([inserted].[COMPUTATIONVALUENAME],'')

	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Rounding Fee',
			[CAROUNDINGTYPE_DELETED].[NAME],
			[CAROUNDINGTYPE_INSERTED].[NAME],
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	INNER JOIN [CAROUNDINGTYPE] CAROUNDINGTYPE_DELETED WITH (NOLOCK) ON [deleted].[ROUNDINGTYPEID] = [CAROUNDINGTYPE_DELETED].[CAROUNDINGTYPEID]
	INNER JOIN [CAROUNDINGTYPE] CAROUNDINGTYPE_INSERTED WITH (NOLOCK) ON [inserted].[ROUNDINGTYPEID] = [CAROUNDINGTYPE_INSERTED].[CAROUNDINGTYPEID]
	WHERE	[deleted].[ROUNDINGTYPEID] <> [inserted].[ROUNDINGTYPEID]

	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Rounding Fee Value',
			ISNULL(CAST([deleted].[ROUNDINGVALUE] AS NVARCHAR(MAX)),'[none]'),
			ISNULL(CAST([inserted].[ROUNDINGVALUE] AS NVARCHAR(MAX)),'[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE ([deleted].[ROUNDINGVALUE] <> [inserted].[ROUNDINGVALUE]
		OR ([deleted].[ROUNDINGVALUE] IS NULL AND [inserted].[ROUNDINGVALUE] IS NOT NULL)
		OR ([deleted].[ROUNDINGVALUE] IS NOT NULL AND [inserted].[ROUNDINGVALUE] IS NULL))

	UNION ALL
	SELECT 
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Proration Schedule',
			ISNULL([CAPRORATESCHEDULE_DELETED].[NAME], '[none]'),
			ISNULL([CAPRORATESCHEDULE_INSERTED].[NAME], '[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CAPRORATESCHEDULE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CAPRORATESCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEESETUPID] = [inserted].[CAFEESETUPID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CAPRORATESCHEDULE] CAPRORATESCHEDULE_DELETED WITH (NOLOCK) ON [CAPRORATESCHEDULE_DELETED].[CAPRORATESCHEDULEID] = [deleted].[CAPRORATESCHEDULEID]
	LEFT JOIN [CAPRORATESCHEDULE] CAPRORATESCHEDULE_INSERTED WITH (NOLOCK) ON [CAPRORATESCHEDULE_INSERTED].[CAPRORATESCHEDULEID] = [inserted].[CAPRORATESCHEDULEID]
	WHERE	ISNULL([deleted].[CAPRORATESCHEDULEID], '') <> ISNULL([inserted].[CAPRORATESCHEDULEID], '')

	UNION ALL
	SELECT 
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Proration Model',
			[CAPRORATIONMODEL_DELETED].[NAME],
			[CAPRORATIONMODEL_INSERTED].[NAME],
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CAPRORATIONMODEL_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CAPRORATIONMODEL_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEESETUPID] = [inserted].[CAFEESETUPID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	JOIN [CAPRORATIONMODEL] CAPRORATIONMODEL_DELETED WITH (NOLOCK) ON [CAPRORATIONMODEL_DELETED].[CAPRORATIONMODELID] = [deleted].[CAPRORATIONMODELID]
	JOIN [CAPRORATIONMODEL] CAPRORATIONMODEL_INSERTED WITH (NOLOCK) ON [CAPRORATIONMODEL_INSERTED].[CAPRORATIONMODELID] = [inserted].[CAPRORATIONMODELID]
	WHERE	[deleted].[CAPRORATIONMODELID] <> [inserted].[CAPRORATIONMODELID]

	UNION ALL
	SELECT 
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'CPI Type',
			ISNULL([CACPITYPE_DELETED].[NAME], '[none]'),
			ISNULL([CACPITYPE_INSERTED].[NAME], '[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CACPITYPE_INSERTED].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CACPITYPE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEESETUPID] = [inserted].[CAFEESETUPID]
	INNER JOIN [CAFEE] ON [CAFEE].[CAFEEID] = [inserted].[CAFEEID]
	LEFT JOIN [CACPITYPE] CACPITYPE_DELETED WITH (NOLOCK) ON [CACPITYPE_DELETED].[CACPITYPEID] = [deleted].[CACPITYPEID]
	LEFT JOIN [CACPITYPE] CACPITYPE_INSERTED WITH (NOLOCK) ON [CACPITYPE_INSERTED].[CACPITYPEID] = [inserted].[CACPITYPEID]
	WHERE	ISNULL([deleted].[CACPITYPEID], '') <> ISNULL([inserted].[CACPITYPEID], '')

	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'CPI Start Date',
			CASE WHEN [deleted].[CPIORIGINALFEEDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [deleted].[CPIORIGINALFEEDATE], 101) ELSE '[none]' END,
			CASE WHEN [inserted].[CPIORIGINALFEEDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [inserted].[CPIORIGINALFEEDATE], 101) ELSE '[none]' END,	
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CACPITYPE_INSERTED].[NAME], 'CPI Start Date') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CACPITYPE_INSERTED].[NAME], 'CPI Start Date')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]	
	INNER JOIN CAFEE ON CAFEE.CAFEEID = [inserted].CAFEEID
	LEFT JOIN [CACPITYPE] CACPITYPE_DELETED WITH (NOLOCK) ON [CACPITYPE_DELETED].[CACPITYPEID] = [deleted].[CACPITYPEID]
	LEFT JOIN [CACPITYPE] CACPITYPE_INSERTED WITH (NOLOCK) ON [CACPITYPE_INSERTED].[CACPITYPEID] = [inserted].[CACPITYPEID]
	WHERE	ISNULL([deleted].[CPIORIGINALFEEDATE], '') <> ISNULL([inserted].[CPIORIGINALFEEDATE], '')
	
	UNION ALL
	SELECT
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEE].[LASTCHANGEDBY],
			'Fee Compounding Frequency Type',
			ISNULL(CASE
				WHEN [deleted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 1 THEN 'Daily'
				WHEN [deleted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 2 THEN 'Weekly' 
				WHEN [deleted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 3 THEN 'Monthly' 
				WHEN [deleted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 4 THEN 'Quarterly'
				WHEN [deleted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 5 THEN 'Yearly'
			END, '[none]'),
			ISNULL(CASE 
				WHEN [inserted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 1 THEN 'Daily' 
				WHEN [inserted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 2 THEN 'Weekly' 
				WHEN [inserted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 3 THEN 'Monthly' 
				WHEN [inserted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 4 THEN 'Quarterly' 
				WHEN [inserted].[CAFEECOMPOUNDINGFREQUENCYTYPEID] = 5 THEN 'Yearly' 
			END, '[none]'),
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE_INSERTED].[NAME], ' Fee Compounding Frequency Type') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			0,
			ISNULL([CASCHEDULE_INSERTED].[NAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	INNER JOIN CAFEE ON [inserted].[CAFEEID] = [CAFEE].[CAFEEID]
	LEFT JOIN [CASCHEDULE] CASCHEDULE_INSERTED WITH (NOLOCK) ON [CASCHEDULE_INSERTED].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	ISNULL([deleted].[CAFEECOMPOUNDINGFREQUENCYTYPEID], '') <> ISNULL([inserted].[CAFEECOMPOUNDINGFREQUENCYTYPEID], '')
END
GO

CREATE TRIGGER [TG_CAFEESETUP_DELETE] ON [CAFEESETUP]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON

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
			[CAFEE].[CAFEEID],
			[CAFEE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Fee - Fee Setup Deleted',
			'',
			'',
			'Fee (' + [CAFEE].[NAME] + '), Fee Setup (' + ISNULL([CASCHEDULE].[NAME], '[none]') + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			3,
			0,
			ISNULL([CASCHEDULE].[NAME], '[none]')
	FROM	[deleted]	
	INNER JOIN [CAFEE] ON [deleted].[CAFEEID] = [CAFEE].[CAFEEID]	
	LEFT JOIN [CASCHEDULE] WITH (NOLOCK) ON [CASCHEDULE].[CASCHEDULEID] = [deleted].[CASCHEDULEID]
END