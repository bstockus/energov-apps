﻿CREATE TABLE [dbo].[CAINVOICEFEE] (
    [CAINVOICEFEEID]   CHAR (36) NOT NULL,
    [CACOMPUTEDFEEID]  CHAR (36) NOT NULL,
    [CAINVOICEID]      CHAR (36) NOT NULL,
    [PAIDAMOUNT]       MONEY     NOT NULL,
    [CREATEDON]        DATETIME  NULL,
    [CREATEDBY]        CHAR (36) NULL,
    [CAEXPORTSTATUSID] INT       NULL,
    CONSTRAINT [PK_CAInvoiceFee] PRIMARY KEY NONCLUSTERED ([CAINVOICEFEEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CAInvoiceFee_ExportStat] FOREIGN KEY ([CAEXPORTSTATUSID]) REFERENCES [dbo].[CAEXPORTSTATUS] ([CAEXPORTSTATUSID]),
    CONSTRAINT [FK_CAInvoiceFee_Fee] FOREIGN KEY ([CACOMPUTEDFEEID]) REFERENCES [dbo].[CACOMPUTEDFEE] ([CACOMPUTEDFEEID]),
    CONSTRAINT [FK_CAInvoiceFee_Invoice] FOREIGN KEY ([CAINVOICEID]) REFERENCES [dbo].[CAINVOICE] ([CAINVOICEID]),
    CONSTRAINT [FK_CAINVOICEFEE_USERS] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [CAINVOICEFEE_COMP_FEE]
    ON [dbo].[CAINVOICEFEE]([CACOMPUTEDFEEID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CAINVOICEFEE_INVCE]
    ON [dbo].[CAINVOICEFEE]([CAINVOICEID] ASC)
    INCLUDE([CAINVOICEFEEID], [CACOMPUTEDFEEID], [PAIDAMOUNT], [CREATEDON], [CREATEDBY]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CAINVOICEFEE_INVCE_EXPSTAT_CREATED]
    ON [dbo].[CAINVOICEFEE]([CAINVOICEID] ASC)
    INCLUDE([CACOMPUTEDFEEID], [CAEXPORTSTATUSID], [CREATEDON]);
