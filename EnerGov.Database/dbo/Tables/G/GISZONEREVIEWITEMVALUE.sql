﻿CREATE TABLE [dbo].[GISZONEREVIEWITEMVALUE] (
    [GISZONEREVIEWITEMVALUEID]   CHAR (36)     NOT NULL,
    [GISZONEREVIEWITEMMAPPINGID] CHAR (36)     NOT NULL,
    [VALUE]                      VARCHAR (250) NOT NULL,
    [PLITEMREVIEWZONEID]         CHAR (36)     NOT NULL,
    CONSTRAINT [PK_GISZONEREVIEWITEMVALUE] PRIMARY KEY CLUSTERED ([GISZONEREVIEWITEMVALUEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GISZONE_PLITEMREVIEWZONE] FOREIGN KEY ([PLITEMREVIEWZONEID]) REFERENCES [dbo].[PLITEMREVIEWZONE] ([PLITEMREVIEWZONEID]),
    CONSTRAINT [FK_GISZONE_REVIEWITEMMAPPING] FOREIGN KEY ([GISZONEREVIEWITEMMAPPINGID]) REFERENCES [dbo].[GISZONEREVIEWITEMMAPPING] ([GISZONEREVIEWITEMMAPPINGID])
);


GO
CREATE NONCLUSTERED INDEX [GISZONEREVIEWITEMVALUE_IX_GISZONEREVIEWITEMMAPPINGID]
    ON [dbo].[GISZONEREVIEWITEMVALUE]([GISZONEREVIEWITEMMAPPINGID] ASC);


GO

CREATE TRIGGER [dbo].[TG_GISZONEREVIEWITEMVALUE_UPDATE] ON  [dbo].[GISZONEREVIEWITEMVALUE]
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
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
			'GIS Value',
			CAST([deleted].[VALUE] AS NVARCHAR(MAX)),
			CAST([inserted].[VALUE] AS NVARCHAR(MAX)),			
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), GIS Value (' + [inserted].[VALUE] + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			2,
			0,
			[inserted].[VALUE]
	FROM	[deleted] JOIN [inserted] ON [deleted].[GISZONEREVIEWITEMMAPPINGID] = [inserted].[GISZONEREVIEWITEMMAPPINGID]
			INNER JOIN [GISZONEREVIEWITEMMAPPING] ON [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID] = [inserted].[GISZONEREVIEWITEMMAPPINGID]	
	WHERE	[deleted].[VALUE] <> [inserted].[VALUE]
	UNION ALL

	SELECT 
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
			'Mapped EnerGov Zone',
			[PLITEMREVIEWZONE_DELETED].[NAME],
			[PLITEMREVIEWZONE_INSERTED].[NAME],
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), GIS Value (' + [inserted].[VALUE] + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			2,
			0,
			[inserted].[VALUE]
	FROM	[deleted] JOIN [inserted] ON [deleted].[GISZONEREVIEWITEMMAPPINGID] = [inserted].[GISZONEREVIEWITEMMAPPINGID]
			INNER JOIN [GISZONEREVIEWITEMMAPPING] ON [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID] = [inserted].[GISZONEREVIEWITEMMAPPINGID]
			JOIN [PLITEMREVIEWZONE] PLITEMREVIEWZONE_INSERTED WITH (NOLOCK) ON [PLITEMREVIEWZONE_INSERTED].[PLITEMREVIEWZONEID] = [inserted].[PLITEMREVIEWZONEID]
			JOIN [PLITEMREVIEWZONE] PLITEMREVIEWZONE_DELETED WITH (NOLOCK) ON [PLITEMREVIEWZONE_DELETED].[PLITEMREVIEWZONEID] = [deleted].[PLITEMREVIEWZONEID]			
	WHERE	[deleted].[PLITEMREVIEWZONEID] <> [inserted].[PLITEMREVIEWZONEID]

END
GO

CREATE TRIGGER [TG_GISZONEREVIEWITEMVALUE_INSERT] ON [GISZONEREVIEWITEMVALUE]
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
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
			'Zone Review Item Mapping GIS Value Added',
			'',
			'',
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), GIS Value (' + [inserted].[VALUE] + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			1,
			0,
			[inserted].[VALUE]
	FROM	[inserted]
			INNER JOIN [GISZONEREVIEWITEMMAPPING] ON [inserted].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID]	
END
GO

CREATE TRIGGER [TG_GISZONEREVIEWITEMVALUE_DELETE] ON [GISZONEREVIEWITEMVALUE]
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
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Zone Review Item Mapping GIS Value Deleted',
			'',
			'',
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), GIS Value (' + [deleted].[VALUE] + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			3,
			0,
			[deleted].[VALUE]
	FROM	[deleted]	
			INNER JOIN [GISZONEREVIEWITEMMAPPING] ON [deleted].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID]	
END