﻿CREATE TABLE [dbo].[RECEIPT] (
    [RECEIPTID]         CHAR (36)       NOT NULL,
    [AUTHORIZATIONCODE] NVARCHAR (256)  NULL,
    [REFERENCENUMBER]   NVARCHAR (256)  NULL,
    [AMOUNT]            DECIMAL (18, 4) NULL,
    [TRANSACTIONDATE]   DATETIME        NOT NULL,
    [TRANSACTIONTYPE]   NVARCHAR (128)  NULL,
    [PROCESSED]         BIT             NOT NULL,
    [PROCESSEDDATE]     DATETIME        NULL,
    [SENTTOBUS]         BIT             DEFAULT ((0)) NULL,
    [PAIDBYID]          CHAR (36)       NULL,
    [ORDERNUMBER]       INT             NULL,
    CONSTRAINT [PK_RECEIPT] PRIMARY KEY CLUSTERED ([RECEIPTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Receipt_GlobalEntity] FOREIGN KEY ([PAIDBYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID])
);

