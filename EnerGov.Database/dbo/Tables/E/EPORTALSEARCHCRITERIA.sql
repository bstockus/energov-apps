﻿CREATE TABLE [dbo].[EPORTALSEARCHCRITERIA] (
    [EPORTALSEARCHCRITERIAID] INT           NOT NULL,
    [NAME]                    NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EPORTALSEARCHCRITERIA] PRIMARY KEY CLUSTERED ([EPORTALSEARCHCRITERIAID] ASC) WITH (FILLFACTOR = 90)
);

