﻿CREATE TABLE [dbo].[CATRANSACTIONINVOICE] (
    [CATRANSACTIONINVOICEID] CHAR (36) NOT NULL,
    [CATRANSACTIONID]        CHAR (36) NOT NULL,
    [CAINVOICEID]            CHAR (36) NOT NULL,
    [PAIDAMOUNT]             MONEY     NOT NULL,
    CONSTRAINT [PK_CATransactionInvoice] PRIMARY KEY NONCLUSTERED ([CATRANSACTIONINVOICEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CATransInvoice_Invoice] FOREIGN KEY ([CAINVOICEID]) REFERENCES [dbo].[CAINVOICE] ([CAINVOICEID]),
    CONSTRAINT [FK_CATransInvoice_Trans] FOREIGN KEY ([CATRANSACTIONID]) REFERENCES [dbo].[CATRANSACTION] ([CATRANSACTIONID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[CATRANSACTIONINVOICE]([CAINVOICEID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[CATRANSACTIONINVOICE]([CATRANSACTIONID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [CATRANSACTIONINVOICE_INV]
    ON [dbo].[CATRANSACTIONINVOICE]([CAINVOICEID] ASC);


GO
CREATE NONCLUSTERED INDEX [CATRANSACTIONINVOICE_TRANS]
    ON [dbo].[CATRANSACTIONINVOICE]([CATRANSACTIONID] ASC);

