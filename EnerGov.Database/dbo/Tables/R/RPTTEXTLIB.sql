CREATE TABLE [dbo].[RPTTEXTLIB] (
    [RPTTEXTLIBID]  CHAR (36)       NOT NULL,
    [TEXTNAME]      NVARCHAR (50)   NOT NULL,
    [REPORTTEXT]    NVARCHAR (4000) NULL,
    [ACTIVE]        BIT             DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDBY] CHAR (36)       NULL,
    [LASTCHANGEDON] DATETIME        CONSTRAINT [DF_RPTTEXTLIB_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT             CONSTRAINT [DF_RPTTEXTLIB_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RPTTEXTLIB] PRIMARY KEY CLUSTERED ([RPTTEXTLIBID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [RPTTEXTLIB_IX_QUERY]
    ON [dbo].[RPTTEXTLIB]([RPTTEXTLIBID] ASC, [TEXTNAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_RPTTEXTLIB_UPDATE] ON [dbo].[RPTTEXTLIB]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTTEXTLIB table with USERS table.
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
			[inserted].[RPTTEXTLIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Text',
			ISNULL([deleted].[REPORTTEXT],'[none]'),
			ISNULL([inserted].[REPORTTEXT],'[none]'),
			'Report Text Library (' + [inserted].[TEXTNAME] + ')',
			'45B8F192-8E67-40E1-BDDE-200BFC57B283',
			2,
			1,
			[inserted].[TEXTNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTTEXTLIBID] = [inserted].[RPTTEXTLIBID]
	WHERE	ISNULL([deleted].[REPORTTEXT], '') <> ISNULL([inserted].[REPORTTEXT], '')
END
GO

CREATE TRIGGER [dbo].[TG_RPTTEXTLIB_INSERT] ON [dbo].[RPTTEXTLIB]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTTEXTLIB table with USERS table.
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
			[inserted].[RPTTEXTLIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Text Library Added',
			'',
			'',
			'Report Text Library (' + [inserted].[TEXTNAME] + ')',
			'45B8F192-8E67-40E1-BDDE-200BFC57B283',
			1,
			1,
			[inserted].[TEXTNAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_RPTTEXTLIB_DELETE] ON [dbo].[RPTTEXTLIB]
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
			[deleted].[RPTTEXTLIBID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Report Text Library Deleted',
			'',
			'',
			'Report Text Library (' + [deleted].[TEXTNAME] + ')',
			'45B8F192-8E67-40E1-BDDE-200BFC57B283',
			3,
			1,
			[deleted].[TEXTNAME]
	FROM	[deleted]
END