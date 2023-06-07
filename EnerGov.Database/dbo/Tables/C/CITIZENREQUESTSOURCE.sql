﻿CREATE TABLE [dbo].[CITIZENREQUESTSOURCE] (
    [CITIZENREQUESTSOURCEID] CHAR (36)     NOT NULL,
    [NAME]                   VARCHAR (255) NOT NULL,
    [DESCRIPTION]            VARCHAR (MAX) NULL,
    CONSTRAINT [PK_CitizenRequestSource] PRIMARY KEY CLUSTERED ([CITIZENREQUESTSOURCEID] ASC) WITH (FILLFACTOR = 80)
);

