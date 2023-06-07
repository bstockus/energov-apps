﻿CREATE TABLE [dbo].[RESOURCETYPE] (
    [RESOURCETYPEID]       CHAR (36)     NOT NULL,
    [NAME]                 NVARCHAR (50) NOT NULL,
    [RESOURCESYSTEMTYPEID] INT           NOT NULL,
    CONSTRAINT [PK_RESOURCETYPE] PRIMARY KEY NONCLUSTERED ([RESOURCETYPEID] ASC),
    CONSTRAINT [FK_RESOURCETYPE_SYS_TYPE] FOREIGN KEY ([RESOURCESYSTEMTYPEID]) REFERENCES [dbo].[RESOURCESYSTEMTYPE] ([RESOURCESYSTEMTYPEID])
);

