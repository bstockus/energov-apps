﻿CREATE TABLE [dbo].[EXAMFORMATTYPE] (
    [EXAMFORMATTYPEID] INT            NOT NULL,
    [NAME]             NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_EXAMFORMATTYPE] PRIMARY KEY CLUSTERED ([EXAMFORMATTYPEID] ASC) WITH (FILLFACTOR = 90)
);

