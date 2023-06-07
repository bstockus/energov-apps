﻿CREATE TABLE [dbo].[DEPARTMENT] (
    [DEPARTMENTID]  CHAR (36)     NOT NULL,
    [NAME]          NVARCHAR (50) NOT NULL,
    [LASTCHANGEDBY] CHAR (36)     NULL,
    [LASTCHANGEDON] DATETIME      CONSTRAINT [DF_Department_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT           CONSTRAINT [DF_Department_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED ([DEPARTMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DEPARTMENT_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [DEPARTMENT_IX_QUERY]
    ON [dbo].[DEPARTMENT]([DEPARTMENTID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_DEPARTMENT_UPDATE] ON DEPARTMENT
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
			[inserted].[DEPARTMENTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Department (' + [inserted].[NAME] + ')',
			'AB6F1136-D3C8-490E-8ACD-C42316907FDC',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[DEPARTMENTID] = [inserted].[DEPARTMENTID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
END
GO


CREATE TRIGGER [TG_DEPARTMENT_INSERT] ON DEPARTMENT
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
			[inserted].[DEPARTMENTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Department Added',
			'',
			'',
			'Department (' + [inserted].[NAME] + ')',
			'AB6F1136-D3C8-490E-8ACD-C42316907FDC',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_DEPARTMENT_DELETE] ON DEPARTMENT
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
			[deleted].[DEPARTMENTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Department Deleted',
			'',
			'',
			'Department (' + [deleted].[NAME] + ')',
			'AB6F1136-D3C8-490E-8ACD-C42316907FDC',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END