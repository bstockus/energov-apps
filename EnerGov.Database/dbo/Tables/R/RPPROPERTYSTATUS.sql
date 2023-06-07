﻿CREATE TABLE [dbo].[RPPROPERTYSTATUS] (
    [RPPROPERTYSTATUSID]    CHAR (36)      NOT NULL,
    [NAME]                  NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [RPPROPERTYSYSSTATUSID] INT            NOT NULL,
    [LASTCHANGEDBY]         CHAR (36)      NULL,
    [LASTCHANGEDON]         DATETIME       CONSTRAINT [DF_RPPROPERTYSTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT            CONSTRAINT [DF_RPPROPERTYSTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RPPROPERTYREGSTATUS] PRIMARY KEY NONCLUSTERED ([RPPROPERTYSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPPROPERTYSTATUS_SYSSTATUS] FOREIGN KEY ([RPPROPERTYSYSSTATUSID]) REFERENCES [dbo].[RPPROPERTYSYSSTATUS] ([RPPROPERTYSYSSTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [RPPROPERTYSTATUS_IX_QUERY]
    ON [dbo].[RPPROPERTYSTATUS]([RPPROPERTYSTATUSID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_RPPROPERTYSTATUS_DELETE] ON  [dbo].[RPPROPERTYSTATUS]
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
			[deleted].[RPPROPERTYSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Property Status Deleted',
			'',
			'',
			'Property Status (' + [deleted].[NAME] + ')'
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_RPPROPERTYSTATUS_INSERT] ON [dbo].[RPPROPERTYSTATUS]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPPROPERTYSTATUS table with USERS table.
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
			[ADDITIONALINFO]
		)
	SELECT 
			[inserted].[RPPROPERTYSTATUSID], 
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Status Added',
			'',
			'',
			'Property Status (' + [inserted].[NAME] + ')'
    FROM	[inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_RPPROPERTYSTATUS_UPDATE] ON  [dbo].[RPPROPERTYSTATUS]
	AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPPROPERTYSTATUS table with USERS table.
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
			[inserted].[RPPROPERTYSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Status Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Property Status (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYSTATUSID] = [inserted].[RPPROPERTYSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT 
			[inserted].[RPPROPERTYSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Status Description',			
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Property Status (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYSTATUSID] = [inserted].[RPPROPERTYSTATUSID]	
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[RPPROPERTYSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Status System Status',			
			[RPPROPERTYSYSSTATUS_DELETED].[NAME],
			[RPPROPERTYSYSSTATUS_INSERTED].[NAME],
			'Property Status (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYSTATUSID] = [inserted].[RPPROPERTYSTATUSID]
			JOIN RPPROPERTYSYSSTATUS RPPROPERTYSYSSTATUS_DELETED WITH (NOLOCK) ON [deleted].[RPPROPERTYSYSSTATUSID] = [RPPROPERTYSYSSTATUS_DELETED].[RPPROPERTYSYSSTATUSID]
			JOIN RPPROPERTYSYSSTATUS RPPROPERTYSYSSTATUS_INSERTED WITH (NOLOCK) ON [inserted].[RPPROPERTYSYSSTATUSID] = [RPPROPERTYSYSSTATUS_INSERTED].[RPPROPERTYSYSSTATUSID]	
	WHERE	[deleted].[RPPROPERTYSYSSTATUSID] <> [inserted].[RPPROPERTYSYSSTATUSID]
END