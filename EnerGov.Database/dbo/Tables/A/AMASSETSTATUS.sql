﻿CREATE TABLE [dbo].[AMASSETSTATUS] (
    [AMASSETSTATUSID] CHAR (36)     NOT NULL,
    [NAME]            VARCHAR (50)  NOT NULL,
    [DESCRIPTION]     VARCHAR (MAX) NULL,
    CONSTRAINT [PK_AMAssetStatus] PRIMARY KEY CLUSTERED ([AMASSETSTATUSID] ASC) WITH (FILLFACTOR = 90)
);

