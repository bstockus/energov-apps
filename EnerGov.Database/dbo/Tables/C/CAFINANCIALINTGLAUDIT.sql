﻿CREATE TABLE [dbo].[CAFINANCIALINTGLAUDIT] (
    [CAFINANCIALINTGLAUDITID]  CHAR (36)      NOT NULL,
    [CATRANSACTIONGLPOSTINGID] CHAR (36)      NOT NULL,
    [CHARGECODE]               NVARCHAR (100) NULL,
    CONSTRAINT [PK_CAFINANCIALINTGLAUDIT] PRIMARY KEY NONCLUSTERED ([CAFINANCIALINTGLAUDITID] ASC),
    CONSTRAINT [FK_CAFININTGLAUDIT_GLPOSTING] FOREIGN KEY ([CATRANSACTIONGLPOSTINGID]) REFERENCES [dbo].[CATRANSACTIONGLPOSTING] ([CATRANSACTIONGLPOSTINGID])
);


GO
CREATE NONCLUSTERED INDEX [CAFINANCIALINTGLAUDIT_GLPOSTINGID]
    ON [dbo].[CAFINANCIALINTGLAUDIT]([CATRANSACTIONGLPOSTINGID] ASC);
