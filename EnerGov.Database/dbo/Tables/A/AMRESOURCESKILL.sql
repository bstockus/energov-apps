﻿CREATE TABLE [dbo].[AMRESOURCESKILL] (
    [AMRESOURCESKILLID] CHAR (36)     NOT NULL,
    [NAME]              VARCHAR (50)  NOT NULL,
    [DESCRIPTION]       VARCHAR (MAX) NULL,
    CONSTRAINT [PK_AMResourceSkill] PRIMARY KEY CLUSTERED ([AMRESOURCESKILLID] ASC) WITH (FILLFACTOR = 90)
);

