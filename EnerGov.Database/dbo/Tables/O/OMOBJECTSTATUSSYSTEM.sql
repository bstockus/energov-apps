﻿CREATE TABLE [dbo].[OMOBJECTSTATUSSYSTEM] (
    [OMOBJECTSTATUSSYSTEMID] INT            NOT NULL,
    [NAME]                   NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_OMOBJECTSTATUSSYSTEM] PRIMARY KEY CLUSTERED ([OMOBJECTSTATUSSYSTEMID] ASC) WITH (FILLFACTOR = 90)
);

