﻿CREATE TABLE [dbo].[COLICENSECERTIFICATIONTYPE] (
    [COSIMPLELICCERTTYPEID]      CHAR (36)      NOT NULL,
    [NAME]                       NVARCHAR (255) NOT NULL,
    [SUBJECTTOLICENSEVALIDATION] BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]              CHAR (36)      NULL,
    [LASTCHANGEDON]              DATETIME       CONSTRAINT [DF_COLICENSECERTIFICATIONTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                 INT            CONSTRAINT [DF_COLICENSECERTIFICATIONTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_COSimpleLicCertType] PRIMARY KEY CLUSTERED ([COSIMPLELICCERTTYPEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_CERTIFICATIONTYPE_SUBJECTTOVALIDATION]
    ON [dbo].[COLICENSECERTIFICATIONTYPE]([SUBJECTTOLICENSEVALIDATION] ASC);


GO

CREATE TRIGGER [dbo].[TG_COLICENSECERTIFICATIONTYPE_DELETE] ON [dbo].[COLICENSECERTIFICATIONTYPE]
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
			[deleted].[COSIMPLELICCERTTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Certification Type Deleted',
			'',
			'',
			'Certification Type (' + [deleted].[NAME] + ')',
			'45F218A9-C018-4C83-9CA4-AC0538CA1BBE',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_COLICENSECERTIFICATIONTYPE_INSERT] ON [dbo].[COLICENSECERTIFICATIONTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of COLICENSECERTIFICATIONTYPE table with USERS table.
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
			[inserted].[COSIMPLELICCERTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Certification Type Added',
			'',
			'',
			'Certification Type (' + [inserted].[NAME] + ')',
			'45F218A9-C018-4C83-9CA4-AC0538CA1BBE',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END
GO

CREATE TRIGGER [dbo].[TG_COLICENSECERTIFICATIONTYPE_UPDATE] ON [dbo].[COLICENSECERTIFICATIONTYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of COLICENSECERTIFICATIONTYPE table with USERS table.
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
			[inserted].[COSIMPLELICCERTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Certification Type (' + [inserted].[NAME] + ')',
			'45F218A9-C018-4C83-9CA4-AC0538CA1BBE',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[COSIMPLELICCERTTYPEID] = [inserted].[COSIMPLELICCERTTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[COSIMPLELICCERTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Subject to State Validation Flag',
			CASE [deleted].[SUBJECTTOLICENSEVALIDATION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SUBJECTTOLICENSEVALIDATION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Certification Type (' + [inserted].[NAME] + ')',
			'45F218A9-C018-4C83-9CA4-AC0538CA1BBE',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[COSIMPLELICCERTTYPEID] = [inserted].[COSIMPLELICCERTTYPEID]
	 WHERE	[deleted].[SUBJECTTOLICENSEVALIDATION] <> [inserted].[SUBJECTTOLICENSEVALIDATION]	
END