﻿CREATE TABLE [dbo].[AMWORKORDERTEMPLATE] (
    [AMWORKORDERTEMPLATEID] CHAR (36)     NOT NULL,
    [NAME]                  VARCHAR (50)  NOT NULL,
    [DESCRIPTION]           VARCHAR (MAX) NULL,
    CONSTRAINT [PK_AMWorkOrderTemplate] PRIMARY KEY CLUSTERED ([AMWORKORDERTEMPLATEID] ASC) WITH (FILLFACTOR = 90)
);
