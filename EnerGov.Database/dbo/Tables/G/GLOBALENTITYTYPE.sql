﻿CREATE TABLE [dbo].[GLOBALENTITYTYPE] (
    [GLOBALENTITYTYPEID] CHAR (36)    NOT NULL,
    [NAME]               VARCHAR (50) NULL,
    CONSTRAINT [PK_GlobalEntityType] PRIMARY KEY CLUSTERED ([GLOBALENTITYTYPEID] ASC) WITH (FILLFACTOR = 90)
);
