﻿CREATE TABLE [dbo].[LICENSECYCLERECURRENCESETUP] (
    [LICENSECYCLERECURRENCESETUPID] CHAR (36)      NOT NULL,
    [NAME]                          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                   NVARCHAR (MAX) NULL,
    [RECURRENCEID]                  CHAR (36)      NOT NULL,
    [LICENSECYCLETYPEID]            INT            NOT NULL,
    [LASTCHANGEDBY]                 CHAR (36)      NULL,
    [LASTCHANGEDON]                 DATETIME       CONSTRAINT [DF_LICENSECYCLERECURRENCESETUP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                    INT            CONSTRAINT [DF_LICENSECYCLERECURRENCESETUP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_LicenseCycleRecurrenceSetup] PRIMARY KEY CLUSTERED ([LICENSECYCLERECURRENCESETUPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CycleRecurSetup_CycleType] FOREIGN KEY ([LICENSECYCLETYPEID]) REFERENCES [dbo].[LICENSECYCLETYPE] ([LICENSECYCLETYPEID]),
    CONSTRAINT [FK_CycleRecurSetup_Recur] FOREIGN KEY ([RECURRENCEID]) REFERENCES [dbo].[RECURRENCE] ([RECURRENCEID])
);


GO
CREATE NONCLUSTERED INDEX [LICENSECYCLERECURRENCESETUP_IX_QUERY]
    ON [dbo].[LICENSECYCLERECURRENCESETUP]([LICENSECYCLERECURRENCESETUPID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_LICENSECYCLERECURRENCESETUP_DELETE] ON [dbo].[LICENSECYCLERECURRENCESETUP]
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
			[deleted].[LICENSECYCLERECURRENCESETUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'License Cycle Recurrence Deleted',
			'',
			'',
			'License Cycle Recurrence (' + [deleted].[NAME] + ')',
			'E955B4F4-5BE1-4D50-A152-760063109FBF',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_LICENSECYCLERECURRENCESETUP_INSERT] ON [dbo].[LICENSECYCLERECURRENCESETUP]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of LICENSECYCLERECURRENCESETUP table with USERS table.
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
			[inserted].[LICENSECYCLERECURRENCESETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'License Cycle Recurrence Added',
			'',
			'',
			'License Cycle Recurrence (' + [inserted].[NAME] + ')',
			'E955B4F4-5BE1-4D50-A152-760063109FBF',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO


CREATE TRIGGER [dbo].[TG_LICENSECYCLERECURRENCESETUP_UPDATE] ON [dbo].[LICENSECYCLERECURRENCESETUP]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of LICENSECYCLERECURRENCESETUP table with USERS table.
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
			[inserted].[LICENSECYCLERECURRENCESETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'License Cycle Recurrence (' + [inserted].[NAME] + ')',
			'E955B4F4-5BE1-4D50-A152-760063109FBF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLERECURRENCESETUPID] = [inserted].[LICENSECYCLERECURRENCESETUPID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[LICENSECYCLERECURRENCESETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'License Cycle Recurrence (' + [inserted].[NAME] + ')',
			'E955B4F4-5BE1-4D50-A152-760063109FBF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLERECURRENCESETUPID] = [inserted].[LICENSECYCLERECURRENCESETUPID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	UNION ALL
	SELECT
			[inserted].[LICENSECYCLERECURRENCESETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recurrence',
			[RECURRENCE_DELETED].[NAME],
			[RECURRENCE_INSERTED].[NAME],
			'License Cycle Recurrence (' + [inserted].[NAME] + ')',
			'E955B4F4-5BE1-4D50-A152-760063109FBF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLERECURRENCESETUPID] = [inserted].[LICENSECYCLERECURRENCESETUPID]
			LEFT JOIN [RECURRENCE] RECURRENCE_INSERTED WITH (NOLOCK) ON [RECURRENCE_INSERTED].[RECURRENCEID] = [inserted].[RECURRENCEID]
			LEFT JOIN [RECURRENCE] RECURRENCE_DELETED WITH (NOLOCK) ON [RECURRENCE_DELETED].[RECURRENCEID] = [deleted].[RECURRENCEID]
	WHERE	[deleted].[RECURRENCEID] <> [inserted].[RECURRENCEID]		
	UNION ALL
	SELECT
			[inserted].[LICENSECYCLERECURRENCESETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'License Cycle Type',
			CONVERT(NVARCHAR(MAX), [LICENSECYCLETYPE_DELETED].[NAME]),
			CONVERT(NVARCHAR(MAX), [LICENSECYCLETYPE_INSERTED].[NAME]),			
			'License Cycle Recurrence (' + [inserted].[NAME] + ')',
			'E955B4F4-5BE1-4D50-A152-760063109FBF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[LICENSECYCLERECURRENCESETUPID] = [inserted].[LICENSECYCLERECURRENCESETUPID]
			LEFT JOIN [LICENSECYCLETYPE] LICENSECYCLETYPE_INSERTED WITH (NOLOCK) ON [LICENSECYCLETYPE_INSERTED].[LICENSECYCLETYPEID] = [inserted].[LICENSECYCLETYPEID]
			LEFT JOIN [LICENSECYCLETYPE] LICENSECYCLETYPE_DELETED WITH (NOLOCK) ON [LICENSECYCLETYPE_DELETED].[LICENSECYCLETYPEID] = [deleted].[LICENSECYCLETYPEID]
	WHERE	[deleted].[LICENSECYCLETYPEID] <> [inserted].[LICENSECYCLETYPEID]	
END