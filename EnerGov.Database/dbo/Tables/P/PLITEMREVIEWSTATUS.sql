CREATE TABLE [dbo].[PLITEMREVIEWSTATUS] (
    [PLITEMREVIEWSTATUSID]     CHAR (36)     NOT NULL,
    [NAME]                     NVARCHAR (50) NOT NULL,
    [SUCCESSFLAG]              BIT           CONSTRAINT [DF_PLItemReviewStatus_Success] DEFAULT ((0)) NOT NULL,
    [FAILUREFLAG]              BIT           CONSTRAINT [DF_PLItemReviewStatus_Failure] DEFAULT ((0)) NOT NULL,
    [SHOWCOMMENTSINCAP]        BIT           CONSTRAINT [DF_PLITEMREVIEWSTATUS_CAP_CMN] DEFAULT ((0)) NOT NULL,
    [SHOWRECOMMENDATIONSINCAP] BIT           CONSTRAINT [DF_PLITEMREVIEWSTATUS_CAP_RCM] DEFAULT ((0)) NOT NULL,
    [SHOWCORRECTIONSINCAP]     BIT           CONSTRAINT [DF_PLITEMREVIEWSTATUS_CAP_CRC] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]            CHAR (36)     NULL,
    [LASTCHANGEDON]            DATETIME      CONSTRAINT [DF_PLITEMREVIEWSTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT           CONSTRAINT [DF_PLITEMREVIEWSTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLItemReviewStatus] PRIMARY KEY CLUSTERED ([PLITEMREVIEWSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [CK_PLItemReviewStatus] CHECK (NOT ([SuccessFlag]=[FailureFlag] AND [SuccessFlag]=(1)))
);


GO
CREATE NONCLUSTERED INDEX [PLITEMREVIEWSTATUS_IX_QUERY]
    ON [dbo].[PLITEMREVIEWSTATUS]([PLITEMREVIEWSTATUSID] ASC, [NAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_PLITEMREVIEWSTATUS_DELETE] ON [dbo].[PLITEMREVIEWSTATUS]
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
			[deleted].[PLITEMREVIEWSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Item Review Status Deleted',
			'',
			'',
			'Item Review Status (' + [deleted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_PLITEMREVIEWSTATUS_UPDATE] ON [dbo].[PLITEMREVIEWSTATUS] 
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
			[inserted].[PLITEMREVIEWSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Item Review Status (' + [inserted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWSTATUSID] = [inserted].[PLITEMREVIEWSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Success Flag',
			CASE [deleted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Status (' + [inserted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWSTATUSID] = [inserted].[PLITEMREVIEWSTATUSID]
	WHERE	[deleted].[SUCCESSFLAG] <> [inserted].[SUCCESSFLAG]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Failure Flag',
			CASE [deleted].[FAILUREFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[FAILUREFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Status (' + [inserted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWSTATUSID] = [inserted].[PLITEMREVIEWSTATUSID]
	WHERE	[deleted].[FAILUREFLAG] <> [inserted].[FAILUREFLAG]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Display Comments Flag',
			CASE [deleted].[SHOWCOMMENTSINCAP] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SHOWCOMMENTSINCAP] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Status (' + [inserted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWSTATUSID] = [inserted].[PLITEMREVIEWSTATUSID]
	WHERE	[deleted].[SHOWCOMMENTSINCAP] <> [inserted].[SHOWCOMMENTSINCAP]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Display Recommendations Flag',
			CASE [deleted].[SHOWRECOMMENDATIONSINCAP] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SHOWRECOMMENDATIONSINCAP] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Status (' + [inserted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWSTATUSID] = [inserted].[PLITEMREVIEWSTATUSID]
	WHERE	[deleted].[SHOWRECOMMENDATIONSINCAP] <> [inserted].[SHOWRECOMMENDATIONSINCAP]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Display Corrections Flag',
			CASE [deleted].[SHOWCORRECTIONSINCAP] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SHOWCORRECTIONSINCAP] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Item Review Status (' + [inserted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWSTATUSID] = [inserted].[PLITEMREVIEWSTATUSID]
	WHERE	[deleted].[SHOWCORRECTIONSINCAP] <> [inserted].[SHOWCORRECTIONSINCAP]
END
GO
CREATE TRIGGER [dbo].[TG_PLITEMREVIEWSTATUS_INSERT] ON [dbo].[PLITEMREVIEWSTATUS]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLITEMREVIEWSTATUS table with USERS table.
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
			[inserted].[PLITEMREVIEWSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Item Review Status Added',
			'',
			'',
			'Item Review Status (' + [inserted].[NAME] + ')',
			'85CD2E32-F163-4EF9-8C6D-C9628580C568',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END