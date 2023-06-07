﻿CREATE TABLE [dbo].[ILLICENSEFEE] (
    [ILLICENSEFEEID]  CHAR (36) NOT NULL,
    [ILLICENSEID]     CHAR (36) NOT NULL,
    [CACOMPUTEDFEEID] CHAR (36) NOT NULL,
    [CREATEDON]       DATETIME  NOT NULL,
    CONSTRAINT [PK_ILLICENSEFEE] PRIMARY KEY CLUSTERED ([ILLICENSEFEEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ILLICENSEFEE_CACOMPUTEDFEE] FOREIGN KEY ([CACOMPUTEDFEEID]) REFERENCES [dbo].[CACOMPUTEDFEE] ([CACOMPUTEDFEEID]),
    CONSTRAINT [FK_ILLICENSEFEE_ILLICENSE] FOREIGN KEY ([ILLICENSEID]) REFERENCES [dbo].[ILLICENSE] ([ILLICENSEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ILLICENSEFEE_LIC]
    ON [dbo].[ILLICENSEFEE]([ILLICENSEID] ASC, [CACOMPUTEDFEEID] ASC) WITH (FILLFACTOR = 90);
