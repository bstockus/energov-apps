﻿CREATE TABLE [dbo].[CATRANSACTIONBOND] (
    [CATRANSACTIONBONDID]   CHAR (36) NOT NULL,
    [CATRANSACTIONID]       CHAR (36) NOT NULL,
    [BONDID]                CHAR (36) NOT NULL,
    [GLOBALENTITYACCOUNTID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_CATransactionBond] PRIMARY KEY CLUSTERED ([CATRANSACTIONBONDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CATransactionBond_Account] FOREIGN KEY ([GLOBALENTITYACCOUNTID]) REFERENCES [dbo].[GLOBALENTITYACCOUNT] ([GLOBALENTITYACCOUNTID]),
    CONSTRAINT [FK_CATransactionBond_Bond] FOREIGN KEY ([BONDID]) REFERENCES [dbo].[BOND] ([BONDID]),
    CONSTRAINT [FK_CATransactionBond_Trans] FOREIGN KEY ([CATRANSACTIONID]) REFERENCES [dbo].[CATRANSACTION] ([CATRANSACTIONID])
);

