﻿CREATE TABLE [dbo].[CATRANSACTIONMISCFEEPOSTING] (
    [CATRANSACTIONMISCFEEPOSTINGID] CHAR (36) NOT NULL,
    [CATRANSACTIONGLPOSTINGID]      CHAR (36) NOT NULL,
    [CATRANSACTIONMISCFEEID]        CHAR (36) NOT NULL,
    CONSTRAINT [PK_CATransactionMiscFeePost] PRIMARY KEY NONCLUSTERED ([CATRANSACTIONMISCFEEPOSTINGID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CATransMiscFeePost_Post] FOREIGN KEY ([CATRANSACTIONGLPOSTINGID]) REFERENCES [dbo].[CATRANSACTIONGLPOSTING] ([CATRANSACTIONGLPOSTINGID]),
    CONSTRAINT [FK_CATransMiscFeePosting_Fee] FOREIGN KEY ([CATRANSACTIONMISCFEEID]) REFERENCES [dbo].[CATRANSACTIONMISCFEE] ([CATRANSACTIONMISCFEEID])
);


GO
CREATE NONCLUSTERED INDEX [CATRANMISCPOSTING_GLPOSTINGID]
    ON [dbo].[CATRANSACTIONMISCFEEPOSTING]([CATRANSACTIONGLPOSTINGID] ASC, [CATRANSACTIONMISCFEEID] ASC) WITH (FILLFACTOR = 80);

