﻿CREATE TABLE [dbo].[PRPROJECT] (
    [PRPROJECTID]       CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (100) NOT NULL,
    [PRPROJECTTYPEID]   CHAR (36)      NOT NULL,
    [PRPROJECTSTATUSID] CHAR (36)      NOT NULL,
    [PROJECTNUMBER]     NVARCHAR (50)  NULL,
    [STARTDATE]         DATETIME       NULL,
    [EXPECTEDENDDATE]   DATETIME       NULL,
    [COMPLETEDATE]      DATETIME       NULL,
    [COMPLETE]          BIT            NULL,
    [PRPROJECTPARENTID] CHAR (36)      NULL,
    [MAIN]              BIT            NULL,
    [ROWVERSION]        INT            NOT NULL,
    [LASTCHANGEDBY]     CHAR (36)      NOT NULL,
    [LASTCHANGEDON]     DATETIME       NOT NULL,
    [DESCRIPTION]       VARCHAR (MAX)  NULL,
    [DISTRICTID]        CHAR (36)      NULL,
    CONSTRAINT [PK_PRProject] PRIMARY KEY CLUSTERED ([PRPROJECTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PRProject_District] FOREIGN KEY ([DISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_PRProject_PRProject] FOREIGN KEY ([PRPROJECTPARENTID]) REFERENCES [dbo].[PRPROJECT] ([PRPROJECTID]),
    CONSTRAINT [FK_PRProject_PRProjectStatus] FOREIGN KEY ([PRPROJECTSTATUSID]) REFERENCES [dbo].[PRPROJECTSTATUS] ([PRPROJECTSTATUSID]),
    CONSTRAINT [FK_PRProject_PRProjectType] FOREIGN KEY ([PRPROJECTTYPEID]) REFERENCES [dbo].[PRPROJECTTYPE] ([PRPROJECTTYPEID]),
    CONSTRAINT [FK_PRProject_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PRPROJECT_IX_QUERY]
    ON [dbo].[PRPROJECT]([PRPROJECTID] ASC, [NAME] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[PRPROJECT]([PROJECTNUMBER] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_PRPROJECT_LASTCHANGEDON]
    ON [dbo].[PRPROJECT]([LASTCHANGEDON] ASC)
    INCLUDE([PRPROJECTID]);


GO

CREATE TRIGGER [TG_PRPROJECT_UPDATE_ELASTIC] ON  PRPROJECT
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
		[Inserted].[PRPROJECTID] ,
        'EnerGovBusiness.ProjectManagement.Project' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_PRPROJECT_DELETE_ELASTIC] ON  PRPROJECT
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
		[Deleted].[PRPROJECTID] ,
        'EnerGovBusiness.ProjectManagement.Project' ,
        [Deleted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted];

END
GO

CREATE TRIGGER [TG_PRPROJECT_INSERT_ELASTIC] ON  PRPROJECT
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
		[Inserted].[PRPROJECTID] ,
        'EnerGovBusiness.ProjectManagement.Project' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END