﻿CREATE TABLE [dbo].[GISZONETOREVIEWITEMDESIG] (
    [GISZONETOREVIEWITEMDESIGID] CHAR (36) NOT NULL,
    [GISZONEREVIEWITEMVALUEID]   CHAR (36) NOT NULL,
    [USERID]                     CHAR (36) NOT NULL,
    [PLITEMREVIEWTYPEID]         CHAR (36) NOT NULL,
    CONSTRAINT [PK_GISZONETOREVIEWITEMDESIG] PRIMARY KEY CLUSTERED ([GISZONETOREVIEWITEMDESIGID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GISZONE_PLITEMREVIEWTYPE] FOREIGN KEY ([PLITEMREVIEWTYPEID]) REFERENCES [dbo].[PLITEMREVIEWTYPE] ([PLITEMREVIEWTYPEID]),
    CONSTRAINT [FK_GISZONE_REVIEWITEMVALUE] FOREIGN KEY ([GISZONEREVIEWITEMVALUEID]) REFERENCES [dbo].[GISZONEREVIEWITEMVALUE] ([GISZONEREVIEWITEMVALUEID]),
    CONSTRAINT [FK_GISZONE_USERS] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [GISZONETOREVIEWITEMDESIG_IX_QUERY]
    ON [dbo].[GISZONETOREVIEWITEMDESIG]([GISZONETOREVIEWITEMDESIGID] ASC);


GO

CREATE TRIGGER [dbo].[TG_GISZONETOREVIEWITEMDESIG_UPDATE] ON [dbo].[GISZONETOREVIEWITEMDESIG]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT			
			[GISZONEREVIEWITEMMAPPING_INSERTED].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING_INSERTED].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING_INSERTED].[LASTCHANGEDBY],
			'Data Source',
			[GISZONEREVIEWITEMMAPPING_DELETED].[SOURCENAME],
			[GISZONEREVIEWITEMMAPPING_INSERTED].[SOURCENAME],
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING_INSERTED].[SOURCENAME] + '), Zone Reviewer (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			2,
			0,
			[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONETOREVIEWITEMDESIGID] = [inserted].[GISZONETOREVIEWITEMDESIGID]
			JOIN [GISZONEREVIEWITEMVALUE] GISZONEREVIEWITEMVALUE_INSERTED WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE_INSERTED].[GISZONEREVIEWITEMVALUEID] = [inserted].[GISZONEREVIEWITEMVALUEID]			
			JOIN [GISZONEREVIEWITEMVALUE] GISZONEREVIEWITEMVALUE_DELETED WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE_DELETED].[GISZONEREVIEWITEMVALUEID] = [deleted].[GISZONEREVIEWITEMVALUEID]			
			JOIN [GISZONEREVIEWITEMMAPPING] GISZONEREVIEWITEMMAPPING_INSERTED WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING_INSERTED].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMVALUE_INSERTED].[GISZONEREVIEWITEMMAPPINGID]
			JOIN [GISZONEREVIEWITEMMAPPING] GISZONEREVIEWITEMMAPPING_DELETED WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING_DELETED].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMVALUE_DELETED].[GISZONEREVIEWITEMMAPPINGID]			
	        JOIN [USERS] WITH (NOLOCK) ON [inserted].[USERID] = USERS.SUSERGUID
	WHERE	[GISZONEREVIEWITEMVALUE_DELETED].[GISZONEREVIEWITEMVALUEID] <> [GISZONEREVIEWITEMVALUE_INSERTED].[GISZONEREVIEWITEMVALUEID]
	UNION ALL

	SELECT			
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
			'EnerGov Zone',
			[PLITEMREVIEWZONE_DELETED].[NAME],
			[PLITEMREVIEWZONE_INSERTED].[NAME],			
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), Zone Reviewer (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			2,
			0,
			[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONETOREVIEWITEMDESIGID] = [inserted].[GISZONETOREVIEWITEMDESIGID]
			JOIN [GISZONEREVIEWITEMVALUE] GISZONEREVIEWITEMVALUE_INSERTED WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE_INSERTED].[GISZONEREVIEWITEMVALUEID] = [inserted].[GISZONEREVIEWITEMVALUEID]			
			JOIN [GISZONEREVIEWITEMVALUE] GISZONEREVIEWITEMVALUE_DELETED WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE_DELETED].[GISZONEREVIEWITEMVALUEID] = [deleted].[GISZONEREVIEWITEMVALUEID]
			JOIN [GISZONEREVIEWITEMMAPPING] AS [GISZONEREVIEWITEMMAPPING] WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMVALUE_INSERTED].[GISZONEREVIEWITEMMAPPINGID]
			JOIN [PLITEMREVIEWZONE] PLITEMREVIEWZONE_INSERTED WITH (NOLOCK) ON [PLITEMREVIEWZONE_INSERTED].[PLITEMREVIEWZONEID] = [GISZONEREVIEWITEMVALUE_INSERTED].[PLITEMREVIEWZONEID]
			JOIN [PLITEMREVIEWZONE] PLITEMREVIEWZONE_DELETED WITH (NOLOCK) ON [PLITEMREVIEWZONE_DELETED].[PLITEMREVIEWZONEID] = [GISZONEREVIEWITEMVALUE_DELETED].[PLITEMREVIEWZONEID]			
	        JOIN [USERS] WITH (NOLOCK) ON [inserted].[USERID] = USERS.SUSERGUID
	WHERE	[PLITEMREVIEWZONE_DELETED].[PLITEMREVIEWZONEID] <> [PLITEMREVIEWZONE_INSERTED].[PLITEMREVIEWZONEID]
	UNION ALL

	SELECT			
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
			'Review Item',
			[PLITEMREVIEWTYPE_DELETED].[NAME],
			[PLITEMREVIEWTYPE_INSERTED].[NAME],
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), Zone Reviewer (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			2,
			0,
			[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONETOREVIEWITEMDESIGID] = [inserted].[GISZONETOREVIEWITEMDESIGID]
			JOIN [GISZONEREVIEWITEMVALUE] AS [GISZONEREVIEWITEMVALUE] WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMVALUEID] = [inserted].[GISZONEREVIEWITEMVALUEID]
			JOIN [GISZONEREVIEWITEMMAPPING] AS [GISZONEREVIEWITEMMAPPING] WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMMAPPINGID]
			JOIN [PLITEMREVIEWTYPE] PLITEMREVIEWTYPE_INSERTED WITH (NOLOCK) ON [PLITEMREVIEWTYPE_INSERTED].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
			JOIN [PLITEMREVIEWTYPE] PLITEMREVIEWTYPE_DELETED WITH (NOLOCK) ON [PLITEMREVIEWTYPE_DELETED].[PLITEMREVIEWTYPEID] = [deleted].[PLITEMREVIEWTYPEID]			
	        JOIN [USERS] WITH (NOLOCK) ON [inserted].[USERID] = USERS.SUSERGUID
	WHERE	[deleted].[PLITEMREVIEWTYPEID] <> [inserted].[PLITEMREVIEWTYPEID]
	UNION ALL

	SELECT			
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
			'Assigned User',
			CONCAT([USERS_DELETED].[LNAME], ', ', [USERS_DELETED].[FNAME]),
			CONCAT([USERS_INSERTED].[LNAME], ', ', [USERS_INSERTED].[FNAME]),			
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), Zone Reviewer (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			2,
			0,
			[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONETOREVIEWITEMDESIGID] = [inserted].[GISZONETOREVIEWITEMDESIGID]
			JOIN [GISZONEREVIEWITEMVALUE] AS [GISZONEREVIEWITEMVALUE] WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMVALUEID] = [inserted].[GISZONEREVIEWITEMVALUEID]
			JOIN [GISZONEREVIEWITEMMAPPING] AS [GISZONEREVIEWITEMMAPPING] WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMMAPPINGID]
			JOIN [USERS] USERS_INSERTED WITH (NOLOCK) ON [USERS_INSERTED].[SUSERGUID] = [inserted].[USERID]
			JOIN [USERS] USERS_DELETED WITH (NOLOCK) ON [USERS_DELETED].[SUSERGUID] = [deleted].[USERID]			
	        JOIN [USERS] WITH (NOLOCK) ON [inserted].[USERID] = USERS.SUSERGUID
	WHERE	[deleted].[USERID] <> [inserted].[USERID]
END
GO

CREATE TRIGGER [dbo].[TG_GISZONETOREVIEWITEMDESIG_INSERT] ON [dbo].[GISZONETOREVIEWITEMDESIG]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
			'Zone Review Item Mapping Zone Reviewer Added',
			'',
			'',
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), Zone Reviewer (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') + ')',			
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			1,
			0,
			[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'')
	FROM	[inserted]
	JOIN	[GISZONEREVIEWITEMVALUE] AS [GISZONEREVIEWITEMVALUE] WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMVALUEID] = [inserted].[GISZONEREVIEWITEMVALUEID]
	JOIN	[GISZONEREVIEWITEMMAPPING] AS [GISZONEREVIEWITEMMAPPING] WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMMAPPINGID]
	JOIN [USERS] WITH (NOLOCK) ON [inserted].[USERID] = USERS.SUSERGUID
END
GO

CREATE TRIGGER [dbo].[TG_GISZONETOREVIEWITEMDESIG_DELETE] ON [dbo].[GISZONETOREVIEWITEMDESIG]
	AFTER DELETE
AS
BEGIN
	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT
			[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
			[GISZONEREVIEWITEMMAPPING].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Zone Review Item Mapping Zone Reviewer Deleted',
			'',
			'',
			'Zone Review Item Mapping (' + [GISZONEREVIEWITEMMAPPING].[SOURCENAME] + '), Zone Reviewer (' + [USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') + ')',
			'73AA9879-6784-48FA-919B-AB240AADA2B8',
			3,
			0,
			[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'')
			FROM	[deleted]
			JOIN	[GISZONEREVIEWITEMVALUE] AS [GISZONEREVIEWITEMVALUE] WITH (NOLOCK) ON [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMVALUEID] = [deleted].[GISZONEREVIEWITEMVALUEID]
			JOIN	[GISZONEREVIEWITEMMAPPING] AS [GISZONEREVIEWITEMMAPPING] WITH (NOLOCK) ON [GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID] = [GISZONEREVIEWITEMVALUE].[GISZONEREVIEWITEMMAPPINGID]
			JOIN    [USERS] WITH (NOLOCK) ON [deleted].[USERID] = USERS.SUSERGUID
END