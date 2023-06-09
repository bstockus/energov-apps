﻿CREATE TABLE [dbo].[CMCODECASEHOLDTYPECONTACTTYPEREF] (
    [CMCODECASEHOLDTYPECONTACTTYPEID] CHAR (36) NOT NULL,
    [CMCODECASEHOLDTYPEID]            CHAR (36) NOT NULL,
    [CMCODECASECONTACTTYPEID]         CHAR (36) NOT NULL,
    [ACTIVE]                          BIT       CONSTRAINT [DF_CMCODECASEHOLDTYPECONTACTTYPEREF_ACTIVE] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CMCODECASEHOLDTYPECONTACTTYPEREF] PRIMARY KEY CLUSTERED ([CMCODECASEHOLDTYPECONTACTTYPEID] ASC),
    CONSTRAINT [FK_CMCODECASEHOLDTYPECONTACTTYPEREF_COTYPE] FOREIGN KEY ([CMCODECASECONTACTTYPEID]) REFERENCES [dbo].[CMCODECASECONTACTTYPE] ([CMCODECASECONTACTTYPEID]),
    CONSTRAINT [FK_CMCODECASEHOLDTYPECONTACTTYPEREF_HOTYPE] FOREIGN KEY ([CMCODECASEHOLDTYPEID]) REFERENCES [dbo].[CMCODECASEHOLDTYPEREF] ([CMCODECASEHOLDTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CMCODECASEHOLDTYPECONTACTTYPEREF_CMCODECASEHOLDTYPEID]
    ON [dbo].[CMCODECASEHOLDTYPECONTACTTYPEREF]([CMCODECASEHOLDTYPEID] ASC);


GO

CREATE TRIGGER [dbo].[TG_CMCODECASEHOLDTYPECONTACTTYPEREF_DELETED]
    ON [dbo].[CMCODECASEHOLDTYPECONTACTTYPEREF]
    AFTER DELETE
AS
BEGIN
    SET NoCount ON
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
        [CMCASETYPE].[CMCASETYPEID], 
        [CMCASETYPE].[ROWVERSION],
        GETUTCDATE(),
        [CMCASETYPE].[LASTCHANGEDBY],	
        'Code Case Hold TYPE Contact Type Deleted',
        CASE [deleted].[ACTIVE] WHEN 1 THEN 'Enabled' WHEN 0 THEN 'Disabled'  ELSE '[none]' END,
		'',
		'Code Case Type (' + [CMCASETYPE].[NAME] + '), Hold Type Name (' + [HOLDTYPESETUPS].[NAME] +'), Contact Type Name (' + CMCODECASECONTACTTYPE.[NAME] +')'
     FROM [deleted]
		INNER JOIN CMCODECASEHOLDTYPEREF ON CMCODECASEHOLDTYPEREF.CMCODECASEHOLDTYPEID = [deleted].CMCODECASEHOLDTYPEID
		INNER JOIN CMCASETYPE ON CMCASETYPE.CMCASETYPEID=CMCODECASEHOLDTYPEREF.CMCASETYPEID
		INNER JOIN HOLDTYPESETUPS WITH (NOLOCK) ON HOLDTYPESETUPS.HOLDSETUPID = CMCODECASEHOLDTYPEREF.HOLDSETUPID
		INNER JOIN CMCODECASECONTACTTYPE WITH (NOLOCK) ON CMCODECASECONTACTTYPE.CMCODECASECONTACTTYPEID = [deleted].CMCODECASECONTACTTYPEID
END
GO

CREATE TRIGGER [dbo].[TG_CMCODECASEHOLDTYPECONTACTTYPEREF_UPDATE]
   ON  [dbo].[CMCODECASEHOLDTYPECONTACTTYPEREF] 
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
		[ADDITIONALINFO]
    )
	SELECT 
			[CMCASETYPE].[CMCASETYPEID],
			[CMCASETYPE].[ROWVERSION],
			GETUTCDATE(),
			[CMCASETYPE].[LASTCHANGEDBY],
			'Code Case Hold Type Contact Type',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Enabled' WHEN 0 THEN 'Disabled'  ELSE '[none]' END,			
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Enabled' WHEN 0 THEN 'Disabled'  ELSE '[none]' END,						
			'Code Case Type (' + [CMCASETYPE].[NAME] + '), Hold Type Name (' + [HOLDTYPESETUPS].[NAME] +'), Contact Type Name (' + CMCODECASECONTACTTYPE.[NAME] +')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCODECASEHOLDTYPEID = [inserted].CMCODECASEHOLDTYPEID
			INNER JOIN CMCODECASEHOLDTYPEREF ON CMCODECASEHOLDTYPEREF.[CMCODECASEHOLDTYPEID] = [inserted].CMCODECASEHOLDTYPEID
			INNER JOIN CMCASETYPE ON CMCASETYPE.CMCASETYPEID = CMCODECASEHOLDTYPEREF.CMCASETYPEID
			INNER JOIN HOLDTYPESETUPS WITH (NOLOCK) ON HOLDTYPESETUPS.HOLDSETUPID = CMCODECASEHOLDTYPEREF.[HOLDSETUPID]
			INNER JOIN CMCODECASECONTACTTYPE WITH (NOLOCK) ON CMCODECASECONTACTTYPE.CMCODECASECONTACTTYPEID = [inserted].CMCODECASECONTACTTYPEID
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]	
END
GO

CREATE TRIGGER [dbo].[TG_CMCODECASEHOLDTYPECONTACTTYPEREF_INSERT]
    ON [dbo].[CMCODECASEHOLDTYPECONTACTTYPEREF]
    AFTER INSERT
AS
BEGIN
    SET NoCount ON
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
        [CMCASETYPE].[CMCASETYPEID], 
        [CMCASETYPE].[ROWVERSION],
        GETUTCDATE(),
        [CMCASETYPE].[LASTCHANGEDBY],	
        'Code Case Hold TYPE Contact Type Added',
        '',
        CASE [inserted].[ACTIVE] WHEN 1 THEN 'Enabled' WHEN 0 THEN 'Disabled'  ELSE '[none]' END,
		'Code Case Type (' + [CMCASETYPE].[NAME] + '), Hold Type Name (' + [HOLDTYPESETUPS].[NAME] +'), Contact Type Name (' + CMCODECASECONTACTTYPE.[NAME] +')'
     FROM [inserted]
		INNER JOIN CMCODECASEHOLDTYPEREF ON CMCODECASEHOLDTYPEREF.CMCODECASEHOLDTYPEID = [inserted].CMCODECASEHOLDTYPEID
		INNER JOIN CMCASETYPE ON CMCASETYPE.CMCASETYPEID=CMCODECASEHOLDTYPEREF.CMCASETYPEID
		INNER JOIN HOLDTYPESETUPS WITH (NOLOCK) ON HOLDTYPESETUPS.HOLDSETUPID = CMCODECASEHOLDTYPEREF.HOLDSETUPID
		INNER JOIN CMCODECASECONTACTTYPE WITH (NOLOCK) ON CMCODECASECONTACTTYPE.CMCODECASECONTACTTYPEID = [inserted].CMCODECASECONTACTTYPEID
END