﻿CREATE TABLE [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX] (
    [PLSUBMITTALTYPEITEMREVWTYPXID] CHAR (36) NOT NULL,
    [PLSUBMITTALTYPEID]             CHAR (36) NOT NULL,
    [PLITEMREVIEWTYPEID]            CHAR (36) NOT NULL,
    [PRIORITY]                      INT       CONSTRAINT [DF_PLSubmittalTypeItemReviewTypeXREF_Priority] DEFAULT ((5)) NULL,
    [AUTOADD]                       BIT       CONSTRAINT [DF_PLSubmittalTypeItemReviewTypeXREF_AutoAdd] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PLSubmittalTypeItemReviewTypeXREF] PRIMARY KEY CLUSTERED ([PLSUBMITTALTYPEITEMREVWTYPXID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLSubmittalTypeItemReviewTypeXREF_PLItemReviewType] FOREIGN KEY ([PLITEMREVIEWTYPEID]) REFERENCES [dbo].[PLITEMREVIEWTYPE] ([PLITEMREVIEWTYPEID]),
    CONSTRAINT [FK_PLSubmittalTypeItemReviewTypeXREF_PLSubmittalType] FOREIGN KEY ([PLSUBMITTALTYPEID]) REFERENCES [dbo].[PLSUBMITTALTYPE] ([PLSUBMITTALTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [PLSUBMITTALTYPEITEMREVIEWTYPEX_IX_QUERY]
    ON [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX]([PLSUBMITTALTYPEID] ASC);


GO

CREATE TRIGGER [dbo].[TG_PLSUBMITTALTYPEITEMREVIEWTYPEX_DELETE]  
   ON  [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX] 
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
		[PLSUBMITTALTYPE].[PLSUBMITTALTYPEID],
		[PLSUBMITTALTYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Submittal Type Item Review Type Deleted',
        '',
        '',       
		'Submittal Type (' + [PLSUBMITTALTYPE].[TYPENAME] + '), Item Review Type (' + [PLITEMREVIEWTYPE].[NAME] +')',
		'8E99093A-F310-4290-BBDA-74A574407449',
		3,
		0,
		[PLITEMREVIEWTYPE].[NAME]
    FROM [deleted]
	INNER JOIN [PLSUBMITTALTYPE] ON [PLSUBMITTALTYPE].[PLSUBMITTALTYPEID] = [deleted].[PLSUBMITTALTYPEID]
	INNER JOIN [PLITEMREVIEWTYPE] WITH (NOLOCK) ON [PLITEMREVIEWTYPE].[PLITEMREVIEWTYPEID] = [deleted].[PLITEMREVIEWTYPEID]
END
GO

CREATE TRIGGER [dbo].[TG_PLSUBMITTALTYPEITEMREVIEWTYPEX_INSERT]
   ON  [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX]
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
        [PLSUBMITTALTYPE].[PLSUBMITTALTYPEID], 
        [PLSUBMITTALTYPE].[ROWVERSION],
        GETUTCDATE(),
        [PLSUBMITTALTYPE].[LASTCHANGEDBY],	
        'Submittal Type Item Review Type Added',
        '',
        '',       
		'Submittal Type (' + [PLSUBMITTALTYPE].[TYPENAME] + '), Item Review Type (' + [PLITEMREVIEWTYPE].[NAME] +')',
		'8E99093A-F310-4290-BBDA-74A574407449',
		1,
		0,
		[PLITEMREVIEWTYPE].[NAME]
    FROM [inserted]
	INNER JOIN [PLSUBMITTALTYPE] ON [PLSUBMITTALTYPE].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
	INNER JOIN [PLITEMREVIEWTYPE] WITH (NOLOCK) ON [PLITEMREVIEWTYPE].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
END
GO

CREATE TRIGGER [dbo].[TG_PLSUBMITTALTYPEITEMREVIEWTYPEX_UPDATE]
   ON  [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX]
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
			[PLSUBMITTALTYPE].[PLSUBMITTALTYPEID],
			[PLSUBMITTALTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLSUBMITTALTYPE].[LASTCHANGEDBY],
			'Priority',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[PRIORITY]), '[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[PRIORITY]),'[none]'),
			'Submittal Type (' + [PLSUBMITTALTYPE].[TYPENAME] + '), Item Review Type (' + [PLITEMREVIEWTYPE].[NAME] +')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			0,
			[PLITEMREVIEWTYPE].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEITEMREVWTYPXID] = [inserted].[PLSUBMITTALTYPEITEMREVWTYPXID]
			INNER JOIN [PLSUBMITTALTYPE] ON [PLSUBMITTALTYPE].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
			INNER JOIN [PLITEMREVIEWTYPE] WITH (NOLOCK) ON [PLITEMREVIEWTYPE].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	ISNULL([deleted].[PRIORITY], '') <> ISNULL([inserted].[PRIORITY], '')
	UNION ALL	
	SELECT
			[PLSUBMITTALTYPE].[PLSUBMITTALTYPEID],
			[PLSUBMITTALTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLSUBMITTALTYPE].[LASTCHANGEDBY],
			'Auto Add Flag',
			CASE [deleted].[AUTOADD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[AUTOADD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Submittal Type (' + [PLSUBMITTALTYPE].[TYPENAME] + '), Item Review Type (' + [PLITEMREVIEWTYPE].[NAME] +')',
			'8E99093A-F310-4290-BBDA-74A574407449',
			2,
			0,
			[PLITEMREVIEWTYPE].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALTYPEITEMREVWTYPXID] = [inserted].[PLSUBMITTALTYPEITEMREVWTYPXID]
			INNER JOIN [PLSUBMITTALTYPE] ON [PLSUBMITTALTYPE].[PLSUBMITTALTYPEID] = [inserted].[PLSUBMITTALTYPEID]
			INNER JOIN [PLITEMREVIEWTYPE] WITH (NOLOCK) ON [PLITEMREVIEWTYPE].[PLITEMREVIEWTYPEID] = [inserted].[PLITEMREVIEWTYPEID]
	WHERE	[deleted].[AUTOADD] <> [inserted].[AUTOADD]
			OR ([deleted].[AUTOADD] IS NULL AND [inserted].[AUTOADD] IS NOT NULL)
			OR ([deleted].[AUTOADD] IS NOT NULL AND [inserted].[AUTOADD] IS NULL)
END