﻿CREATE TABLE [dbo].[WFENTITY] (
    [WFENTITYID] INT           NOT NULL,
    [NAME]       NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_WFEntity] PRIMARY KEY CLUSTERED ([WFENTITYID] ASC) WITH (FILLFACTOR = 90)
);

