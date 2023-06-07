﻿CREATE TABLE [dbo].[IPASSESSMENTMILESTONE] (
    [IPASSESSMENTMILESTONEID] CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (100) NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [IPMILESTONETYPEID]       INT            NOT NULL,
    [ACTIVE]                  BIT            NOT NULL,
    [CONFIGUREFIELDID]        CHAR (36)      NULL,
    [MODULEID]                INT            NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_IPASSESSMENTMILESTONE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_IPASSESSMENTMILESTONE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IPASSESSMENTMILESTONE] PRIMARY KEY CLUSTERED ([IPASSESSMENTMILESTONEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IPAMILESTONE_MILESTONETYPE] FOREIGN KEY ([IPMILESTONETYPEID]) REFERENCES [dbo].[IPMILESTONETYPE] ([IPMILESTONETYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IPASSESSMENTMILESTONE_IX_QUERY]
    ON [dbo].[IPASSESSMENTMILESTONE]([IPASSESSMENTMILESTONEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_IPASSESSMENTMILESTONE_UPDATE] ON [dbo].[IPASSESSMENTMILESTONE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPASSESSMENTMILESTONE table with USERS table.
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
			[inserted].[IPASSESSMENTMILESTONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Assessment Milestone (' + [inserted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPASSESSMENTMILESTONEID] = [inserted].[IPASSESSMENTMILESTONEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[IPASSESSMENTMILESTONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Assessment Milestone (' + [inserted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPASSESSMENTMILESTONEID] = [inserted].[IPASSESSMENTMILESTONEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	UNION ALL

	SELECT
			[inserted].[IPASSESSMENTMILESTONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Milestone Type',
			[IPMILESTONETYPE_DELETED].[NAME],
			[IPMILESTONETYPE_INSERTED].[NAME],
			'Assessment Milestone (' + [inserted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPASSESSMENTMILESTONEID] = [inserted].[IPASSESSMENTMILESTONEID]
			JOIN IPMILESTONETYPE IPMILESTONETYPE_DELETED WITH (NOLOCK) ON [deleted].[IPMILESTONETYPEID] = [IPMILESTONETYPE_DELETED].[IPMILESTONETYPEID]
			JOIN IPMILESTONETYPE IPMILESTONETYPE_INSERTED WITH (NOLOCK) ON [inserted].[IPMILESTONETYPEID] = [IPMILESTONETYPE_INSERTED].[IPMILESTONETYPEID]
	WHERE	[deleted].[IPMILESTONETYPEID] <> [inserted].[IPMILESTONETYPEID]	
	UNION ALL

	SELECT
			[inserted].[IPASSESSMENTMILESTONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Assessment Milestone (' + [inserted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPASSESSMENTMILESTONEID] = [inserted].[IPASSESSMENTMILESTONEID]
	 WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL

	SELECT
			[inserted].[IPASSESSMENTMILESTONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Configurable Field',
			CASE 
				WHEN [deleted].[IPMILESTONETYPEID] = 1 OR [deleted].[IPMILESTONETYPEID] = 2 THEN [WFSTEP_DELETED].[NAME] 
				WHEN [deleted].[IPMILESTONETYPEID] = 3 OR [deleted].[IPMILESTONETYPEID] = 4 THEN [WFACTION_DELETED].[NAME] 
				ELSE '[none]'
				END,
			CASE 
				WHEN [inserted].[IPMILESTONETYPEID] = 1 OR [inserted].[IPMILESTONETYPEID] = 2 THEN [WFSTEP_INSERTED].[NAME] 
				WHEN [inserted].[IPMILESTONETYPEID] = 3 OR [inserted].[IPMILESTONETYPEID] = 4 THEN [WFACTION_INSERTED].[NAME]
				ELSE '[none]'
				END,
			'Assessment Milestone (' + [inserted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPASSESSMENTMILESTONEID] = [inserted].[IPASSESSMENTMILESTONEID]
			LEFT JOIN WFSTEP WFSTEP_DELETED WITH (NOLOCK) ON [deleted].[CONFIGUREFIELDID] = [WFSTEP_DELETED].[WFSTEPID]
			LEFT JOIN WFSTEP WFSTEP_INSERTED WITH (NOLOCK) ON [inserted].[CONFIGUREFIELDID] = [WFSTEP_INSERTED].[WFSTEPID]
			LEFT JOIN WFACTION WFACTION_DELETED WITH (NOLOCK) ON [deleted].[CONFIGUREFIELDID] = [WFACTION_DELETED].[WFACTIONID]
			LEFT JOIN WFACTION WFACTION_INSERTED WITH (NOLOCK) ON [inserted].[CONFIGUREFIELDID] = [WFACTION_INSERTED].[WFACTIONID]
	WHERE	ISNULL([deleted].[CONFIGUREFIELDID], '') <> ISNULL([inserted].[CONFIGUREFIELDID], '')
	UNION ALL
		
	SELECT
			[inserted].[IPASSESSMENTMILESTONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Module',
			CASE
				WHEN [deleted].[MODULEID] = 1 THEN 'Plan'
				WHEN [deleted].[MODULEID] = 2 THEN 'Permit' 
				ELSE '[none]'
			END,
			CASE
				WHEN [inserted].[MODULEID] = 1 THEN 'Plan'
				WHEN [inserted].[MODULEID] = 2 THEN 'Permit' 
				ELSE '[none]'
			END,
			'Assessment Milestone (' + [inserted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPASSESSMENTMILESTONEID] = [inserted].[IPASSESSMENTMILESTONEID]
	WHERE	ISNULL([deleted].[MODULEID],'') <> ISNULL([inserted].[MODULEID],'')		
END
GO


CREATE TRIGGER [dbo].[TG_IPASSESSMENTMILESTONE_INSERT] ON [dbo].[IPASSESSMENTMILESTONE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPASSESSMENTMILESTONE table with USERS table.
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
			[inserted].[IPASSESSMENTMILESTONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Assessment Milestone Added',
			'',
			'',
			'Assessment Milestone (' + [inserted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_IPASSESSMENTMILESTONE_DELETE] ON [dbo].[IPASSESSMENTMILESTONE]
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
			[deleted].[IPASSESSMENTMILESTONEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Assessment Milestone Deleted',
			'',
			'',
			'Assessment Milestone (' + [deleted].[NAME] + ')',
			'9F76A91E-3F35-4D54-ADDE-E74F3E0A178D',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END