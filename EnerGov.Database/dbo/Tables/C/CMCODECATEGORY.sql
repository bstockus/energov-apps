﻿CREATE TABLE [dbo].[CMCODECATEGORY] (
    [CMCODECATEGORYID]   CHAR (36)      NOT NULL,
    [NAME]               NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX) NULL,
    [REPORTNAME]         NVARCHAR (100) NULL,
    [CMCODESYSTEMTYPEID] INT            DEFAULT ((1)) NULL,
    [LASTCHANGEDBY]      CHAR (36)      NULL,
    [LASTCHANGEDON]      DATETIME       CONSTRAINT [DF_CMCODECATEGORY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT            CONSTRAINT [DF_CMCODECATEGORY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CodeCategory] PRIMARY KEY CLUSTERED ([CMCODECATEGORYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CMCODECATEGORY_CMCODESYSTEMTYPE] FOREIGN KEY ([CMCODESYSTEMTYPEID]) REFERENCES [dbo].[CMCODESYSTEMTYPE] ([CMCODESYSTEMTYPEID]),
    CONSTRAINT [FK_CMCODECATEGORY_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO

CREATE TRIGGER [dbo].[TG_CMCODECATEGORY_DELETE]  
   ON  [dbo].[CMCODECATEGORY] 
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
			[deleted].[CMCODECATEGORYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Code Category Deleted',
			'',
			'',
			'Code Category (' + [deleted].[NAME] + ')',
			'F2BFB6FE-439F-48B0-978D-748BE8F5D52C',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_CMCODECATEGORY_INSERT] 
   ON  [dbo].[CMCODECATEGORY]
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
        [inserted].[CMCODECATEGORYID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Code Category Added',
        '',
        '',
        'Code Category (' + [inserted].[NAME] + ')',
		'F2BFB6FE-439F-48B0-978D-748BE8F5D52C',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted]
END
GO

CREATE TRIGGER [dbo].[TG_CMCODECATEGORY_UPDATE] 
   ON  [dbo].[CMCODECATEGORY] 
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
			[inserted].[CMCODECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Code Category (' + [inserted].[NAME] + ')',
			'F2BFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODECATEGORYID] = [inserted].[CMCODECATEGORYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[CMCODECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Code Category (' + [inserted].[NAME] + ')',
			'F2BFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODECATEGORYID] = [inserted].[CMCODECATEGORYID]	
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL

	SELECT
			[inserted].[CMCODECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Name',
			ISNULL([deleted].[REPORTNAME],'[none]'),
			ISNULL([inserted].[REPORTNAME],'[none]'),
			'Code Category (' + [inserted].[NAME] + ')',
			'F2BFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODECATEGORYID] = [inserted].[CMCODECATEGORYID]	
	WHERE	ISNULL([deleted].[REPORTNAME], '') <> ISNULL([inserted].[REPORTNAME], '')
	UNION ALL

	SELECT
			[inserted].[CMCODECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'System Type',
			ISNULL([CMCODESYSTEMTYPE_DELETED].[NAME],'[none]'),
			ISNULL([CMCODESYSTEMTYPE_INSERTED].[NAME],'[none]'),
			'Code Category (' + [inserted].[NAME] + ')',
			'F2BFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODECATEGORYID] = [inserted].[CMCODECATEGORYID]
			LEFT JOIN CMCODESYSTEMTYPE CMCODESYSTEMTYPE_DELETED WITH (NOLOCK) ON [deleted].CMCODESYSTEMTYPEID = [CMCODESYSTEMTYPE_DELETED].CMCODESYSTEMTYPEID
			LEFT JOIN CMCODESYSTEMTYPE CMCODESYSTEMTYPE_INSERTED WITH (NOLOCK) ON [inserted].CMCODESYSTEMTYPEID = [CMCODESYSTEMTYPE_INSERTED].CMCODESYSTEMTYPEID
	WHERE	ISNULL([deleted].[CMCODESYSTEMTYPEID], '') <> ISNULL([inserted].[CMCODESYSTEMTYPEID], '')
END