﻿CREATE TABLE [dbo].[PLCORRECTIONTYPECATEGORY] (
    [PLCORRECTIONTYPECATEGORYID] CHAR (36)      NOT NULL,
    [NAME]                       NVARCHAR (250) NOT NULL,
    [DESCRIPTION]                NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]              CHAR (36)      NULL,
    [LASTCHANGEDON]              DATETIME       CONSTRAINT [DF_PLCORRECTIONTYPECATEGORY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                 INT            CONSTRAINT [DF_PLCORRECTIONTYPECATEGORY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLCORRECTIONTYPECATEGORY] PRIMARY KEY CLUSTERED ([PLCORRECTIONTYPECATEGORYID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [PLCORRECTIONTYPECATEGORY_IX_QUERY]
    ON [dbo].[PLCORRECTIONTYPECATEGORY]([PLCORRECTIONTYPECATEGORYID] ASC, [NAME] ASC);


GO



CREATE TRIGGER [TG_PLCORRECTIONTYPECATEGORY_INSERT] ON [PLCORRECTIONTYPECATEGORY]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLCORRECTIONTYPECATEGORY table with USERS table.
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
		[ADDITIONALINFO]
    )

	SELECT
			[inserted].[PLCORRECTIONTYPECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Review Correction Type Category Added',
			'',
			'',
			'Review Correction Type Category (' + [inserted].[NAME] + ')'
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_PLCORRECTIONTYPECATEGORY_UPDATE] ON [PLCORRECTIONTYPECATEGORY]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLCORRECTIONTYPECATEGORY table with USERS table.
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
		[ADDITIONALINFO]
    )

	SELECT
			[inserted].[PLCORRECTIONTYPECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Review Correction Type Category Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Review Correction Type Category (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLCORRECTIONTYPECATEGORYID] = [inserted].[PLCORRECTIONTYPECATEGORYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[PLCORRECTIONTYPECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Review Correction Type Category Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Review Correction Type Category (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLCORRECTIONTYPECATEGORYID] = [inserted].[PLCORRECTIONTYPECATEGORYID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
END
GO

CREATE TRIGGER [TG_PLCORRECTIONTYPECATEGORY_DELETE] ON [PLCORRECTIONTYPECATEGORY]
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
		[ADDITIONALINFO]
    )

	SELECT
			[deleted].[PLCORRECTIONTYPECATEGORYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Review Correction Type Category Deleted',
			'',
			'',
			'Review Correction Type Category (' + [deleted].[NAME] + ')'
	FROM	[deleted]
END