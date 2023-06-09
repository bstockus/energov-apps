﻿CREATE TABLE [dbo].[MAILINGADDRESSTYPE] (
    [MAILINGADDRESSTYPEID]      CHAR (36)      NOT NULL,
    [MAILINGADDRESSTYPENAME]    NVARCHAR (30)  NOT NULL,
    [MAILINGADDRESSDESCRIPTION] NVARCHAR (MAX) NULL,
    [SYSTEMACTIONID]            CHAR (36)      NOT NULL,
    [ISDEFAULT]                 BIT            CONSTRAINT [DF_MailingAddressType_IsDefault] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]             CHAR (36)      NULL,
    [LASTCHANGEDON]             DATETIME       CONSTRAINT [DF_MAILINGADDRESSTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                INT            CONSTRAINT [DF_MAILINGADDRESSTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_MailingAddressType] PRIMARY KEY CLUSTERED ([MAILINGADDRESSTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MailAddrType_SysAction] FOREIGN KEY ([SYSTEMACTIONID]) REFERENCES [dbo].[SYSTEMACTION] ([SYSTEMACTIONID])
);


GO
CREATE NONCLUSTERED INDEX [MAILINGADDRESSTYPE_IX_QUERY]
    ON [dbo].[MAILINGADDRESSTYPE]([MAILINGADDRESSTYPEID] ASC, [MAILINGADDRESSTYPENAME] ASC);


GO

CREATE TRIGGER [TG_MAILINGADDRESSTYPE_DELETE] ON MAILINGADDRESSTYPE
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
			[deleted].[MAILINGADDRESSTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Mailing Address Type Deleted',
			'',
			'',
			'Mailing Address Type (' + [deleted].[MAILINGADDRESSTYPENAME] + ')',
			'F813C13D-CE95-4A28-A802-9C28BAADF57A',
			3,
			1,
			[deleted].[MAILINGADDRESSTYPENAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_MAILINGADDRESSTYPE_INSERT] ON [MAILINGADDRESSTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of MAILINGADDRESSTYPE table with USERS table.
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
			[inserted].[MAILINGADDRESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Mailing Address Type Added',
			'',
			'',
			'Mailing Address Type (' + [inserted].[MAILINGADDRESSTYPENAME] + ')',
			'F813C13D-CE95-4A28-A802-9C28BAADF57A',
			1,
			1,
			[inserted].[MAILINGADDRESSTYPENAME]
	FROM	[inserted]	
END
GO


CREATE TRIGGER [TG_MAILINGADDRESSTYPE_UPDATE] ON MAILINGADDRESSTYPE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of MAILINGADDRESSTYPE table with USERS table.
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
			[inserted].[MAILINGADDRESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'System Actions',
			[SYSTEMACTION_DELETED].[NAME],
			[SYSTEMACTION_INSERTED].[NAME],
			'Mailing Address Type (' + [inserted].[MAILINGADDRESSTYPENAME] + ')',
			'F813C13D-CE95-4A28-A802-9C28BAADF57A',
			2,
			1,
			[inserted].[MAILINGADDRESSTYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSTYPEID] = [inserted].[MAILINGADDRESSTYPEID]
			INNER JOIN SYSTEMACTION SYSTEMACTION_DELETED WITH (NOLOCK) ON [deleted].[SYSTEMACTIONID] = [SYSTEMACTION_DELETED].[SYSTEMACTIONID]
			INNER JOIN SYSTEMACTION SYSTEMACTION_INSERTED WITH (NOLOCK) ON [inserted].[SYSTEMACTIONID] = [SYSTEMACTION_INSERTED].[SYSTEMACTIONID]
	WHERE	[deleted].[SYSTEMACTIONID] <> [inserted].[SYSTEMACTIONID]

	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[MAILINGADDRESSTYPENAME],
			[inserted].[MAILINGADDRESSTYPENAME],
			'Mailing Address Type (' + [inserted].[MAILINGADDRESSTYPENAME] + ')',
			'F813C13D-CE95-4A28-A802-9C28BAADF57A',
			2,
			1,
			[inserted].[MAILINGADDRESSTYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSTYPEID] = [inserted].[MAILINGADDRESSTYPEID]
	WHERE	[deleted].[MAILINGADDRESSTYPENAME] <> [inserted].[MAILINGADDRESSTYPENAME]
	
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[MAILINGADDRESSDESCRIPTION], '[none]'),
			ISNULL([inserted].[MAILINGADDRESSDESCRIPTION], '[none]'),
			'Mailing Address Type (' + [inserted].[MAILINGADDRESSTYPENAME] + ')',
			'F813C13D-CE95-4A28-A802-9C28BAADF57A',
			2,
			1,
			[inserted].[MAILINGADDRESSTYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSTYPEID] = [inserted].[MAILINGADDRESSTYPEID]
	WHERE	ISNULL([deleted].[MAILINGADDRESSDESCRIPTION], '') <> ISNULL([inserted].[MAILINGADDRESSDESCRIPTION], '')

	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Flag',
			CASE WHEN [deleted].[ISDEFAULT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISDEFAULT] = 1 THEN 'Yes' ELSE 'No' END,
			'Mailing Address Type (' + [inserted].[MAILINGADDRESSTYPENAME] + ')',
			'F813C13D-CE95-4A28-A802-9C28BAADF57A',
			2,
			1,
			[inserted].[MAILINGADDRESSTYPENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSTYPEID] = [inserted].[MAILINGADDRESSTYPEID]
	WHERE	[deleted].[ISDEFAULT] <> [inserted].[ISDEFAULT]
END