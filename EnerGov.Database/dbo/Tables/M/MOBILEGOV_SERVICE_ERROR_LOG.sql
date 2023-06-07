﻿CREATE TABLE [dbo].[MOBILEGOV_SERVICE_ERROR_LOG] (
    [ERROR_ID]   CHAR (36)      NOT NULL,
    [ERROR_TEXT] NVARCHAR (MAX) NOT NULL,
    [TIMESTAMP]  DATETIME       NOT NULL,
    CONSTRAINT [PK_MOBILEGOV_SERVICE_ERROR_LOG] PRIMARY KEY CLUSTERED ([ERROR_ID] ASC) WITH (FILLFACTOR = 90)
);

