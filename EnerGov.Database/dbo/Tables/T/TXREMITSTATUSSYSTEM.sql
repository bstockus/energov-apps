﻿CREATE TABLE [dbo].[TXREMITSTATUSSYSTEM] (
    [TXREMITSTATUSSYSTEMID] INT           NOT NULL,
    [NAME]                  NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TXREMITSTATUSSYSTEM] PRIMARY KEY CLUSTERED ([TXREMITSTATUSSYSTEMID] ASC) WITH (FILLFACTOR = 90)
);

