﻿CREATE TABLE [dbo].[CAPRORATIONMODEL] (
    [CAPRORATIONMODELID] INT            NOT NULL,
    [NAME]               NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_CAPRORATIONMODEL] PRIMARY KEY CLUSTERED ([CAPRORATIONMODELID] ASC) WITH (FILLFACTOR = 90)
);
