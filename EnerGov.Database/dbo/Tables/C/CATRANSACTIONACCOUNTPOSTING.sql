﻿CREATE TABLE [dbo].[CATRANSACTIONACCOUNTPOSTING] (
    [CATRANSACTIONACCOUNTPOSTINGID] CHAR (36) NOT NULL,
    [CATRANSACTIONGLPOSTINGID]      CHAR (36) NOT NULL,
    [CATRANSACTIONACCOUNTID]        CHAR (36) NOT NULL,
    CONSTRAINT [PK_CATransactionAccountPosting] PRIMARY KEY NONCLUSTERED ([CATRANSACTIONACCOUNTPOSTINGID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CATransAccountPosting_Depo] FOREIGN KEY ([CATRANSACTIONACCOUNTID]) REFERENCES [dbo].[CATRANSACTIONACCOUNT] ([CATRANSACTIONACCOUNTID]),
    CONSTRAINT [FK_CATransAccountPosting_Post] FOREIGN KEY ([CATRANSACTIONGLPOSTINGID]) REFERENCES [dbo].[CATRANSACTIONGLPOSTING] ([CATRANSACTIONGLPOSTINGID])
);


GO
CREATE NONCLUSTERED INDEX [CATRANACCPOSTING_GLPOSTINGID]
    ON [dbo].[CATRANSACTIONACCOUNTPOSTING]([CATRANSACTIONGLPOSTINGID] ASC, [CATRANSACTIONACCOUNTID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [CATRANACCPOSTING_ACCOUNTID]
    ON [dbo].[CATRANSACTIONACCOUNTPOSTING]([CATRANSACTIONACCOUNTID] ASC)
    INCLUDE([CATRANSACTIONGLPOSTINGID]);

