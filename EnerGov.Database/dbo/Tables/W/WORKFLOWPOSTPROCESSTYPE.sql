﻿CREATE TABLE [dbo].[WORKFLOWPOSTPROCESSTYPE] (
    [WORKFLOWPOSTPROCESSTYPEID] INT            NOT NULL,
    [NAME]                      NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_WORKFLOWPOSTPROCESSTYPE] PRIMARY KEY NONCLUSTERED ([WORKFLOWPOSTPROCESSTYPEID] ASC) WITH (FILLFACTOR = 90)
);

