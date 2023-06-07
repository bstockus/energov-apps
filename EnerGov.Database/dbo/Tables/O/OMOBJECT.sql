﻿CREATE TABLE [dbo].[OMOBJECT] (
    [OMOBJECTID]                  CHAR (36)     NOT NULL,
    [OMOBJECTTYPEID]              CHAR (36)     NOT NULL,
    [OMOBJECTCLASSIFICATIONID]    CHAR (36)     NOT NULL,
    [OMOBJECTSTATUSID]            CHAR (36)     NOT NULL,
    [DESCRIPTION]                 VARCHAR (MAX) NULL,
    [DISTRICTID]                  CHAR (36)     NOT NULL,
    [CREATEDATE]                  DATETIME      NOT NULL,
    [INSTALLDATE]                 DATETIME      NULL,
    [OPERATIONSTARTDATE]          DATETIME      NULL,
    [OPERATIONENDDATE]            DATETIME      NULL,
    [OMOBJECTPARENTID]            CHAR (36)     NULL,
    [LASTCHANGEDON]               DATETIME      NULL,
    [LASTCHANGEDBY]               CHAR (36)     NULL,
    [ROWVERSION]                  INT           NOT NULL,
    [OBJECTNUMBER]                NVARCHAR (50) NOT NULL,
    [IMPORTEDCUSTOMFIELDLAYOUTID] CHAR (36)     NULL,
    CONSTRAINT [PK_OMOBJECT] PRIMARY KEY CLUSTERED ([OMOBJECTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OMOBJECT_CUSTOMFIELDLAYOUT] FOREIGN KEY ([IMPORTEDCUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_OMOBJECT_DISTRICT] FOREIGN KEY ([DISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_OMOBJECT_OMOBJECT] FOREIGN KEY ([OMOBJECTPARENTID]) REFERENCES [dbo].[OMOBJECT] ([OMOBJECTID]),
    CONSTRAINT [FK_OMOBJECT_OMOBJECTCLASSIFICA] FOREIGN KEY ([OMOBJECTCLASSIFICATIONID]) REFERENCES [dbo].[OMOBJECTCLASSIFICATION] ([OMOBJECTCLASSIFICATIONID]),
    CONSTRAINT [FK_OMOBJECT_OMOBJECTSTATUS] FOREIGN KEY ([OMOBJECTSTATUSID]) REFERENCES [dbo].[OMOBJECTSTATUS] ([OMOBJECTSTATUSID]),
    CONSTRAINT [FK_OMOBJECT_OMOBJECTTYPE] FOREIGN KEY ([OMOBJECTTYPEID]) REFERENCES [dbo].[OMOBJECTTYPE] ([OMOBJECTTYPEID]),
    CONSTRAINT [FK_OMOBJECT_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_OMOBJECT_LASTCHANGEDON]
    ON [dbo].[OMOBJECT]([LASTCHANGEDON] ASC)
    INCLUDE([OMOBJECTID]);


GO
CREATE NONCLUSTERED INDEX [IX_OMOBJECT_OMOBJECTPARENTID]
    ON [dbo].[OMOBJECT]([OMOBJECTPARENTID] ASC);


GO

CREATE TRIGGER [TG_OMOBJECT_UPDATE_ELASTIC] ON  [OMOBJECT]
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
		[Inserted].[OMOBJECTID] ,
        'EnerGovBusiness.ObjectManagement.ObjectCase' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]

END
GO

CREATE TRIGGER [TG_OMOBJECT_DELETE_ELASTIC] ON  [OMOBJECT]
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
		[Deleted].[OMOBJECTID] ,
        'EnerGovBusiness.ObjectManagement.ObjectCase' ,
        [Deleted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted]
END
GO

CREATE TRIGGER [TG_OMOBJECT_INSERT_ELASTIC] ON  [OMOBJECT]
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
		[Inserted].[OMOBJECTID] ,
        'EnerGovBusiness.ObjectManagement.ObjectCase' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]

END
GO


CREATE TRIGGER [TG_OMOBJECT_DELETE_ELASTIC_PERMIT] ON  [OMOBJECT]
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
		[PPO].[PMPERMITID] ,
        'EnerGovBusiness.PermitManagement.Permit' ,
        [P].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted]
	JOIN [PMPERMITOBJECT] AS [PPO] WITH (NOLOCK) ON [PPO].[OMOBJECTID] = [Deleted].[OMOBJECTID]
	JOIN [PMPERMIT] AS [P] WITH (NOLOCK) ON [P].[PMPERMITID] = [PPO].[PMPERMITID];

END
GO

CREATE TRIGGER [TG_OMOBJECT_INSERTUPDATE_ELASTIC_PERMIT] ON  [OMOBJECT]
   AFTER INSERT, UPDATE
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
		[PPO].[PMPERMITID] ,
        'EnerGovBusiness.PermitManagement.Permit' ,
        [P].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [PMPERMITOBJECT] AS [PPO] WITH (NOLOCK) ON [PPO].[OMOBJECTID] = [Inserted].[OMOBJECTID]
	JOIN [PMPERMIT] AS [P] WITH (NOLOCK) ON [P].[PMPERMITID] = [PPO].[PMPERMITID];

END