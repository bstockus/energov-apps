CREATE TABLE [dbo].[IMINSPECTORTYPE] (
    [IMINSPECTORTYPEID] CHAR (36)      NOT NULL,
    [SNAME]             NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]     CHAR (36)      NULL,
    [LASTCHANGEDON]     DATETIME       CONSTRAINT [DF_IMINSPECTORTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]        INT            CONSTRAINT [DF_IMINSPECTORTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMInspectorType] PRIMARY KEY CLUSTERED ([IMINSPECTORTYPEID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTORTYPE_IX_QUERY]
    ON [dbo].[IMINSPECTORTYPE]([IMINSPECTORTYPEID] ASC, [SNAME] ASC);


GO

CREATE TRIGGER [TG_IMINSPECTORTYPE_DELETE] ON IMINSPECTORTYPE
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
			[deleted].[IMINSPECTORTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspector Type Deleted',
			'',
			'',
			'Inspector Type (' + [deleted].[SNAME] + ')',
			'C145443E-4168-4AEA-BD6F-056366BE2652',
			3,
			1,
			[deleted].[SNAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_IMINSPECTORTYPE_UPDATE] ON IMINSPECTORTYPE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTORTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON [USERS].[SUSERGUID] = [inserted].[LASTCHANGEDBY]
		WHERE [inserted].[LASTCHANGEDBY] IS NOT NULL AND [USERS].[SUSERGUID] IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table IMINSPECTORTYPE', 16, 0);
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
			[inserted].[IMINSPECTORTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[SNAME],
			[inserted].[SNAME],
			'Inspector Type (' + [inserted].[SNAME] + ')',
			'C145443E-4168-4AEA-BD6F-056366BE2652',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTORTYPEID] = [inserted].[IMINSPECTORTYPEID]
	WHERE	[deleted].[SNAME] <> [inserted].[SNAME]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTORTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Inspector Type (' + [inserted].[SNAME] + ')',
			'C145443E-4168-4AEA-BD6F-056366BE2652',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTORTYPEID] = [inserted].[IMINSPECTORTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
END
GO


CREATE TRIGGER [TG_IMINSPECTORTYPE_INSERT] ON IMINSPECTORTYPE
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTORTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON [USERS].[SUSERGUID] = [inserted].[LASTCHANGEDBY]
		WHERE [inserted].[LASTCHANGEDBY] IS NOT NULL AND [USERS].[SUSERGUID] IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table IMINSPECTORTYPE', 16, 0);
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
			[inserted].[IMINSPECTORTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Inspector Type Added',
			'',
			'',
			'Inspector Type (' + [inserted].[SNAME] + ')',
			'C145443E-4168-4AEA-BD6F-056366BE2652',
			1,
			1,
			[inserted].[SNAME]
	FROM	[inserted]	
END