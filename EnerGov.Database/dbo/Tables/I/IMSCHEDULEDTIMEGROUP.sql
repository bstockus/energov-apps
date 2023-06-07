CREATE TABLE [dbo].[IMSCHEDULEDTIMEGROUP] (
    [IMSCHEDULEDTIMEGROUPID] CHAR (36)     NOT NULL,
    [NAME]                   NVARCHAR (50) NOT NULL,
    [STARTTIME]              DATETIME      NOT NULL,
    [ENDTIME]                DATETIME      NOT NULL,
    [IVRNUMBER]              INT           NOT NULL,
    [LASTCHANGEDBY]          CHAR (36)     NULL,
    [LASTCHANGEDON]          DATETIME      CONSTRAINT [DF_IMSCHEDULEDTIMEGROUP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT           CONSTRAINT [DF_IMSCHEDULEDTIMEGROUP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMScheduledTimeGroup] PRIMARY KEY CLUSTERED ([IMSCHEDULEDTIMEGROUPID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IMSCHEDULEDTIMEGROUP_IX_QUERY]
    ON [dbo].[IMSCHEDULEDTIMEGROUP]([IMSCHEDULEDTIMEGROUPID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_IMSCHEDULEDTIMEGROUP_INSERT] ON IMSCHEDULEDTIMEGROUP
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;


	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMSCHEDULEDTIMEGROUP table with USERS table.
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
			[inserted].[IMSCHEDULEDTIMEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Inspection Time Type Added',
			'',
			'',
			'Inspection Time Type (' + [inserted].[NAME] + ')',
			'8C8B76F4-2416-4003-8C8E-7C24077C20B3',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO


CREATE TRIGGER [TG_IMSCHEDULEDTIMEGROUP_UPDATE] ON IMSCHEDULEDTIMEGROUP
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMSCHEDULEDTIMEGROUP table with USERS table.
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
			[inserted].[IMSCHEDULEDTIMEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Inspection Time Type (' + [inserted].[NAME] + ')',
			'8C8B76F4-2416-4003-8C8E-7C24077C20B3',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMSCHEDULEDTIMEGROUPID] = [inserted].[IMSCHEDULEDTIMEGROUPID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IMSCHEDULEDTIMEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start Time',
			CONVERT(NVARCHAR(MAX), [deleted].[STARTTIME]),
			CONVERT(NVARCHAR(MAX), [inserted].[STARTTIME]),
			'Inspection Time Type (' + [inserted].[NAME] + ')',
			'8C8B76F4-2416-4003-8C8E-7C24077C20B3',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMSCHEDULEDTIMEGROUPID] = [inserted].[IMSCHEDULEDTIMEGROUPID]
	WHERE	[deleted].[STARTTIME] <> [inserted].[STARTTIME]	
	UNION ALL
	SELECT
			[inserted].[IMSCHEDULEDTIMEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End Time',
			CONVERT(NVARCHAR(MAX), [deleted].[ENDTIME]),
			CONVERT(NVARCHAR(MAX), [inserted].[ENDTIME]),
			'Inspection Time Type (' + [inserted].[NAME] + ')',
			'8C8B76F4-2416-4003-8C8E-7C24077C20B3',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMSCHEDULEDTIMEGROUPID] = [inserted].[IMSCHEDULEDTIMEGROUPID]
	WHERE	[deleted].[ENDTIME] <> [inserted].[ENDTIME]
	UNION ALL
	SELECT
			[inserted].[IMSCHEDULEDTIMEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'IVR Number',
			CONVERT(NVARCHAR(MAX), [deleted].[IVRNUMBER]),
			CONVERT(NVARCHAR(MAX), [inserted].[IVRNUMBER]),
			'Inspection Time Type (' + [inserted].[NAME] + ')',
			'8C8B76F4-2416-4003-8C8E-7C24077C20B3',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMSCHEDULEDTIMEGROUPID] = [inserted].[IMSCHEDULEDTIMEGROUPID]
	WHERE	[deleted].[IVRNUMBER] <> [inserted].[IVRNUMBER]	
END
GO

CREATE TRIGGER [TG_IMSCHEDULEDTIMEGROUP_DELETE] ON IMSCHEDULEDTIMEGROUP
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
			[deleted].[IMSCHEDULEDTIMEGROUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Time Type Deleted',
			'',
			'',
			'Inspection Time Type (' + [deleted].[NAME] + ')',
			'8C8B76F4-2416-4003-8C8E-7C24077C20B3',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END