﻿CREATE TABLE [dbo].[COLICENSECERTIFICATION] (
    [COSIMPLELICCERTID]     CHAR (36)      NOT NULL,
    [LICENSENUMBER]         NVARCHAR (255) NOT NULL,
    [COSIMPLELICCERTTYPEID] CHAR (36)      NOT NULL,
    [COMMENTS]              NVARCHAR (MAX) NULL,
    [ISSUEDATE]             DATETIME       NULL,
    [EXPIREDATE]            DATETIME       NULL,
    [GLOBALENTITYID]        CHAR (36)      NULL,
    [CERTGROUPID]           CHAR (36)      NULL,
    CONSTRAINT [PK_ConMgmtSimpleLicenseCertification] PRIMARY KEY CLUSTERED ([COSIMPLELICCERTID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Certification_Group] FOREIGN KEY ([CERTGROUPID]) REFERENCES [dbo].[ILLICENSEGROUP] ([ILLICENSEGROUPID]),
    CONSTRAINT [FK_COLicCert_COLicCertType] FOREIGN KEY ([COSIMPLELICCERTTYPEID]) REFERENCES [dbo].[COLICENSECERTIFICATIONTYPE] ([COSIMPLELICCERTTYPEID]),
    CONSTRAINT [FK_COLicCert_GlobalEntity] FOREIGN KEY ([GLOBALENTITYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID])
);


GO
CREATE NONCLUSTERED INDEX [IX_COLICENSECERT_GLBENT]
    ON [dbo].[COLICENSECERTIFICATION]([GLOBALENTITYID] ASC) WITH (FILLFACTOR = 80);


GO

CREATE TRIGGER [TG_COLICENSECERTIFICATION_INSERTUPDATE_ELASTIC] ON  [COLICENSECERTIFICATION]
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
		[G].[GLOBALENTITYID] ,
        'EnerGovBusiness.SystemSetup.GlobalEntity' ,
        [G].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [GLOBALENTITY] AS [G] WITH (NOLOCK) ON [G].[GLOBALENTITYID] = [Inserted].[GLOBALENTITYID]

END
GO


CREATE TRIGGER [TG_COLICENSECERTIFICATION_DELETE_ELASTIC] ON  [COLICENSECERTIFICATION]
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
		[G].[GLOBALENTITYID] ,
        'EnerGovBusiness.SystemSetup.GlobalEntity' ,
        [G].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted]
	JOIN [GLOBALENTITY] AS [G] WITH (NOLOCK) ON [G].[GLOBALENTITYID] = [Deleted].[GLOBALENTITYID]

END