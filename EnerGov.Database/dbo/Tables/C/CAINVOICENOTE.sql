﻿CREATE TABLE [dbo].[CAINVOICENOTE] (
    [CAINVOICENOTEID] CHAR (36)      NOT NULL,
    [CAINVOICEID]     CHAR (36)      NOT NULL,
    [TEXT]            NVARCHAR (MAX) NULL,
    [CREATEDBY]       CHAR (36)      NULL,
    [CREATEDDATE]     DATETIME       NULL,
    [TITLE]           NVARCHAR (50)  CONSTRAINT [DF_CAINVOICENOTE_TITLE] DEFAULT ('') NULL,
    [PIN]             BIT            CONSTRAINT [DF_CAINVOICENOTE_PIN] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CAINVOICENOTE] PRIMARY KEY NONCLUSTERED ([CAINVOICENOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CAINVOICENOTE_REQ] FOREIGN KEY ([CAINVOICEID]) REFERENCES [dbo].[CAINVOICE] ([CAINVOICEID]),
    CONSTRAINT [FK_CAINVOICENOTE_USERS] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [CAINVOICENOTE_CAINVOICE]
    ON [dbo].[CAINVOICENOTE]([CAINVOICEID] ASC);
