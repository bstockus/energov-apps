CREATE TABLE [dbo].[IMINSPECTIONZONE] (
    [IMINSPECTIONZONEID] CHAR (36)       NOT NULL,
    [NAME]               NVARCHAR (50)   NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX)  NULL,
    [DEFAULTTRAVELTIME]  DECIMAL (18, 4) NULL,
    [LASTCHANGEDBY]      CHAR (36)       NULL,
    [LASTCHANGEDON]      DATETIME        CONSTRAINT [DF_IMINSPECTIONZONE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT             CONSTRAINT [DF_IMINSPECTIONZONE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMInspectorZone] PRIMARY KEY CLUSTERED ([IMINSPECTIONZONEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTIONZONE_IX_QUERY]
    ON [dbo].[IMINSPECTIONZONE]([IMINSPECTIONZONEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_IMINSPECTIONZONE_DELETE] ON IMINSPECTIONZONE
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
			[deleted].[IMINSPECTIONZONEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Zone Deleted',
			'',
			'',
			'Inspection Zone (' + [deleted].[NAME] + ')',
			'2D636DA0-23BC-4B8B-A8E2-346DD41BC267',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_IMINSPECTIONZONE_INSERT] ON IMINSPECTIONZONE
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;


	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONZONE table with USERS table.
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
			[inserted].[IMINSPECTIONZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Inspection Zone Added',
			'',
			'',
			'Inspection Zone (' + [inserted].[NAME] + ')',
			'2D636DA0-23BC-4B8B-A8E2-346DD41BC267',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_IMINSPECTIONZONE_UPDATE] ON IMINSPECTIONZONE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONZONE table with USERS table.
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
			[inserted].[IMINSPECTIONZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Inspection Zone (' + [inserted].[NAME] + ')',
			'2D636DA0-23BC-4B8B-A8E2-346DD41BC267',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONZONEID] = [inserted].[IMINSPECTIONZONEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Inspection Zone (' + [inserted].[NAME] + ')',
			'2D636DA0-23BC-4B8B-A8E2-346DD41BC267',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONZONEID] = [inserted].[IMINSPECTIONZONEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Travel Time',
			ISNULL(CONVERT(VARCHAR(20),[deleted].[DEFAULTTRAVELTIME]), '[none]'),
			ISNULL(CONVERT(VARCHAR(20),[inserted].[DEFAULTTRAVELTIME]), '[none]'),
			'Inspection Zone (' + [inserted].[NAME] + ')',
			'2D636DA0-23BC-4B8B-A8E2-346DD41BC267',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONZONEID] = [inserted].[IMINSPECTIONZONEID]
	WHERE	ISNULL(CONVERT(VARCHAR(20),[deleted].[DEFAULTTRAVELTIME]), '') <> ISNULL(CONVERT(VARCHAR(20),[inserted].[DEFAULTTRAVELTIME]), '') 
END