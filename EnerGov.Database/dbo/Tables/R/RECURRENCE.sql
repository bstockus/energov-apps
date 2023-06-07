CREATE TABLE [dbo].[RECURRENCE] (
    [RECURRENCEID]                   CHAR (36)     NOT NULL,
    [NAME]                           VARCHAR (100) NOT NULL,
    [DAILY]                          BIT           NULL,
    [WEEKLY]                         BIT           NULL,
    [MONTHLY]                        BIT           NULL,
    [YEARLY]                         BIT           NULL,
    [DAILYRECURSEVERYNODAYS]         VARCHAR (10)  NULL,
    [DAILYRECURSEVERYWEEKDAY]        BIT           NULL,
    [WEEKLYRECURSEVERYNOWEEKS]       VARCHAR (10)  NULL,
    [WEEKLYRECURSONMONDAY]           BIT           NULL,
    [WEEKLYRECURSONTUESDAY]          BIT           NULL,
    [WEEKLYRECURSONWEDNESDAY]        BIT           NULL,
    [WEEKLYRECURSONTHURSDAY]         BIT           NULL,
    [WEEKLYRECURSONFRIDAY]           BIT           NULL,
    [WEEKLYRECURSONSATURDAY]         BIT           NULL,
    [WEEKLYRECURSONSUNDAY]           BIT           NULL,
    [MONTHLYTHERECURPATTERN]         BIT           NULL,
    [MONTHLYEVERYDAYDAY]             VARCHAR (10)  NULL,
    [MONTHLYEVERYNOOFMONTHS]         VARCHAR (10)  NULL,
    [MONTHLYWEEKNUMBER]              VARCHAR (20)  NULL,
    [MONTHLYWEEKDAY]                 VARCHAR (50)  NULL,
    [MONTHLYTHENOOFMONTHS]           VARCHAR (10)  NULL,
    [YEARLYTHERECURPATTERN]          BIT           NULL,
    [YEARLYEVERYMONTH]               VARCHAR (20)  NULL,
    [YEARLYEVERYDAY]                 VARCHAR (10)  NULL,
    [YEARLYTHEWEEK]                  VARCHAR (20)  NULL,
    [YEARLYTHEDAYOFWEEK]             VARCHAR (20)  NULL,
    [YEARLYTHEMONTHOFYEAR]           VARCHAR (20)  NULL,
    [STARTDATE]                      DATETIME      NULL,
    [RECURSUNTILDATE]                DATETIME      NULL,
    [STARTTIME]                      SMALLDATETIME NULL,
    [ENDTIME]                        SMALLDATETIME NULL,
    [ALLDAYEVENT]                    BIT           NULL,
    [MAXOCCURENCES]                  INT           NULL,
    [EVERYXDAYS]                     BIT           NULL,
    [EVERYXWEEKS]                    BIT           NULL,
    [DAYOFXMONTH]                    BIT           NULL,
    [DAYOFXYEAR]                     BIT           NULL,
    [DUEON]                          BIT           NULL,
    [DAILYRECURSFROM]                VARCHAR (50)  NULL,
    [DAILYRECURSEXCLUDEWEEKENDS]     BIT           NULL,
    [WEEKLYRECURSEVRYNOWEEKSFROM]    VARCHAR (50)  NULL,
    [WEEKLYRECURSEVRYNOWEEKS2]       VARCHAR (10)  NULL,
    [WEEKLYRECURSEVRYNOWEEKSFROM2]   VARCHAR (50)  NULL,
    [WEEKLYEXPIRESEVERYWEEK]         BIT           NULL,
    [WEEKLYEXPIRESEVERYWEEKFROMDATE] BIT           NULL,
    [MONTHLYEVERYFROM]               VARCHAR (50)  NULL,
    [MONTHLYWEEKFROM]                VARCHAR (50)  NULL,
    [YEARLYFROMISSUEDATE]            BIT           NULL,
    [YEARLYEXPIRESEVERYNOYEARS]      VARCHAR (20)  NULL,
    [DUEONMONTH]                     VARCHAR (20)  NULL,
    [DUEONDAYS]                      VARCHAR (10)  NULL,
    [DUEONYEAR]                      VARCHAR (20)  NULL,
    [DUEONTHEWEEK]                   VARCHAR (20)  NULL,
    [DUEONTHEDAYOFWEEK]              VARCHAR (20)  NULL,
    [DUEONTHEMONTHOFYEAR]            VARCHAR (20)  NULL,
    [DUEONTHEYEAR]                   VARCHAR (20)  NULL,
    [LICENSECYCLETYPEID]             INT           NULL,
    [DUEONON]                        BIT           NULL,
    [DUEONONTHE]                     BIT           NULL,
    [LASTCHANGEDBY]                  CHAR (36)     NULL,
    [LASTCHANGEDON]                  DATETIME      CONSTRAINT [DF_RECURRENCE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                     INT           CONSTRAINT [DF_RECURRENCE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Recurrence] PRIMARY KEY CLUSTERED ([RECURRENCEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RecurrenceLicenseCycleType] FOREIGN KEY ([LICENSECYCLETYPEID]) REFERENCES [dbo].[LICENSECYCLETYPE] ([LICENSECYCLETYPEID])
);


GO
CREATE NONCLUSTERED INDEX [RECURRENCE_IX_QUERY]
    ON [dbo].[RECURRENCE]([RECURRENCEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_RECURRENCE_DELETE] ON RECURRENCE
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
			[deleted].[RECURRENCEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Recurrence Deleted',
			'',
			'',
			'Recurrence (' + [deleted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_RECURRENCE_INSERT] ON RECURRENCE
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RECURRENCE table with USERS table.
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
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recurrence Added',
			'',
			'',
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_RECURRENCE_UPDATE] ON RECURRENCE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RECURRENCE table with USERS table.
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
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Daily',
			CASE [deleted].[DAILY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DAILY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DAILY], '') <> ISNULL([inserted].[DAILY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly',
			CASE [deleted].[WEEKLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLY], '') <> ISNULL([inserted].[WEEKLY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly',
			CASE [deleted].[MONTHLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[MONTHLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLY], '') <> ISNULL([inserted].[MONTHLY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly',
			CASE [deleted].[YEARLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[YEARLY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLY], '') <> ISNULL([inserted].[YEARLY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Daily Recurs Every No Days',
			ISNULL([deleted].[DAILYRECURSEVERYNODAYS], '[none]'),
			ISNULL([inserted].[DAILYRECURSEVERYNODAYS], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DAILYRECURSEVERYNODAYS], '') <> ISNULL([inserted].[DAILYRECURSEVERYNODAYS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Daily Recurs Every Weekday',
			CASE [deleted].[DAILYRECURSEVERYWEEKDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DAILYRECURSEVERYWEEKDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DAILYRECURSEVERYWEEKDAY], '') <> ISNULL([inserted].[DAILYRECURSEVERYWEEKDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs Every No Weeks',
			ISNULL([deleted].[WEEKLYRECURSEVERYNOWEEKS], '[none]'),
			ISNULL([inserted].[WEEKLYRECURSEVERYNOWEEKS], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSEVERYNOWEEKS], '') <> ISNULL([inserted].[WEEKLYRECURSEVERYNOWEEKS], '')

	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs On Monday',
			CASE [deleted].[WEEKLYRECURSONMONDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYRECURSONMONDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSONMONDAY], '') <> ISNULL([inserted].[WEEKLYRECURSONMONDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs On Tuesday',
			CASE [deleted].[WEEKLYRECURSONTUESDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYRECURSONTUESDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSONTUESDAY], '') <> ISNULL([inserted].[WEEKLYRECURSONTUESDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs On Wednesday',
			CASE [deleted].[WEEKLYRECURSONWEDNESDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYRECURSONWEDNESDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSONWEDNESDAY], '') <> ISNULL([inserted].[WEEKLYRECURSONWEDNESDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs On Thursday',
			CASE [deleted].[WEEKLYRECURSONTHURSDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYRECURSONTHURSDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSONTHURSDAY], '') <> ISNULL([inserted].[WEEKLYRECURSONTHURSDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs On Friday',
			CASE [deleted].[WEEKLYRECURSONFRIDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYRECURSONFRIDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSONFRIDAY], '') <> ISNULL([inserted].[WEEKLYRECURSONFRIDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs On Saturday',
			CASE [deleted].[WEEKLYRECURSONSATURDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYRECURSONSATURDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSONSATURDAY], '') <> ISNULL([inserted].[WEEKLYRECURSONSATURDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs On Sunday',
			CASE [deleted].[WEEKLYRECURSONSUNDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYRECURSONSUNDAY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSONSUNDAY], '') <> ISNULL([inserted].[WEEKLYRECURSONSUNDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly The Recur Pattern',
			CASE [deleted].[MONTHLYTHERECURPATTERN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[MONTHLYTHERECURPATTERN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYTHERECURPATTERN], '') <> ISNULL([inserted].[MONTHLYTHERECURPATTERN], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly Everyday Day',
			ISNULL([deleted].[MONTHLYEVERYDAYDAY], '[none]'),
			ISNULL([inserted].[MONTHLYEVERYDAYDAY], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
			FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYEVERYDAYDAY], '') <> ISNULL([inserted].[MONTHLYEVERYDAYDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly Every No Of Months',
			ISNULL([deleted].[MONTHLYEVERYNOOFMONTHS], '[none]'),
			ISNULL([inserted].[MONTHLYEVERYNOOFMONTHS], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYEVERYNOOFMONTHS], '') <> ISNULL([inserted].[MONTHLYEVERYNOOFMONTHS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly Week Number',
			ISNULL([deleted].[MONTHLYWEEKNUMBER], '[none]'),
			ISNULL([inserted].[MONTHLYWEEKNUMBER], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYWEEKNUMBER], '') <> ISNULL([inserted].[MONTHLYWEEKNUMBER], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly Weekday',
			ISNULL([deleted].[MONTHLYWEEKDAY], '[none]'),
			ISNULL([inserted].[MONTHLYWEEKDAY], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYWEEKDAY], '') <> ISNULL([inserted].[MONTHLYWEEKDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly The No Of Months',
			ISNULL([deleted].[MONTHLYTHENOOFMONTHS], '[none]'),
			ISNULL([inserted].[MONTHLYTHENOOFMONTHS], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYTHENOOFMONTHS], '') <> ISNULL([inserted].[MONTHLYTHENOOFMONTHS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly The Recur Pattern',
			CASE [deleted].[YEARLYTHERECURPATTERN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[YEARLYTHERECURPATTERN] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYTHERECURPATTERN], '') <> ISNULL([inserted].[YEARLYTHERECURPATTERN], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly Every Month',
			ISNULL([deleted].[YEARLYEVERYMONTH], '[none]'),
			ISNULL([inserted].[YEARLYEVERYMONTH], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYEVERYMONTH], '') <> ISNULL([inserted].[YEARLYEVERYMONTH], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly Every Day',
			ISNULL([deleted].[YEARLYEVERYDAY], '[none]'),
			ISNULL([inserted].[YEARLYEVERYDAY], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYEVERYDAY], '') <> ISNULL([inserted].[YEARLYEVERYDAY], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly The Week',
			ISNULL([deleted].[YEARLYTHEWEEK], '[none]'),
			ISNULL([inserted].[YEARLYTHEWEEK], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYTHEWEEK], '') <> ISNULL([inserted].[YEARLYTHEWEEK], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly The Day Of Week',
			ISNULL([deleted].[YEARLYTHEDAYOFWEEK], '[none]'),
			ISNULL([inserted].[YEARLYTHEDAYOFWEEK], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYTHEDAYOFWEEK], '') <> ISNULL([inserted].[YEARLYTHEDAYOFWEEK], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly The Month Of Year',
			ISNULL([deleted].[YEARLYTHEMONTHOFYEAR], '[none]'),
			ISNULL([inserted].[YEARLYTHEMONTHOFYEAR], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYTHEMONTHOFYEAR], '') <> ISNULL([inserted].[YEARLYTHEMONTHOFYEAR], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start Date',
			CASE WHEN [deleted].[STARTDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101) ELSE '[none]' END,
			CASE WHEN [inserted].[STARTDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101) ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[STARTDATE], '') <> ISNULL([inserted].[STARTDATE], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recurs Until Date',
			CASE WHEN [deleted].[RECURSUNTILDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [deleted].[RECURSUNTILDATE], 101) ELSE '[none]' END,
			CASE WHEN [inserted].[RECURSUNTILDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [inserted].[RECURSUNTILDATE], 101) ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[RECURSUNTILDATE], '') <> ISNULL([inserted].[RECURSUNTILDATE], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start Time',
			CASE WHEN [deleted].[STARTTIME] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [deleted].[STARTTIME], 101) ELSE '[none]' END,
			CASE WHEN [inserted].[STARTTIME] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [inserted].[STARTTIME], 101) ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[STARTTIME], '') <> ISNULL([inserted].[STARTTIME], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End Time',
			CASE WHEN [deleted].[ENDTIME] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [deleted].[ENDTIME], 101) ELSE '[none]' END,
			CASE WHEN [inserted].[ENDTIME] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [inserted].[ENDTIME], 101) ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[ENDTIME], '') <> ISNULL([inserted].[ENDTIME], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'All Day Event',
			CASE [deleted].[ALLDAYEVENT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ALLDAYEVENT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[ALLDAYEVENT], '') <> ISNULL([inserted].[ALLDAYEVENT], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Max Occurences',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[MAXOCCURENCES]), '[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[MAXOCCURENCES]), '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MAXOCCURENCES], '') <> ISNULL([inserted].[MAXOCCURENCES], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Every X Days',
			CASE [deleted].[EVERYXDAYS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[EVERYXDAYS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[EVERYXDAYS], '') <> ISNULL([inserted].[EVERYXDAYS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Every X Weeks',
			CASE [deleted].[EVERYXWEEKS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[EVERYXWEEKS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[EVERYXWEEKS], '') <> ISNULL([inserted].[EVERYXWEEKS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Day Of X Month',
			CASE [deleted].[DAYOFXMONTH] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DAYOFXMONTH] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DAYOFXMONTH], '') <> ISNULL([inserted].[DAYOFXMONTH], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Day Of X Year',
			CASE [deleted].[DAYOFXYEAR] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DAYOFXYEAR] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DAYOFXYEAR], '') <> ISNULL([inserted].[DAYOFXYEAR], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On',
			CASE [deleted].[DUEON] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DUEON] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEON], '') <> ISNULL([inserted].[DUEON], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Daily Recurs From',
			ISNULL([deleted].[DAILYRECURSFROM], '[none]'),
			ISNULL([inserted].[DAILYRECURSFROM], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DAILYRECURSFROM], '') <> ISNULL([inserted].[DAILYRECURSFROM], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Daily Recurs Exclude Weekends',
			CASE [deleted].[DAILYRECURSEXCLUDEWEEKENDS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DAILYRECURSEXCLUDEWEEKENDS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DAILYRECURSEXCLUDEWEEKENDS], '') <> ISNULL([inserted].[DAILYRECURSEXCLUDEWEEKENDS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs Every No Weeks From',
			ISNULL([deleted].[WEEKLYRECURSEVRYNOWEEKSFROM], '[none]'),
			ISNULL([inserted].[WEEKLYRECURSEVRYNOWEEKSFROM], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSEVRYNOWEEKSFROM], '') <> ISNULL([inserted].[WEEKLYRECURSEVRYNOWEEKSFROM], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs Every No Weeks 2',
			ISNULL([deleted].[WEEKLYRECURSEVRYNOWEEKS2], '[none]'),
			ISNULL([inserted].[WEEKLYRECURSEVRYNOWEEKS2], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSEVRYNOWEEKS2], '') <> ISNULL([inserted].[WEEKLYRECURSEVRYNOWEEKS2], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Recurs Every No Weeks From 2',
			ISNULL([deleted].[WEEKLYRECURSEVRYNOWEEKSFROM2], '[none]'),
			ISNULL([inserted].[WEEKLYRECURSEVRYNOWEEKSFROM2], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYRECURSEVRYNOWEEKSFROM2], '') <> ISNULL([inserted].[WEEKLYRECURSEVRYNOWEEKSFROM2], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Expires Every Week',
			CASE [deleted].[WEEKLYEXPIRESEVERYWEEK] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYEXPIRESEVERYWEEK] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYEXPIRESEVERYWEEK], '') <> ISNULL([inserted].[WEEKLYEXPIRESEVERYWEEK], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weekly Expires Every Week From Date',
			CASE [deleted].[WEEKLYEXPIRESEVERYWEEKFROMDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[WEEKLYEXPIRESEVERYWEEKFROMDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[WEEKLYEXPIRESEVERYWEEKFROMDATE], '') <> ISNULL([inserted].[WEEKLYEXPIRESEVERYWEEKFROMDATE], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly Every From',
			ISNULL([deleted].[MONTHLYEVERYFROM], '[none]'),
			ISNULL([inserted].[MONTHLYEVERYFROM], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYEVERYFROM], '') <> ISNULL([inserted].[MONTHLYEVERYFROM], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monthly Week From',
			ISNULL([deleted].[MONTHLYWEEKFROM], '[none]'),
			ISNULL([inserted].[MONTHLYWEEKFROM], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[MONTHLYWEEKFROM], '') <> ISNULL([inserted].[MONTHLYWEEKFROM], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly From Issue Date',
			CASE [deleted].[YEARLYFROMISSUEDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[YEARLYFROMISSUEDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYFROMISSUEDATE], '') <> ISNULL([inserted].[YEARLYFROMISSUEDATE], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Yearly Expires Every No Years',
			ISNULL([deleted].[YEARLYEXPIRESEVERYNOYEARS], '[none]'),
			ISNULL([inserted].[YEARLYEXPIRESEVERYNOYEARS], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[YEARLYEXPIRESEVERYNOYEARS], '') <> ISNULL([inserted].[YEARLYEXPIRESEVERYNOYEARS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On Month',
			ISNULL([deleted].[DUEONMONTH], '[none]'),
			ISNULL([inserted].[DUEONMONTH], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONMONTH], '') <> ISNULL([inserted].[DUEONMONTH], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On Days',
			ISNULL([deleted].[DUEONDAYS], '[none]'),
			ISNULL([inserted].[DUEONDAYS], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONDAYS], '') <> ISNULL([inserted].[DUEONDAYS], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On Year',
			ISNULL([deleted].[DUEONYEAR], '[none]'),
			ISNULL([inserted].[DUEONYEAR], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONYEAR], '') <> ISNULL([inserted].[DUEONYEAR], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On The Week',
			ISNULL([deleted].[DUEONTHEWEEK], '[none]'),
			ISNULL([inserted].[DUEONTHEWEEK], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONTHEWEEK], '') <> ISNULL([inserted].[DUEONTHEWEEK], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On The Day Of Week',
			ISNULL([deleted].[DUEONTHEDAYOFWEEK], '[none]'),
			ISNULL([inserted].[DUEONTHEDAYOFWEEK], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONTHEDAYOFWEEK], '') <> ISNULL([inserted].[DUEONTHEDAYOFWEEK], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On The Month Of Year',
			ISNULL([deleted].[DUEONTHEMONTHOFYEAR], '[none]'),
			ISNULL([inserted].[DUEONTHEMONTHOFYEAR], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONTHEMONTHOFYEAR], '') <> ISNULL([inserted].[DUEONTHEMONTHOFYEAR], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On The Year',
			ISNULL([deleted].[DUEONTHEYEAR], '[none]'),
			ISNULL([inserted].[DUEONTHEYEAR], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONTHEYEAR], '') <> ISNULL([inserted].[DUEONTHEYEAR], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recurrence Type', 
			ISNULL([LICENSECYCLETYPE_DELETED].[NAME], '[none]'),
			ISNULL([LICENSECYCLETYPE_INSERTED].[NAME], '[none]'),
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
			LEFT JOIN [LICENSECYCLETYPE] LICENSECYCLETYPE_DELETED WITH (NOLOCK) ON [deleted].[LICENSECYCLETYPEID] = LICENSECYCLETYPE_DELETED.[LICENSECYCLETYPEID]
			LEFT JOIN [LICENSECYCLETYPE] LICENSECYCLETYPE_INSERTED WITH (NOLOCK) ON [inserted].[LICENSECYCLETYPEID] = LICENSECYCLETYPE_INSERTED.[LICENSECYCLETYPEID]
	WHERE	ISNULL([deleted].[LICENSECYCLETYPEID], '') <> ISNULL([inserted].[LICENSECYCLETYPEID], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On On',
			CASE [deleted].[DUEONON] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DUEONON] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONON], '') <> ISNULL([inserted].[DUEONON], '')
	
	UNION ALL
	SELECT
			[inserted].[RECURRENCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due On On The',
			CASE [deleted].[DUEONONTHE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[DUEONONTHE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Recurrence (' + [inserted].[NAME] + ')',
			'77E57EDE-5261-4361-98FF-29254079D78F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	ISNULL([deleted].[DUEONONTHE], '') <> ISNULL([inserted].[DUEONONTHE], '')
END