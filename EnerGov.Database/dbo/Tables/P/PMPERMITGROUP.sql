﻿CREATE TABLE [dbo].[PMPERMITGROUP] (
    [PMPERMITGROUPID] CHAR (36)     NOT NULL,
    [NAME]            NVARCHAR (50) NOT NULL,
    [ALLOWKIOSK]      BIT           NOT NULL,
    [ALLOWINTERNET]   BIT           NOT NULL,
    CONSTRAINT [PK_PMPermitGroup] PRIMARY KEY CLUSTERED ([PMPERMITGROUPID] ASC) WITH (FILLFACTOR = 90)
);

