CREATE TABLE [dbo].[ROLES] (
    [SROLEGUID]     CHAR (36)     CONSTRAINT [DF_Roles_sRoleGUID] DEFAULT (newid()) NOT NULL,
    [ID]            NVARCHAR (25) NOT NULL,
    [SDESCRIPTION]  NVARCHAR (50) NULL,
    [LASTCHANGEDBY] CHAR (36)     NULL,
    [LASTCHANGEDON] DATETIME      CONSTRAINT [DF_ROLES_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT           CONSTRAINT [DF_ROLES_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([SROLEGUID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ROLES_IX_QUERY]
    ON [dbo].[ROLES]([SROLEGUID] ASC, [ID] ASC);


GO

CREATE TRIGGER [dbo].[TG_ROLES_DELETE] ON  [dbo].[ROLES]
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
			[deleted].[SROLEGUID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'User Role Deleted',
			'',
			'',
			'User Role (' + [deleted].[ID] + ')',
			'801F270F-912F-420A-91D6-82EBC3F351F3',
			3,
			1,
			[deleted].[ID]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_ROLES_UPDATE] ON  [dbo].[ROLES]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ROLES table with USERS table.
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
			[inserted].[SROLEGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Role Name',
			[deleted].[ID],
			[inserted].[ID],
			'User Role (' + [inserted].[ID] + ')',
			'801F270F-912F-420A-91D6-82EBC3F351F3',
			2,
			1,
			[inserted].[ID]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SROLEGUID] = [inserted].[SROLEGUID]			
	WHERE	[deleted].[ID] <> [inserted].[ID]
	UNION ALL

	SELECT 
			[inserted].[SROLEGUID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Role Description',
			ISNULL([deleted].[SDESCRIPTION],'[none]'),
			ISNULL([inserted].[SDESCRIPTION],'[none]'),			
			'User Role (' + [inserted].[ID] + ')',
			'801F270F-912F-420A-91D6-82EBC3F351F3',
			2,
			1,
			[inserted].[ID]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SROLEGUID] = [inserted].[SROLEGUID]			
	WHERE	ISNULL([deleted].[SDESCRIPTION], '') <> ISNULL([inserted].[SDESCRIPTION], '')

END
GO

CREATE TRIGGER [dbo].[TG_ROLES_INSERT] ON [dbo].[ROLES]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ROLES table with USERS table.
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
        [inserted].[SROLEGUID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'User Role Added',
        '',
        '',
        'User Role (' + [inserted].[ID] + ')',
		'801F270F-912F-420A-91D6-82EBC3F351F3',
		1,
		1,
		[inserted].[ID]
	FROM [inserted] 
END