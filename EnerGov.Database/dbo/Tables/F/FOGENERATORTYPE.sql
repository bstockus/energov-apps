﻿CREATE TABLE [dbo].[FOGENERATORTYPE] (
    [FOGENERATORTYPEID] CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_FOGENERATORTYPE] PRIMARY KEY CLUSTERED ([FOGENERATORTYPEID] ASC)
);

