﻿CREATE TABLE [dbo].[ILLICENSECAPAPPLICATIONTYPE] (
    [ILLICENSECAPAPPLICATIONTYPEID] INT           NOT NULL,
    [NAME]                          NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ILLICENSECAPAPPLICATIONTYPE] PRIMARY KEY CLUSTERED ([ILLICENSECAPAPPLICATIONTYPEID] ASC) WITH (FILLFACTOR = 90)
);

