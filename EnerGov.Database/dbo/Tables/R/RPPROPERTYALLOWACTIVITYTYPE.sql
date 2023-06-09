﻿CREATE TABLE [dbo].[RPPROPERTYALLOWACTIVITYTYPE] (
    [RPPROPERTYALLOWACTIVITYTYPEID] CHAR (36) NOT NULL,
    [RPPROPERTYACTIVITYTYPEID]      CHAR (36) NOT NULL,
    [RPPROPERTYTYPEID]              CHAR (36) NOT NULL,
    CONSTRAINT [PK_RPPROPERTYALLOWACTIVITYTYPE] PRIMARY KEY NONCLUSTERED ([RPPROPERTYALLOWACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPPROPALLOWACTTYPE_TYPE] FOREIGN KEY ([RPPROPERTYACTIVITYTYPEID]) REFERENCES [dbo].[RPPROPERTYACTIVITYTYPE] ([RPPROPERTYACTIVITYTYPEID]),
    CONSTRAINT [FK_RPPROPALLOWTYPE_TYPE] FOREIGN KEY ([RPPROPERTYTYPEID]) REFERENCES [dbo].[RPPROPERTYTYPE] ([RPPROPERTYTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [RPPROPERTYALLOWACTIVITYTYPE_IX_RPPROPERTYTYPEID]
    ON [dbo].[RPPROPERTYALLOWACTIVITYTYPE]([RPPROPERTYTYPEID] ASC);


GO

CREATE TRIGGER [TG_RPPROPERTYALLOWACTIVITYTYPE_DELETE] ON [RPPROPERTYALLOWACTIVITYTYPE]
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
		[ADDITIONALINFO]
	)
	SELECT
			[RPPROPERTYTYPE].[RPPROPERTYTYPEID],
			[RPPROPERTYTYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Property Type Allowed Activity Deleted',
			'',
			'',
			'Property Type (' + [RPPROPERTYTYPE].[NAME] + '), Allowed Activity (' + [RPPROPERTYACTIVITYTYPE].[NAME] + ')'
	FROM	[deleted]	
	INNER JOIN [RPPROPERTYTYPE] ON [deleted].[RPPROPERTYTYPEID] = [RPPROPERTYTYPE].[RPPROPERTYTYPEID]	
	INNER JOIN [RPPROPERTYACTIVITYTYPE] WITH (NOLOCK) ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [RPPROPERTYACTIVITYTYPE].[RPPROPERTYACTIVITYTYPEID]
END
GO
CREATE TRIGGER [TG_RPPROPERTYALLOWACTIVITYTYPE_INSERT] ON [RPPROPERTYALLOWACTIVITYTYPE]
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
		[ADDITIONALINFO]
	)
	SELECT 
			[RPPROPERTYTYPE].[RPPROPERTYTYPEID],
			[RPPROPERTYTYPE].[ROWVERSION],
			GETUTCDATE(),
			[RPPROPERTYTYPE].[LASTCHANGEDBY],
			'Property Type Allowed Activity Added',
			'',
			'',
			'Property Type (' + [RPPROPERTYTYPE].[NAME] + '), Allowed Activity (' + [RPPROPERTYACTIVITYTYPE].[NAME] + ')'
	FROM	[inserted]
	INNER JOIN [RPPROPERTYTYPE] ON [inserted].[RPPROPERTYTYPEID] = [RPPROPERTYTYPE].[RPPROPERTYTYPEID]	
	INNER JOIN [RPPROPERTYACTIVITYTYPE] WITH (NOLOCK) ON [inserted].[RPPROPERTYACTIVITYTYPEID] = [RPPROPERTYACTIVITYTYPE].[RPPROPERTYACTIVITYTYPEID]
END