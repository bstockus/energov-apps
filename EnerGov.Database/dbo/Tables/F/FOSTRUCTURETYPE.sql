﻿CREATE TABLE [dbo].[FOSTRUCTURETYPE] (
    [FOSTRUCTURETYPEID] CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_FOSTRUCTURETYPE] PRIMARY KEY CLUSTERED ([FOSTRUCTURETYPEID] ASC)
);

