CREATE TABLE [dbo].[EXAMTIMESLOT] (
    [EXAMTIMESLOTID] CHAR (36)     NOT NULL,
    [NAME]           NVARCHAR (50) NOT NULL,
    [STARTTIME]      DATETIME      NOT NULL,
    [ENDTIME]        DATETIME      NOT NULL,
    [LASTCHANGEDBY]  CHAR (36)     NULL,
    [LASTCHANGEDON]  DATETIME      CONSTRAINT [DF_EXAMTIMESLOT_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]     INT           CONSTRAINT [DF_EXAMTIMESLOT_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EXAMTIMESLOT] PRIMARY KEY CLUSTERED ([EXAMTIMESLOTID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [EXAMTIMESLOT_IX_QUERY]
    ON [dbo].[EXAMTIMESLOT]([EXAMTIMESLOTID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_EXAMTIMESLOT_DELETE] ON  [dbo].[EXAMTIMESLOT]
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
			[deleted].[EXAMTIMESLOTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Exam Time Slot Deleted',
			'',
			'',
			'Exam Time Slot (' + [deleted].[NAME] + ')',
			'3D2EF58E-4283-432F-8901-947E7F748558',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_EXAMTIMESLOT_INSERT] ON [dbo].[EXAMTIMESLOT]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMTIMESLOT table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

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
			[inserted].[EXAMTIMESLOTID], 
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Exam Time Slot Added',
			'',
			'',
			'Exam Time Slot (' + [inserted].[NAME] + ')',
			'3D2EF58E-4283-432F-8901-947E7F748558',
			1,
			1,
			[inserted].[NAME]
    FROM	[inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_EXAMTIMESLOT_UPDATE] ON  [dbo].[EXAMTIMESLOT]
	AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMTIMESLOT table with USERS table.
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
			[inserted].[EXAMTIMESLOTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Exam Time Slot (' + [inserted].[NAME] + ')',
			'3D2EF58E-4283-432F-8901-947E7F748558',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMTIMESLOTID] = [inserted].[EXAMTIMESLOTID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[EXAMTIMESLOTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start time',
			FORMAT([deleted].[STARTTIME], 'hh:mm tt'),
			FORMAT([inserted].[STARTTIME], 'hh:mm tt'),
			'Exam Time Slot (' + [inserted].[NAME] + ')',
			'3D2EF58E-4283-432F-8901-947E7F748558',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMTIMESLOTID] = [inserted].[EXAMTIMESLOTID]
	WHERE	[deleted].[STARTTIME] <> [inserted].[STARTTIME]
	UNION ALL
	SELECT
			[inserted].[EXAMTIMESLOTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End time',
			FORMAT([deleted].[ENDTIME], 'hh:mm tt'),
			FORMAT([inserted].[ENDTIME], 'hh:mm tt'),
			'Exam Time Slot (' + [inserted].[NAME] + ')',
			'3D2EF58E-4283-432F-8901-947E7F748558',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMTIMESLOTID] = [inserted].[EXAMTIMESLOTID]
	WHERE	[deleted].[ENDTIME] <> [inserted].[ENDTIME]
END