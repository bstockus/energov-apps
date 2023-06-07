﻿CREATE TABLE [dbo].[IMINSPECTIONSTATUS] (
    [IMINSPECTIONSTATUSID]       CHAR (36)      NOT NULL,
    [STATUSNAME]                 NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                NVARCHAR (MAX) NULL,
    [INDICATESSUCCESS]           BIT            NOT NULL,
    [IMINSPECTIONSTATUSENTITYID] CHAR (36)      NULL,
    [REINSPECTIONFLAG]           BIT            CONSTRAINT [DF_IMInspectionStatus_ReInspectionFlag] DEFAULT ((0)) NOT NULL,
    [INVIOLATIONFLAG]            BIT            CONSTRAINT [DF_IMInspectionStatus_InViolationFlag] DEFAULT ((0)) NOT NULL,
    [OUTOFVIOLATIONFLAG]         BIT            CONSTRAINT [DF_IMInspectionStatus_OutOfViolationFlag] DEFAULT ((0)) NOT NULL,
    [EXTEND_EXPIRE_DATE]         BIT            DEFAULT ((1)) NOT NULL,
    [SCHEDULEDFLAG]              BIT            DEFAULT ((0)) NOT NULL,
    [WAITFLAG]                   BIT            DEFAULT ((0)) NOT NULL,
    [PARTIALPASS]                BIT            DEFAULT ((0)) NOT NULL,
    [CANCELLEDFLAG]              BIT            CONSTRAINT [DF_IMInspectionStatus_CancelledFlag] DEFAULT ((0)) NOT NULL,
    [DESCRIPTION_SPANISH]        NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]              CHAR (36)      NULL,
    [LASTCHANGEDON]              DATETIME       CONSTRAINT [DF_IMINSPECTIONSTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                 INT            CONSTRAINT [DF_IMINSPECTIONSTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMInspectionStatus] PRIMARY KEY CLUSTERED ([IMINSPECTIONSTATUSID] ASC),
    CONSTRAINT [FK_IMInspectionStatus_IMInspectionStatusEntity] FOREIGN KEY ([IMINSPECTIONSTATUSENTITYID]) REFERENCES [dbo].[IMINSPECTIONSTATUSENTITY] ([IMINSPECTIONSTATUSENTITYID])
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTIONSTATUS_IX_QUERY]
    ON [dbo].[IMINSPECTIONSTATUS]([IMINSPECTIONSTATUSID] ASC, [STATUSNAME] ASC);


GO

CREATE TRIGGER [TG_IMINSPECTIONSTATUS_UPDATE]
	ON IMINSPECTIONSTATUS
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONSTATUS table with USERS table.
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
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[STATUSNAME],
			[inserted].[STATUSNAME],
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[STATUSNAME] <> [inserted].[STATUSNAME]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Indicates Success Flag',
			CASE WHEN [deleted].[INDICATESSUCCESS] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[INDICATESSUCCESS] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[INDICATESSUCCESS] <> [inserted].[INDICATESSUCCESS]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Entity Name',
			ISNULL([DELETED_IMINSPECTIONSTATUSENTITY].[NAME],'[none]'),
			ISNULL([INSERTED_IMINSPECTIONSTATUSENTITY].[NAME],'[none]'),
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			LEFT OUTER JOIN [dbo].[IMINSPECTIONSTATUSENTITY] AS [INSERTED_IMINSPECTIONSTATUSENTITY] WITH (NOLOCK) ON [inserted].[IMINSPECTIONSTATUSENTITYID]= [INSERTED_IMINSPECTIONSTATUSENTITY].IMINSPECTIONSTATUSENTITYID
			LEFT OUTER JOIN [dbo].[IMINSPECTIONSTATUSENTITY] AS [DELETED_IMINSPECTIONSTATUSENTITY] WITH (NOLOCK) ON [inserted].[IMINSPECTIONSTATUSENTITYID]= [DELETED_IMINSPECTIONSTATUSENTITY] .IMINSPECTIONSTATUSENTITYID
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	ISNULL([deleted].[IMINSPECTIONSTATUSENTITYID], '') <> ISNULL([inserted].[IMINSPECTIONSTATUSENTITYID], '')	
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Re-Inspection Flag',
			CASE WHEN [deleted].[REINSPECTIONFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[REINSPECTIONFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[REINSPECTIONFLAG] <> [inserted].[REINSPECTIONFLAG]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'In-Violation Flag',
			CASE WHEN [deleted].[INVIOLATIONFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[INVIOLATIONFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[INVIOLATIONFLAG] <> [inserted].[INVIOLATIONFLAG]	
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Out Of Violation Flag',
			CASE WHEN [deleted].[OUTOFVIOLATIONFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[OUTOFVIOLATIONFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[OUTOFVIOLATIONFLAG] <> [inserted].[OUTOFVIOLATIONFLAG]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Extend Expire Date Flag',
			CASE WHEN [deleted].[EXTEND_EXPIRE_DATE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[EXTEND_EXPIRE_DATE] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[EXTEND_EXPIRE_DATE] <> [inserted].[EXTEND_EXPIRE_DATE]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Scheduled Flag',
			CASE WHEN [deleted].[SCHEDULEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[SCHEDULEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[SCHEDULEDFLAG] <> [inserted].[SCHEDULEDFLAG]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Wait Flag',
			CASE WHEN [deleted].[WAITFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[WAITFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[WAITFLAG] <> [inserted].[WAITFLAG]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Partial Pass Flag',
			CASE WHEN [deleted].[PARTIALPASS] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[PARTIALPASS] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[PARTIALPASS] <> [inserted].[PARTIALPASS]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cancelled Flag',
			CASE WHEN [deleted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	[deleted].[CANCELLEDFLAG] <> [inserted].[CANCELLEDFLAG]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description Spanish',
			ISNULL([deleted].[DESCRIPTION_SPANISH],'[none]'),
			ISNULL([inserted].[DESCRIPTION_SPANISH],'[none]'),
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			2,
			0,
			[inserted].[STATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONSTATUSID] = [inserted].[IMINSPECTIONSTATUSID]
			INNER JOIN IMINSPECTIONSTATUSENTITY ON [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID] = [inserted].[IMINSPECTIONSTATUSENTITYID]
	WHERE	ISNULL([deleted].[DESCRIPTION_SPANISH], '') <> ISNULL([inserted].[DESCRIPTION_SPANISH], '')	
END
GO

CREATE TRIGGER [TG_IMINSPECTIONSTATUS_INSERT] ON IMINSPECTIONSTATUS
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONSTATUS table with USERS table.
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
			[inserted].[IMINSPECTIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Inspection Status Entity Inspection Status Added',
			'',
			'',
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [inserted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			1,
			0,
			[inserted].[STATUSNAME]
	FROM	[inserted]	
	INNER JOIN IMINSPECTIONSTATUSENTITY ON [inserted].[IMINSPECTIONSTATUSENTITYID] = [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID]
END
GO

CREATE TRIGGER [TG_IMINSPECTIONSTATUS_DELETE] ON IMINSPECTIONSTATUS
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
			[deleted].[IMINSPECTIONSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Status Entity Inspection Status Deleted',
			'',
			'',
			'Inspection Status Entity ('+ [IMINSPECTIONSTATUSENTITY].[NAME] +'), Inspection Status (' + [deleted].[STATUSNAME] + ')',
			'87FA7EE4-639C-4496-ABF7-217A877850A3',
			3,
			0,
			[deleted].[STATUSNAME]
	FROM	[deleted]
	INNER JOIN IMINSPECTIONSTATUSENTITY ON [deleted].[IMINSPECTIONSTATUSENTITYID] = [IMINSPECTIONSTATUSENTITY].[IMINSPECTIONSTATUSENTITYID]
END