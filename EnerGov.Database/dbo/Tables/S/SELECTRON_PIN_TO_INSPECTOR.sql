﻿CREATE TABLE [dbo].[SELECTRON_PIN_TO_INSPECTOR] (
    [PIN]          VARCHAR (255) NOT NULL,
    [INSPECTOR_ID] CHAR (36)     NOT NULL,
    CONSTRAINT [PK_SELECTRON_PIN_TO_INSPECTOR] PRIMARY KEY CLUSTERED ([PIN] ASC, [INSPECTOR_ID] ASC) WITH (FILLFACTOR = 90)
);
