﻿CREATE TABLE [dbo].[CUSTOMSAVERPERMITMANAGEMENT2] (
    [ID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_PermitManagement2] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERPERMITMANAGEMENT2_UPDATE_ELASTIC] ON  CUSTOMSAVERPERMITMANAGEMENT2
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
		[P].[PMPERMITID] ,
        'EnerGovBusiness.PermitManagement.Permit' ,
        [P].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [PMPERMIT] AS [P] WITH (NOLOCK) ON [P].[PMPERMITID] = [Inserted].[ID];

END