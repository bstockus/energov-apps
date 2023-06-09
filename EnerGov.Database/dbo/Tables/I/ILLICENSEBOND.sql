﻿CREATE TABLE [dbo].[ILLICENSEBOND] (
    [ILLICENSEBONDID] CHAR (36) NOT NULL,
    [ILLICENSEID]     CHAR (36) NOT NULL,
    [BONDID]          CHAR (36) NOT NULL,
    [CREATEDBY]       CHAR (36) NULL,
    [CREATEDATE]      DATETIME  NULL,
    CONSTRAINT [PK_ILLICENSEBOND] PRIMARY KEY CLUSTERED ([ILLICENSEBONDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ILLICENSEBOND_BOND] FOREIGN KEY ([BONDID]) REFERENCES [dbo].[BOND] ([BONDID]),
    CONSTRAINT [FK_ILLICENSEBOND_ILLICENSE] FOREIGN KEY ([ILLICENSEID]) REFERENCES [dbo].[ILLICENSE] ([ILLICENSEID]),
    CONSTRAINT [FK_ILLICENSEBOND_USERS] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [NCIDX1_ILLICENSEBOND_BONDID]
    ON [dbo].[ILLICENSEBOND]([BONDID] ASC)
    INCLUDE([ILLICENSEID]);

