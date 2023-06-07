CREATE TABLE [dbo].[EXAMLOCATION] (
    [EXAMLOCATIONID]            CHAR (36)      NOT NULL,
    [NAME]                      NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]               NVARCHAR (MAX) NULL,
    [PAPERBASEDSEATS]           INT            NULL,
    [PCBASEDSEATS]              INT            NULL,
    [SITTINGDATEAVAILABILITYID] INT            NULL,
    [ACTIVE]                    BIT            NOT NULL,
    [PROMPTLOCATIONDETAILS]     BIT            NOT NULL,
    [RECURRENCEID]              CHAR (36)      NULL,
    [LASTCHANGEDBY]             CHAR (36)      NULL,
    [LASTCHANGEDON]             DATETIME       CONSTRAINT [DF_EXAMLOCATION_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                INT            CONSTRAINT [DF_EXAMLOCATION_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EXAMLOCATION] PRIMARY KEY CLUSTERED ([EXAMLOCATIONID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_EXAMLOC_RECURRENCE] FOREIGN KEY ([RECURRENCEID]) REFERENCES [dbo].[RECURRENCE] ([RECURRENCEID]),
    CONSTRAINT [FK_EXAMLOC_SITDATEAVAIL] FOREIGN KEY ([SITTINGDATEAVAILABILITYID]) REFERENCES [dbo].[SITTINGDATEAVAILABILITY] ([SITTINGDATEAVAILABILITYID])
);


GO
CREATE NONCLUSTERED INDEX [EXAMLOCATION_IX_QUERY]
    ON [dbo].[EXAMLOCATION]([EXAMLOCATIONID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_EXAMLOCATION_INSERT] ON [dbo].[EXAMLOCATION]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMLOCATION table with USERS table.
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
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Exam Location Added',
			'',
			'',
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_EXAMLOCATION_UPDATE] ON [dbo].[EXAMLOCATION] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMLOCATION table with USERS table.
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
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Location Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL
	SELECT
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL
	SELECT
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'# of Paper Based Seats',
			CASE WHEN [deleted].[PAPERBASEDSEATS] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[PAPERBASEDSEATS]) END,
			CASE WHEN [inserted].[PAPERBASEDSEATS] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[PAPERBASEDSEATS]) END,
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
	WHERE	ISNULL([deleted].[PAPERBASEDSEATS],'') <> ISNULL([inserted].[PAPERBASEDSEATS],'')

	UNION ALL
	SELECT
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'# of PC Based Seats',
			CASE WHEN [deleted].[PCBASEDSEATS] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[PCBASEDSEATS]) END,
			CASE WHEN [inserted].[PCBASEDSEATS] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[PCBASEDSEATS]) END,			
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
	WHERE	ISNULL([deleted].[PCBASEDSEATS],'') <> ISNULL([inserted].[PCBASEDSEATS],'')

	UNION ALL
	SELECT
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Sitting Date Availability',
			ISNULL([SITTINGDATEAVAILABILITY_DELETED].[NAME], '[none]'),
			ISNULL([SITTINGDATEAVAILABILITY_INSERTED].[NAME], '[none]'),
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
			LEFT JOIN SITTINGDATEAVAILABILITY SITTINGDATEAVAILABILITY_DELETED WITH (NOLOCK) ON [deleted].[SITTINGDATEAVAILABILITYID] = [SITTINGDATEAVAILABILITY_DELETED].[SITTINGDATEAVAILABILITYID]
			LEFT JOIN SITTINGDATEAVAILABILITY SITTINGDATEAVAILABILITY_INSERTED WITH (NOLOCK) ON [inserted].[SITTINGDATEAVAILABILITYID] = [SITTINGDATEAVAILABILITY_INSERTED].[SITTINGDATEAVAILABILITYID]
	WHERE	ISNULL([deleted].[SITTINGDATEAVAILABILITYID],'') <> ISNULL([inserted].[SITTINGDATEAVAILABILITYID],'')

	UNION ALL
	SELECT
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	
	UNION ALL
	SELECT
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prompt for Location Details Flag',
			CASE [deleted].PROMPTLOCATIONDETAILS WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].PROMPTLOCATIONDETAILS WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
	 WHERE	[deleted].[PROMPTLOCATIONDETAILS] <> [inserted].[PROMPTLOCATIONDETAILS]

	UNION ALL
	SELECT
			[inserted].[EXAMLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Availability Recurrence',
			ISNULL([RECURRENCE_DELETED].[NAME], '[none]'),
			ISNULL([RECURRENCE_INSERTED].[NAME], '[none]'),
			'Exam Location (' + [inserted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMLOCATIONID] = [inserted].[EXAMLOCATIONID]
			LEFT JOIN RECURRENCE RECURRENCE_DELETED WITH (NOLOCK) ON [deleted].[RECURRENCEID] = [RECURRENCE_DELETED].[RECURRENCEID]
			LEFT JOIN RECURRENCE RECURRENCE_INSERTED WITH (NOLOCK) ON [inserted].[RECURRENCEID] = [RECURRENCE_INSERTED].[RECURRENCEID]
	WHERE	ISNULL([deleted].[RECURRENCEID],'') <> ISNULL([inserted].[RECURRENCEID],'')
END
GO

CREATE TRIGGER [dbo].[TG_EXAMLOCATION_DELETE] ON [dbo].[EXAMLOCATION]
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
			[deleted].[EXAMLOCATIONID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Exam Location Deleted',
			'',
			'',
			'Exam Location (' + [deleted].[NAME] + ')',
			'140B0DF3-942B-404D-BEB8-FEB6904289FC',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END