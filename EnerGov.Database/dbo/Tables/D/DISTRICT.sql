CREATE TABLE [dbo].[DISTRICT] (
    [DISTRICTID]    CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (100) NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_District_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_District_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_District] PRIMARY KEY CLUSTERED ([DISTRICTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DISTRICT_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [DISTRICT_IX_QUERY]
    ON [dbo].[DISTRICT]([DISTRICTID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_DISTRICT_UPDATE] ON DISTRICT
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
			[inserted].[DISTRICTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'District (' + [inserted].[NAME] + ')',
			'ABDF903E-C244-4CA4-9B17-FAFBB349EE02',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[DISTRICTID] = [inserted].[DISTRICTID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[DISTRICTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'District (' + [inserted].[NAME] + ')',
			'ABDF903E-C244-4CA4-9B17-FAFBB349EE02',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[DISTRICTID] = [inserted].[DISTRICTID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
END
GO


CREATE TRIGGER [TG_DISTRICT_INSERT] ON DISTRICT
   FOR INSERT
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
			[inserted].[DISTRICTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'District Added',
			'',
			'',
			'District (' + [inserted].[NAME] + ')',
			'ABDF903E-C244-4CA4-9B17-FAFBB349EE02',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_DISTRICT_DELETE] ON DISTRICT
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
			[deleted].[DISTRICTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'District Deleted',
			'',
			'',
			'District (' + [deleted].[NAME] + ')',
			'ABDF903E-C244-4CA4-9B17-FAFBB349EE02',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END