﻿CREATE TABLE [dbo].[CUSTOMSAVERIMPACTMANAGEMENT] (
    [ID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_CUSTOMSAVERIMPACT] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERIMPACTMANAGEMENT_UPDATE_ELASTIC] ON CUSTOMSAVERIMPACTMANAGEMENT
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
		NEWID(),
		[ImpactCase].[IPCASEID],
		'EnerGovBusiness.ImpactManagement.ImpactCase',
		[ImpactCase].[ROWVERSION],
		GETDATE(),
		NULL,
		2,
		(SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [IPCASE] AS [ImpactCase] WITH (NOLOCK) ON [ImpactCase].[IPCASEID] = [Inserted].[ID];
END