﻿CREATE TABLE [dbo].[SERVICETASK] (
    [SERVICETASKID]                 INT             NOT NULL,
    [NAME]                          NVARCHAR (50)   NOT NULL,
    [DESCRIPTION]                   NVARCHAR (2000) NOT NULL,
    [ISMONITORINGSUPPORTED]         BIT             NOT NULL,
    [ISDETAILEDMONITORINGSUPPORTED] BIT             NOT NULL,
    [ISQUEUEDISPLAYSUPPORTED]       BIT             NOT NULL,
    [ISMONITORINGENABLED]           BIT             NOT NULL,
    [ISDETAILEDMONITORINGENABLED]   BIT             NOT NULL,
    [LASTCHANGEDON]                 DATETIME        CONSTRAINT [DEF_SERVICETASK_LASTCHANGEDON] DEFAULT (getutcdate()) NOT NULL,
    [LASTCHANGEDBY]                 CHAR (36)       NULL,
    [ROWVERSION]                    INT             CONSTRAINT [DEF_SERVICETASK_ROWVERSION] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_SERVICETASK] PRIMARY KEY CLUSTERED ([SERVICETASKID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE TRIGGER [dbo].[TG_SERVICETASK_UPDATE] ON [dbo].[SERVICETASK] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PMPERMITTYPE table with USERS table.
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
			CONVERT(CHAR(36),[inserted].[SERVICETASKID]),
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Monitoring Enabled Flag',
			CASE WHEN [deleted].[ISMONITORINGENABLED] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISMONITORINGENABLED] = 1 THEN 'Yes' ELSE 'No' END,
			'Service Task (' + [inserted].[NAME] + ')',
			'A76CF957-6507-44A6-A584-B382DC0C59B7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICETASKID] = [inserted].[SERVICETASKID]
	WHERE	[deleted].[ISMONITORINGENABLED] <> [inserted].[ISMONITORINGENABLED]
	UNION ALL

	SELECT
			CONVERT(CHAR(36),[inserted].[SERVICETASKID]),
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Detailed Monitoring Enabled Flag',
			CASE WHEN [deleted].[ISDETAILEDMONITORINGENABLED] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISDETAILEDMONITORINGENABLED] = 1 THEN 'Yes' ELSE 'No' END,
			'Service Task (' + [inserted].[NAME] + ')',
			'A76CF957-6507-44A6-A584-B382DC0C59B7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICETASKID] = [inserted].[SERVICETASKID]
	WHERE	[deleted].[ISDETAILEDMONITORINGENABLED] <> [inserted].[ISDETAILEDMONITORINGENABLED]


END