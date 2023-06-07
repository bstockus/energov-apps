CREATE TABLE [dbo].[GLOBALENTITY] (
    [GLOBALENTITYID]       CHAR (36)       NOT NULL,
    [PARENTGLOBALENTITYID] CHAR (36)       NULL,
    [GLOBALENTITYNAME]     NVARCHAR (100)  NOT NULL,
    [ISCOMPANY]            BIT             NOT NULL,
    [ISCONTACT]            BIT             NOT NULL,
    [MANUFACTURER]         BIT             NOT NULL,
    [VENDOR]               BIT             NOT NULL,
    [SHIPPER]              BIT             NOT NULL,
    [EMAIL]                NVARCHAR (250)  NULL,
    [WEBSITE]              NVARCHAR (100)  NULL,
    [BUSINESSPHONE]        NVARCHAR (50)   NULL,
    [HOMEPHONE]            NVARCHAR (50)   NULL,
    [MOBILEPHONE]          NVARCHAR (50)   NULL,
    [OTHERPHONE]           NVARCHAR (50)   NULL,
    [FAX]                  NVARCHAR (50)   NULL,
    [IMAGE]                VARBINARY (MAX) NULL,
    [FIRSTNAME]            NVARCHAR (50)   NOT NULL,
    [LASTNAME]             NVARCHAR (50)   NOT NULL,
    [MIDDLENAME]           NVARCHAR (50)   NULL,
    [TITLE]                NVARCHAR (50)   NULL,
    [LASTCHANGEDON]        DATETIME        NULL,
    [LASTCHANGEDBY]        CHAR (36)       NULL,
    [ROWVERSION]           INT             NOT NULL,
    [IMPNAMEKEY]           NVARCHAR (300)  NULL,
    [IMPADDKEY]            NVARCHAR (300)  NULL,
    [NAME1]                NVARCHAR (150)  NULL,
    [NAME2]                NVARCHAR (150)  NULL,
    [CONTACTID]            NVARCHAR (50)   NULL,
    [PREFCOMM]             INT             NULL,
    [ISACTIVE]             BIT             DEFAULT ((1)) NOT NULL,
    [OTHEREMAIL]           NVARCHAR (250)  NULL,
    CONSTRAINT [PK_GlobalEntity] PRIMARY KEY NONCLUSTERED ([GLOBALENTITYID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [CK_GlobalEntity_Flags] CHECK ([IsCompany]=(1) OR [IsContact]=(1)),
    CONSTRAINT [FK_Entity_Parent] FOREIGN KEY ([PARENTGLOBALENTITYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID]),
    CONSTRAINT [FK_ENTITY_PREFCOMM] FOREIGN KEY ([PREFCOMM]) REFERENCES [dbo].[GLOBALPREFFERCOMM] ([GLOBALPREFFERCOMMID]),
    CONSTRAINT [FK_GlobalEntity_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_GLOBALENTITY_PARENT]
    ON [dbo].[GLOBALENTITY]([PARENTGLOBALENTITYID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[GLOBALENTITY]([CONTACTID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_GLOBALENTITY_LASTCHANGEDON]
    ON [dbo].[GLOBALENTITY]([LASTCHANGEDON] ASC)
    INCLUDE([GLOBALENTITYID]);


GO
CREATE NONCLUSTERED INDEX [IX_GLOBALENTITY_CONTACT_PARCEL_OWNER]
    ON [dbo].[GLOBALENTITY]([IMPNAMEKEY] ASC, [ISACTIVE] ASC);


GO

CREATE TRIGGER [dbo].[TG_GLOBALENTITY_UPDATE] on [dbo].[GLOBALENTITY]   
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;
	DECLARE @CaseType VARCHAR(50) = (SELECT dbo.UFN_GET_CASE_FROM_CONTEXT_INFO())
	-- Check if PENDINGCAPCONTACT Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'PENDINGCAPCONTACT'
		BEGIN
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
					[inserted].[GLOBALENTITYID],
					[inserted].[ROWVERSION],
					GETUTCDATE(),
					[inserted].[LASTCHANGEDBY],
					'Approved Flag',
					CASE WHEN [deleted].[ISACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
					CASE WHEN [inserted].[ISACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
					'Pending Cap Contact (' + 
						CASE WHEN [inserted].[ISCOMPANY] = 1 AND [inserted].[ISCONTACT]= 1 
							THEN [inserted].[GLOBALENTITYNAME]
						 WHEN [inserted].[ISCOMPANY] = 0 AND [inserted].[ISCONTACT] = 1 
							THEN [inserted].[LASTNAME] + COALESCE(', ' + [inserted].[FIRSTNAME], '')
						 WHEN [inserted].[ISCOMPANY] = 1 AND [inserted].[ISCONTACT] = 0 
							THEN [inserted].[GLOBALENTITYNAME]
						 END + ')',
					'098DD4A2-D8A4-4047-AD1B-E3856C77F6BB',
					2,
					1,
					CASE WHEN [inserted].[ISCOMPANY] = 1 AND [inserted].[ISCONTACT]= 1 
						THEN [inserted].[GLOBALENTITYNAME]
					 WHEN [inserted].[ISCOMPANY] = 0 AND [inserted].[ISCONTACT] = 1 
						THEN [inserted].[LASTNAME] + COALESCE(', ' + [inserted].[FIRSTNAME], '')
					 WHEN [inserted].[ISCOMPANY] = 1 AND [inserted].[ISCONTACT] = 0 
						THEN [inserted].[GLOBALENTITYNAME]
					END
			FROM	[deleted]
					JOIN [inserted] ON [deleted].[GLOBALENTITYID] = [inserted].[GLOBALENTITYID]	
			WHERE	[deleted].[ISACTIVE] <> [inserted].[ISACTIVE]
		END
END
GO

CREATE TRIGGER [TG_GLOBALENTITY_DELETE] ON  GLOBALENTITY
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @CaseType VARCHAR(50) = (SELECT dbo.UFN_GET_CASE_FROM_CONTEXT_INFO())
	-- Check if PENDINGCAPCONTACT Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'PENDINGCAPCONTACT'
	BEGIN
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
			[deleted].[GLOBALENTITYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Pending Cap Contact Deleted',
			'',
			'',
			'Pending Cap Contact (' + 
				CASE WHEN [deleted].[ISCOMPANY] = 1 AND [deleted].[ISCONTACT]= 1 
					THEN [deleted].[GLOBALENTITYNAME]
				 WHEN [deleted].[ISCOMPANY] = 0 AND [deleted].[ISCONTACT] = 1 
					THEN [deleted].[LASTNAME] + COALESCE(', ' + [deleted].[FIRSTNAME], '')
				 WHEN [deleted].[ISCOMPANY] = 1 AND [deleted].[ISCONTACT] = 0 
					THEN [deleted].[GLOBALENTITYNAME]
				 END + ')',
			'098DD4A2-D8A4-4047-AD1B-E3856C77F6BB',
			3,
			1,
			CASE WHEN [deleted].[ISCOMPANY] = 1 AND [deleted].[ISCONTACT]= 1 
				THEN [deleted].[GLOBALENTITYNAME]
			 WHEN [deleted].[ISCOMPANY] = 0 AND [deleted].[ISCONTACT] = 1 
				THEN [deleted].[LASTNAME] + COALESCE(', ' + [deleted].[FIRSTNAME], '')
			 WHEN [deleted].[ISCOMPANY] = 1 AND [deleted].[ISCONTACT] = 0 
				THEN [deleted].[GLOBALENTITYNAME]
			END
	FROM	[deleted]
	END
END
GO

CREATE TRIGGER [TG_GLOBALENTITY_UPDATE_ELASTIC] ON  GLOBALENTITY
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[Inserted].[GLOBALENTITYID] ,
        'EnerGovBusiness.SystemSetup.GlobalEntity' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_GLOBALENTITY_INSERT_ELASTIC] ON  GLOBALENTITY
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[Inserted].[GLOBALENTITYID] ,
        'EnerGovBusiness.SystemSetup.GlobalEntity' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_GLOBALENTITY_DELETE_ELASTIC] ON  GLOBALENTITY
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[Deleted].[GLOBALENTITYID] ,
        'EnerGovBusiness.SystemSetup.GlobalEntity' ,
        [Deleted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted];

END