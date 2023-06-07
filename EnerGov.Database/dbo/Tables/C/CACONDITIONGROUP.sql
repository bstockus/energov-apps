﻿CREATE TABLE [dbo].[CACONDITIONGROUP] (
    [CACONDITIONGROUPID]     CHAR (36) NOT NULL,
    [PARENTCONDITIONGROUPID] CHAR (36) NULL,
    [ISORGROUP]              BIT       CONSTRAINT [DF_Condition_IsOrGroup] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CAConditionGroup] PRIMARY KEY CLUSTERED ([CACONDITIONGROUPID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CAConditionGroup_Parent] FOREIGN KEY ([PARENTCONDITIONGROUPID]) REFERENCES [dbo].[CACONDITIONGROUP] ([CACONDITIONGROUPID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CACONDITIONGROUP_PARENTCONDITIONGROUPID]
    ON [dbo].[CACONDITIONGROUP]([PARENTCONDITIONGROUPID] ASC);


GO

CREATE TRIGGER [dbo].[TG_CACONDITIONGROUP_UPDATE] ON  [dbo].[CACONDITIONGROUP] 
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;	
	-- DECLARATION OF TABLE TYPE VARIABLE 
	DECLARE @CONDITIONGROUPIDS [RecordIDs]
	DECLARE @PARENTCONDITIONGROUP AS TABLE(TOPPARENTCONDITIONGROUPID CHAR(36),CONDITIONGROUPID CHAR(36))

	-- GET INSERTED CACONDITIONGROUPID 
	INSERT INTO @CONDITIONGROUPIDS
	SELECT [inserted].[CACONDITIONGROUPID] FROM [inserted]

	-- GET TOPPARENTID FOR CONDITION GROUP
	INSERT INTO @PARENTCONDITIONGROUP(TOPPARENTCONDITIONGROUPID,CONDITIONGROUPID)
	SELECT * FROM  [dbo].[GETTOPPARENTCONDITIONGROUPIDS](@CONDITIONGROUPIDS)

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
			[CAFEETEMPLATE].[CAFEETEMPLATEID],
			[CAFEETEMPLATE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEETEMPLATE].[LASTCHANGEDBY],
			'Is Or Group Flag',			
			(CASE  [deleted].[ISORGROUP] WHEN 1 THEN 'Yes' ELSE 'No' END),
			(CASE  [inserted].[ISORGROUP] WHEN 1 THEN 'Yes' ELSE 'No' END),
			'Fee Template (' + [CAFEETEMPLATE].[CAFEETEMPLATENAME] + '), Fee/Child Template (' + [CAFEETEMPLATEFEE].[FEENAME] +') Condition Group',
			'CCA2295B-072A-494B-9C11-91424F59BC16',
			2,
			0,
			[CAFEETEMPLATE].[CAFEETEMPLATENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CACONDITIONGROUPID] = [inserted].[CACONDITIONGROUPID]			
			INNER JOIN @PARENTCONDITIONGROUP AS [PARENTCONDITIONGROUP] ON [PARENTCONDITIONGROUP].[CONDITIONGROUPID] = [inserted].[CACONDITIONGROUPID]
			INNER JOIN [dbo].[CAFEETEMPLATEFEE] ON [PARENTCONDITIONGROUP].[TOPPARENTCONDITIONGROUPID] = [CAFEETEMPLATEFEE].[CACONDITIONGROUPID] 
			INNER JOIN [dbo].[CAFEETEMPLATE] ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [CAFEETEMPLATEFEE].[CAFEETEMPLATEID]	
	WHERE	[deleted].[ISORGROUP] <> [inserted].[ISORGROUP]
	UNION ALL
		SELECT 
			[CAFEETEMPLATE].[CAFEETEMPLATEID],
			[CAFEETEMPLATE].[ROWVERSION],
			GETUTCDATE(),
			[CAFEETEMPLATE].[LASTCHANGEDBY],
			'Is Or Group Flag',			
			(CASE  [deleted].[ISORGROUP] WHEN 1 THEN 'Yes' ELSE 'No' END),
			(CASE  [inserted].[ISORGROUP] WHEN 1 THEN 'Yes' ELSE 'No' END),
			'Fee Template (' + [CAFEETEMPLATE].[CAFEETEMPLATENAME] + '), Fee Template Discount (' + [CADISCOUNT].[NAME] +') Condition Group',
			'CCA2295B-072A-494B-9C11-91424F59BC16',
			2,
			0,
			[CAFEETEMPLATE].[CAFEETEMPLATENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CACONDITIONGROUPID] = [inserted].[CACONDITIONGROUPID]			
			INNER JOIN @PARENTCONDITIONGROUP AS [PARENTCONDITIONGROUP] ON [PARENTCONDITIONGROUP].[CONDITIONGROUPID] = [inserted].[CACONDITIONGROUPID]
			INNER JOIN [dbo].[CAFEETEMPLATEDISCOUNT] ON [PARENTCONDITIONGROUP].[TOPPARENTCONDITIONGROUPID] = [CAFEETEMPLATEDISCOUNT].[CACONDITIONGROUPID] 
			INNER JOIN [dbo].[CAFEETEMPLATE] ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEID]				
			INNER JOIN [dbo].[CADISCOUNT] ON [CADISCOUNT].[CADISCOUNTID] = [CAFEETEMPLATEDISCOUNT].[CADISCOUNTID] 
	WHERE	[deleted].[ISORGROUP] <> [inserted].[ISORGROUP]
END
GO

CREATE TRIGGER [dbo].[TG_CACONDITIONGROUP_INSERT] ON  [dbo].[CACONDITIONGROUP]
   AFTER INSERT
AS 
BEGIN	
	SET NOCOUNT ON;	
	-- DECLARATION OF TABLE TYPE VARIABLE 
	DECLARE @CONDITIONGROUPIDS [RecordIDs]
	DECLARE @PARENTCONDITIONGROUP AS TABLE(TOPPARENTCONDITIONGROUPID CHAR(36),CONDITIONGROUPID CHAR(36))

	-- GET INSERTED CACONDITIONGROUPID 
	INSERT INTO @CONDITIONGROUPIDS
	SELECT [inserted].[CACONDITIONGROUPID] FROM [inserted]

	-- GET TOPPARENTID FOR CONDITION GROUP
	INSERT INTO @PARENTCONDITIONGROUP(TOPPARENTCONDITIONGROUPID,CONDITIONGROUPID)
	SELECT * FROM  [dbo].[GETTOPPARENTCONDITIONGROUPIDS](@CONDITIONGROUPIDS)

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
        [CAFEETEMPLATE].[CAFEETEMPLATEID], 
        [CAFEETEMPLATE].[ROWVERSION],
        GETUTCDATE(),
        [CAFEETEMPLATE].[LASTCHANGEDBY],	
        'Fee Template, Fee/Child Template, Condition Group Added',
        '',
        '',       
		'Fee Template (' + [CAFEETEMPLATE].[CAFEETEMPLATENAME] + '), Fee/Child Template ('+[CAFEETEMPLATEFEE].[FEENAME]+'), Child Condition Group',
		'CCA2295B-072A-494B-9C11-91424F59BC16',
		1,
		0,
		[CAFEETEMPLATE].[CAFEETEMPLATENAME]
    FROM [inserted]
	INNER JOIN @PARENTCONDITIONGROUP AS [PARENTCONDITIONGROUP] ON [PARENTCONDITIONGROUP].[CONDITIONGROUPID] = [inserted].[CACONDITIONGROUPID]
	INNER JOIN [dbo].[CAFEETEMPLATEFEE] ON [PARENTCONDITIONGROUP].[TOPPARENTCONDITIONGROUPID] = [CAFEETEMPLATEFEE].[CACONDITIONGROUPID] 
	INNER JOIN [dbo].[CAFEETEMPLATE] ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [CAFEETEMPLATEFEE].[CAFEETEMPLATEID]
	UNION ALL 
	SELECT 
        [CAFEETEMPLATE].[CAFEETEMPLATEID], 
        [CAFEETEMPLATE].[ROWVERSION],
        GETUTCDATE(),
        [CAFEETEMPLATE].[LASTCHANGEDBY],	
        'Fee Template, Fee Template Discount, Condition Group Added',
        '',
        '',       
		'Fee Template (' + [CAFEETEMPLATE].[CAFEETEMPLATENAME] + '), Fee Template Discount (' + [CADISCOUNT].[NAME] +') Condition Group',
		'CCA2295B-072A-494B-9C11-91424F59BC16',
		1,
		0,
		[CAFEETEMPLATE].[CAFEETEMPLATENAME]
    FROM [inserted]
	INNER JOIN @PARENTCONDITIONGROUP AS [PARENTCONDITIONGROUP] ON [PARENTCONDITIONGROUP].[CONDITIONGROUPID] = [inserted].[CACONDITIONGROUPID]
	INNER JOIN [dbo].[CAFEETEMPLATEDISCOUNT] ON [PARENTCONDITIONGROUP].[TOPPARENTCONDITIONGROUPID] = [CAFEETEMPLATEDISCOUNT].[CACONDITIONGROUPID] 
	INNER JOIN [dbo].[CADISCOUNT] ON [CADISCOUNT].[CADISCOUNTID] = [CAFEETEMPLATEDISCOUNT].[CADISCOUNTID]
	INNER JOIN [dbo].[CAFEETEMPLATE] ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEID]
END
GO

CREATE TRIGGER [dbo].[TG_CACONDITIONGROUP_DELETE]  ON  [dbo].[CACONDITIONGROUP]
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;	
	-- DECLARATION OF TABLE TYPE VARIABLE 
	DECLARE @CONDITIONGROUPIDS [RecordIDs]
	DECLARE @PARENTCONDITIONGROUP AS TABLE(TOPPARENTCONDITIONGROUPID CHAR(36),CONDITIONGROUPID CHAR(36))

	-- GET INSERTED CACONDITIONGROUPID 
	INSERT INTO @CONDITIONGROUPIDS
	SELECT [deleted].[PARENTCONDITIONGROUPID] FROM [deleted]

	-- GET TOPPARENTID FOR CONDITION GROUP
	INSERT INTO @PARENTCONDITIONGROUP(TOPPARENTCONDITIONGROUPID,CONDITIONGROUPID)
	SELECT * FROM  [dbo].[GETTOPPARENTCONDITIONGROUPIDS](@CONDITIONGROUPIDS)

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
        [CAFEETEMPLATE].[CAFEETEMPLATEID], 
        [CAFEETEMPLATE].[ROWVERSION],
        GETUTCDATE(),
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
        'Fee Template, Fee/Child Template, Condition Group Deleted',
        '',
        '',       
		'Fee Template (' + [CAFEETEMPLATE].[CAFEETEMPLATENAME] + '), Fee/Child Template (' + [CAFEETEMPLATEFEE].[FEENAME] +') Condition Group',
		'CCA2295B-072A-494B-9C11-91424F59BC16',
		3,
		0,
		[CAFEETEMPLATE].[CAFEETEMPLATENAME]
    FROM [deleted]
	INNER JOIN @PARENTCONDITIONGROUP AS [PARENTCONDITIONGROUP] ON [PARENTCONDITIONGROUP].[CONDITIONGROUPID] = [deleted].[PARENTCONDITIONGROUPID]
	INNER JOIN [dbo].[CAFEETEMPLATEFEE] ON [PARENTCONDITIONGROUP].[TOPPARENTCONDITIONGROUPID] = [CAFEETEMPLATEFEE].[CACONDITIONGROUPID]
	INNER JOIN [dbo].[CAFEETEMPLATE] ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [CAFEETEMPLATEFEE].[CAFEETEMPLATEID]	
	
	UNION ALL 
	SELECT 
        [CAFEETEMPLATE].[CAFEETEMPLATEID], 
        [CAFEETEMPLATE].[ROWVERSION],
        GETUTCDATE(),
      (SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
        'Fee Template, Fee Template Discount, Condition Group Deleted',
        '',
        '',       
		'Fee Template (' + [CAFEETEMPLATE].[CAFEETEMPLATENAME] + '), Fee Template Discount (' + [CADISCOUNT].[NAME] +') Condition Group',
		'CCA2295B-072A-494B-9C11-91424F59BC16',
		3,
		0,
		[CAFEETEMPLATE].[CAFEETEMPLATENAME]
    FROM [deleted]
	INNER JOIN @PARENTCONDITIONGROUP AS [PARENTCONDITIONGROUP] ON [PARENTCONDITIONGROUP].[CONDITIONGROUPID] = [deleted].[PARENTCONDITIONGROUPID]
	INNER JOIN [dbo].[CAFEETEMPLATEDISCOUNT] ON [PARENTCONDITIONGROUP].[TOPPARENTCONDITIONGROUPID] = [CAFEETEMPLATEDISCOUNT].[CACONDITIONGROUPID] 	
	INNER JOIN [dbo].[CAFEETEMPLATE] ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEID]		
	INNER JOIN [dbo].[CADISCOUNT] ON [CADISCOUNT].[CADISCOUNTID] = [CAFEETEMPLATEDISCOUNT].[CADISCOUNTID] 
END