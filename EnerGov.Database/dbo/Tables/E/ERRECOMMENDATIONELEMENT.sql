﻿CREATE TABLE [dbo].[ERRECOMMENDATIONELEMENT] (
    [ERRECOMMENDATIONELEMENTID] CHAR (36)      NOT NULL,
    [PLPLANRECOMMENDATIONID]    CHAR (36)      NOT NULL,
    [PAGENUMBER]                INT            NOT NULL,
    [ELEMENTNUMBER]             INT            NULL,
    [COMMENTS]                  NVARCHAR (MAX) NULL,
    [ELEMENTID]                 NVARCHAR (50)  NULL,
    CONSTRAINT [PK_ERRecomElement] PRIMARY KEY CLUSTERED ([ERRECOMMENDATIONELEMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ERRecomElement_PLRecom] FOREIGN KEY ([PLPLANRECOMMENDATIONID]) REFERENCES [dbo].[PLPLANRECOMMENDATION] ([PLPLANRECOMENDATIONID])
);

