CREATE TABLE [dbo].[IMCHECKLIST] (
    [IMCHECKLISTID]         CHAR (36)      NOT NULL,
    [IMCHECKLISTCATEGORYID] CHAR (36)      NULL,
    [NAME]                  NVARCHAR (50)  NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]         CHAR (36)      NULL,
    [LASTCHANGEDON]         DATETIME       CONSTRAINT [DF_IMCHECKLIST_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT            CONSTRAINT [DF_IMCHECKLIST_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMChecklist] PRIMARY KEY CLUSTERED ([IMCHECKLISTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IMChecklist_IMCheckListCategory] FOREIGN KEY ([IMCHECKLISTCATEGORYID]) REFERENCES [dbo].[IMCHECKLISTCATEGORY] ([IMCHECKLISTCATEGORYID])
);


GO
CREATE NONCLUSTERED INDEX [IMCHECKLIST_IX_QUERY]
    ON [dbo].[IMCHECKLIST]([IMCHECKLISTID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_IMCHECKLIST_DELETE] ON IMCHECKLIST
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
			[deleted].[IMCHECKLISTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Checklist Item Deleted',
			'',
			'',
			'Inspection Checklist Item (' + ISNULL([deleted].[NAME], '[none]') + ')',
			'C4B088B7-4E28-4248-9F13-4AAC707D90ED',
			3,
			1,
			ISNULL([deleted].[NAME], '[none]')
	FROM	[deleted]
END
GO


CREATE TRIGGER [TG_IMCHECKLIST_UPDATE] ON IMCHECKLIST
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMCHECKLIST table with USERS table.
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
			[inserted].[IMCHECKLISTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Category',
			ISNULL([IMCHECKLISTCATEGORY_DELETED].[NAME], '[none]'),
			ISNULL([IMCHECKLISTCATEGORY_INSERTED].[NAME], '[none]'),
			'Inspection Checklist Item (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'C4B088B7-4E28-4248-9F13-4AAC707D90ED',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMCHECKLISTID] = [inserted].[IMCHECKLISTID]
			LEFT JOIN IMCHECKLISTCATEGORY IMCHECKLISTCATEGORY_DELETED WITH (NOLOCK) ON [deleted].[IMCHECKLISTCATEGORYID] = IMCHECKLISTCATEGORY_DELETED.[IMCHECKLISTCATEGORYID]
			LEFT JOIN IMCHECKLISTCATEGORY IMCHECKLISTCATEGORY_INSERTED WITH (NOLOCK) ON [inserted].[IMCHECKLISTCATEGORYID] = IMCHECKLISTCATEGORY_INSERTED.[IMCHECKLISTCATEGORYID]
	WHERE	ISNULL([deleted].IMCHECKLISTCATEGORYID, '') <> ISNULL([inserted].IMCHECKLISTCATEGORYID, '')

	UNION ALL
	SELECT
			[inserted].[IMCHECKLISTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			ISNULL([deleted].[NAME], '[none]'),
			ISNULL([inserted].[NAME], '[none]'),
			'Inspection Checklist Item (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'C4B088B7-4E28-4248-9F13-4AAC707D90ED',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMCHECKLISTID] = [inserted].[IMCHECKLISTID]
	WHERE	ISNULL([deleted].[NAME], '') <> ISNULL([inserted].[NAME], '')
	
	UNION ALL
	SELECT
			[inserted].[IMCHECKLISTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION], '[none]'),
			ISNULL([inserted].[DESCRIPTION], '[none]'),
			'Inspection Checklist Item (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'C4B088B7-4E28-4248-9F13-4AAC707D90ED',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMCHECKLISTID] = [inserted].[IMCHECKLISTID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
END
GO

CREATE TRIGGER [TG_IMCHECKLIST_INSERT] ON IMCHECKLIST
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;


	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMCHECKLIST table with USERS table.
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
			[inserted].[IMCHECKLISTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Inspection Checklist Item Added',
			'',
			'',
			'Inspection Checklist Item (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'C4B088B7-4E28-4248-9F13-4AAC707D90ED',
			1,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[inserted]	
END