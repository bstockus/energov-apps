CREATE TABLE [dbo].[TXRPTPERIOD] (
    [TXRPTPERIODID]       CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (250) NULL,
    [CUSTOMFIELDLAYOUTID] CHAR (36)      NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_TXRPTPERIOD_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_TXRPTPERIOD_RowVersion] DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([TXRPTPERIODID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TxRptPeriod_CustomField] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);


GO
CREATE NONCLUSTERED INDEX [TXRPTPERIOD_IX_QUERY]
    ON [dbo].[TXRPTPERIOD]([TXRPTPERIODID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_TXRPTPERIOD_INSERT] ON [dbo].[TXRPTPERIOD]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of TXRPTPERIOD table with USERS table.
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
			[inserted].[TXRPTPERIODID], 
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Tax Report Period Added',
			'',
			'',
			'Tax Report Period (' + [inserted].[NAME] + ')',
			'B7C8A708-08CF-4D6A-A4ED-21CDF9151E45',
			1,
			1,
			[inserted].[NAME]
    FROM	[inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_TXRPTPERIOD_UPDATE] ON  [dbo].[TXRPTPERIOD]
	AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of TXRPTPERIOD table with USERS table.
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
			[inserted].[TXRPTPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Tax Report Period (' + [inserted].[NAME] + ')',
			'B7C8A708-08CF-4D6A-A4ED-21CDF9151E45',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TXRPTPERIODID] = [inserted].[TXRPTPERIODID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT 
			[inserted].[TXRPTPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',			
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Tax Report Period (' + [inserted].[NAME] + ')',
			'B7C8A708-08CF-4D6A-A4ED-21CDF9151E45',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TXRPTPERIODID] = [inserted].[TXRPTPERIODID]	
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[TXRPTPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'Tax Report Period (' + [inserted].[NAME] + ')',
			'B7C8A708-08CF-4D6A-A4ED-21CDF9151E45',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TXRPTPERIODID] = [inserted].[TXRPTPERIODID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID], '') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID], '')
END
GO


CREATE TRIGGER [dbo].[TG_TXRPTPERIOD_DELETE] ON  [dbo].[TXRPTPERIOD]
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
			[deleted].[TXRPTPERIODID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Tax Report Period Deleted',
			'',
			'',
			'Tax Report Period (' + [deleted].[NAME] + ')',
			'B7C8A708-08CF-4D6A-A4ED-21CDF9151E45',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END