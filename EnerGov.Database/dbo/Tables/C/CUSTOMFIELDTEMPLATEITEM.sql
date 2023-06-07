﻿CREATE TABLE [dbo].[CUSTOMFIELDTEMPLATEITEM] (
    [GCUSTOMFIELDTEMPLATEITEM] CHAR (36)    NOT NULL,
    [FKGCUSTOMFIELDTEMPLATE]   CHAR (36)    NOT NULL,
    [SVALUE]                   VARCHAR (50) NOT NULL,
    [IORDER]                   INT          NOT NULL,
    [ISRETIRE]                 BIT          NOT NULL,
    CONSTRAINT [PK_CUSTOMFIELDTEMPLATEITEM] PRIMARY KEY CLUSTERED ([GCUSTOMFIELDTEMPLATEITEM] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CUSTOMFIELDTEMPLATEITEM_CFT] FOREIGN KEY ([FKGCUSTOMFIELDTEMPLATE]) REFERENCES [dbo].[CUSTOMFIELDTEMPLATE] ([GCUSTOMFIELDTEMPLATE])
);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTOMFIELDTEMPLATEITEM_FKGCUSTOMFIELDTEMPLATE]
    ON [dbo].[CUSTOMFIELDTEMPLATEITEM]([FKGCUSTOMFIELDTEMPLATE] ASC);


GO

CREATE TRIGGER [dbo].[TG_CUSTOMFIELDTEMPLATEITEM_DELETE]  
    ON  [dbo].[CUSTOMFIELDTEMPLATEITEM]
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
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
        [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE], 
        [CUSTOMFIELDTEMPLATE].[ROWVERSION],
        GETUTCDATE(),
        (SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),	
        'Custom Field Template Pick List Item Deleted',
        '',
        '',       
		'Custom Field Template (' + [CUSTOMFIELDTEMPLATE].[TEMPLATENAME] + '), Pick List Item (' + [deleted].[SVALUE] +')',
        '73C11018-1EAF-43EA-8121-8C3DF61B3862',
		3,
		0,
		[CUSTOMFIELDTEMPLATE].[TEMPLATENAME]
    FROM [deleted]
    INNER JOIN [CUSTOMFIELDTEMPLATE] ON [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE] = [deleted].[FKGCUSTOMFIELDTEMPLATE]
END
GO
CREATE TRIGGER [dbo].[TG_CUSTOMFIELDTEMPLATEITEM_UPDATE]
   ON  [dbo].[CUSTOMFIELDTEMPLATEITEM] 
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
        [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE], 
        [CUSTOMFIELDTEMPLATE].[ROWVERSION],
        GETUTCDATE(),
        [CUSTOMFIELDTEMPLATE].[LASTCHANGEDBY],	
        'Value',
        [deleted].[SVALUE],
        [inserted].[SVALUE],       
		'Custom Field Template (' + [CUSTOMFIELDTEMPLATE].[TEMPLATENAME] + '), Pick List Item (' + [inserted].[SVALUE] +')',
        '73C11018-1EAF-43EA-8121-8C3DF61B3862',
		2,
		0,
		[CUSTOMFIELDTEMPLATE].[TEMPLATENAME]
    FROM [deleted]
    INNER JOIN [inserted] ON [inserted].[GCUSTOMFIELDTEMPLATEITEM] = [deleted].[GCUSTOMFIELDTEMPLATEITEM] 
	INNER JOIN [CUSTOMFIELDTEMPLATE] ON [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE] = [inserted].[FKGCUSTOMFIELDTEMPLATE]
    WHERE [deleted].[SVALUE] <> [inserted].[SVALUE]
    UNION ALL
	SELECT 
        [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE], 
        [CUSTOMFIELDTEMPLATE].[ROWVERSION],
        GETUTCDATE(),
        [CUSTOMFIELDTEMPLATE].[LASTCHANGEDBY],	
        'Order',
        CAST([deleted].[IORDER] AS NVARCHAR(MAX)),
        CAST([inserted].[IORDER] AS NVARCHAR(MAX)),
		'Custom Field Template (' + [CUSTOMFIELDTEMPLATE].[TEMPLATENAME] + '), Pick List Item (' + [inserted].[SVALUE] +')',
        '73C11018-1EAF-43EA-8121-8C3DF61B3862',
		2,
		0,
		[CUSTOMFIELDTEMPLATE].[TEMPLATENAME]
    FROM [deleted]
    INNER JOIN [inserted] ON [inserted].[GCUSTOMFIELDTEMPLATEITEM] = [deleted].[GCUSTOMFIELDTEMPLATEITEM] 
    INNER JOIN [CUSTOMFIELDTEMPLATE] ON [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE] = [inserted].[FKGCUSTOMFIELDTEMPLATE]
    WHERE [deleted].[IORDER] <> [inserted].[IORDER]
    UNION ALL
	SELECT 
        [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE], 
        [CUSTOMFIELDTEMPLATE].[ROWVERSION],
        GETUTCDATE(),
        [CUSTOMFIELDTEMPLATE].[LASTCHANGEDBY],	
        'Retire Flag',
		CASE [deleted].[ISRETIRE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
		CASE [inserted].[ISRETIRE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
		'Custom Field Template (' + [CUSTOMFIELDTEMPLATE].[TEMPLATENAME] + '), Pick List Item (' + [inserted].[SVALUE] +')',
        '73C11018-1EAF-43EA-8121-8C3DF61B3862',
		2,
		0,
		[CUSTOMFIELDTEMPLATE].[TEMPLATENAME]
    FROM [deleted]
    INNER JOIN [inserted] ON [inserted].[GCUSTOMFIELDTEMPLATEITEM] = [deleted].[GCUSTOMFIELDTEMPLATEITEM] 
    INNER JOIN [CUSTOMFIELDTEMPLATE] ON [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE] = [inserted].[FKGCUSTOMFIELDTEMPLATE]
    WHERE [deleted].[ISRETIRE] <> [inserted].[ISRETIRE]
END
GO

CREATE TRIGGER [dbo].[TG_CUSTOMFIELDTEMPLATEITEM_INSERT]
   ON  [dbo].[CUSTOMFIELDTEMPLATEITEM]
   AFTER INSERT
AS 
BEGIN	
	SET NOCOUNT ON;	
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
        [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE], 
        [CUSTOMFIELDTEMPLATE].[ROWVERSION],
        GETUTCDATE(),
        [CUSTOMFIELDTEMPLATE].[LASTCHANGEDBY],	
        'Custom Field Template Pick List Item Added',
        '',
        '',       
		'Custom Field Template (' + [CUSTOMFIELDTEMPLATE].[TEMPLATENAME] + '), Pick List Item (' + [inserted].[SVALUE] +')',
        '73C11018-1EAF-43EA-8121-8C3DF61B3862',
		1,
		0,
		[CUSTOMFIELDTEMPLATE].[TEMPLATENAME]
    FROM [inserted]
	INNER JOIN [CUSTOMFIELDTEMPLATE] ON [CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE] = [inserted].[FKGCUSTOMFIELDTEMPLATE]
END