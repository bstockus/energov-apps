﻿CREATE TABLE [dbo].[IMINSPECTIONCATEGORYXREF] (
    [IMINSPECTIONCATEGORYXREFID] CHAR (36) NOT NULL,
    [IMINSPECTIONCATEGORYID]     CHAR (36) NOT NULL,
    [IMINSPECTIONTYPEGROUPID]    CHAR (36) NOT NULL,
    CONSTRAINT [PK_IMINSPECTIONCATEGORYXREF] PRIMARY KEY CLUSTERED ([IMINSPECTIONCATEGORYXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_INSPCATEGXREF_INSPCATEGID] FOREIGN KEY ([IMINSPECTIONCATEGORYID]) REFERENCES [dbo].[IMINSPECTIONCATEGORY] ([IMINSPECTIONCATEGORYID]),
    CONSTRAINT [FK_INSPCATXREF_INSPTYPEGRPID] FOREIGN KEY ([IMINSPECTIONTYPEGROUPID]) REFERENCES [dbo].[IMINSPECTIONTYPEGROUP] ([IMINSPECTIONTYPEGROUPID])
);


GO

CREATE TRIGGER [TG_IMINSPECTIONCATEGORYXREF_INSERT] ON [IMINSPECTIONCATEGORYXREF]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

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
			[IMINSPECTIONCATEGORY].[IMINSPECTIONCATEGORYID],
			[IMINSPECTIONCATEGORY].[ROWVERSION],
			GETUTCDATE(),
			[IMINSPECTIONCATEGORY].[LASTCHANGEDBY],
			'Inspection Category Inspection Group Added',
			'',
			'',
			'Inspection Category (' + [IMINSPECTIONCATEGORY].[NAME] + '), Inspection Group (' + [IMINSPECTIONTYPEGROUP].[NAME] + ')',
			'F699FF97-BDF1-414D-B30D-0BB2E72EED75',
			1,
			0,
			[IMINSPECTIONTYPEGROUP].[NAME]
	FROM	[inserted]
	INNER JOIN [IMINSPECTIONCATEGORY] ON [inserted].[IMINSPECTIONCATEGORYID] = [IMINSPECTIONCATEGORY].[IMINSPECTIONCATEGORYID]
	INNER JOIN [IMINSPECTIONTYPEGROUP] ON [IMINSPECTIONTYPEGROUP].[IMINSPECTIONTYPEGROUPID] = [inserted].[IMINSPECTIONTYPEGROUPID]
END
GO


CREATE TRIGGER [TG_IMINSPECTIONCATEGORYXREF_DELETE] ON [IMINSPECTIONCATEGORYXREF]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON

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
			[IMINSPECTIONCATEGORY].[IMINSPECTIONCATEGORYID],
			[IMINSPECTIONCATEGORY].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Category Inspection Group Deleted',
			'',
			'',
			'Inspection Category (' + [IMINSPECTIONCATEGORY].[NAME] + '), Inspection Group (' + [IMINSPECTIONTYPEGROUP].[NAME] + ')',
			'F699FF97-BDF1-414D-B30D-0BB2E72EED75',
			3,
			0,
			[IMINSPECTIONTYPEGROUP].[NAME]
	FROM	[deleted]	
	INNER JOIN [IMINSPECTIONCATEGORY] ON [IMINSPECTIONCATEGORY].[IMINSPECTIONCATEGORYID] = [deleted].[IMINSPECTIONCATEGORYID]
	INNER JOIN [IMINSPECTIONTYPEGROUP] ON [deleted].[IMINSPECTIONTYPEGROUPID] = [IMINSPECTIONTYPEGROUP].[IMINSPECTIONTYPEGROUPID]
END