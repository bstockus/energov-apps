﻿CREATE TABLE [dbo].[CUSTOMSAVERCRMMANAGEMENT2] (
    [ID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_CRMManagement2] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERCRMMANAGEMENT2_UPDATE_ELASTIC] ON  CUSTOMSAVERCRMMANAGEMENT2
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
		[C].[CITIZENREQUESTID] ,
        'EnerGovBusiness.CitizenRequest.Requestmgmt' ,
        [C].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [CITIZENREQUEST] AS [C] WITH (NOLOCK) ON [C].[CITIZENREQUESTID] = [Inserted].[ID];

END