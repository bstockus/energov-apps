﻿CREATE TABLE [dbo].[PLSUBMITTALNOTE] (
    [PLSUBMITTALNOTEID] CHAR (36)      NOT NULL,
    [PLSUBMITTALID]     CHAR (36)      NOT NULL,
    [TEXT]              NVARCHAR (MAX) NULL,
    [CREATEDBY]         CHAR (36)      NOT NULL,
    [CREATEDDATE]       DATETIME       NOT NULL,
    CONSTRAINT [PK_PLSubmittalNote] PRIMARY KEY CLUSTERED ([PLSUBMITTALNOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLSubmittalNote_PLSubmittal] FOREIGN KEY ([PLSUBMITTALID]) REFERENCES [dbo].[PLSUBMITTAL] ([PLSUBMITTALID]),
    CONSTRAINT [FK_PLSubmittalNote_Users] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

