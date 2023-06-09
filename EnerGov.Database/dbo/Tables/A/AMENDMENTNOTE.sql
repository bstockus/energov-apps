﻿CREATE TABLE [dbo].[AMENDMENTNOTE] (
    [AMENDMENTNOTEID] CHAR (36)      NOT NULL,
    [AMENDMENTID]     CHAR (36)      NOT NULL,
    [TEXT]            NVARCHAR (MAX) NOT NULL,
    [CREATEDBY]       CHAR (36)      NULL,
    [CREATEDATE]      DATETIME       NULL,
    CONSTRAINT [PK_AMENDMENTNOTE] PRIMARY KEY CLUSTERED ([AMENDMENTNOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMENDMENTNOTE_AMENDMENT] FOREIGN KEY ([AMENDMENTID]) REFERENCES [dbo].[AMENDMENT] ([AMENDMENTID]),
    CONSTRAINT [FK_AMENDMENTNOTE_CREATEDBY] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

