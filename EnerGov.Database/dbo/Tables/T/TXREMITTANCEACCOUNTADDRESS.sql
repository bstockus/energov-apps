﻿CREATE TABLE [dbo].[TXREMITTANCEACCOUNTADDRESS] (
    [TXREMITTANCEACCOUNTADDRESSID] CHAR (36) NOT NULL,
    [TXREMITTANCEACCOUNTID]        CHAR (36) NOT NULL,
    [MAILINGADDRESSID]             CHAR (36) NOT NULL,
    [MAIN]                         BIT       NOT NULL,
    PRIMARY KEY CLUSTERED ([TXREMITTANCEACCOUNTADDRESSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TXACCOUNTADDRESSMAILINGADDRESSID] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_TXACCOUNTADDRESSTXREMITTANCEACCOUNTID] FOREIGN KEY ([TXREMITTANCEACCOUNTID]) REFERENCES [dbo].[TXREMITTANCEACCOUNT] ([TXREMITTANCEACCOUNTID])
);

