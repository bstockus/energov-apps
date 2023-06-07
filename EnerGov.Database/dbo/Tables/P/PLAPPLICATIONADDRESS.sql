﻿CREATE TABLE [dbo].[PLAPPLICATIONADDRESS] (
    [PLAPPLICATIONADDRESSID] CHAR (36) NOT NULL,
    [PLAPPLICATIONID]        CHAR (36) NOT NULL,
    [MAILINGADDRESSID]       CHAR (36) NOT NULL,
    [MAIN]                   BIT       NOT NULL,
    CONSTRAINT [PK_PLApplicationAddress] PRIMARY KEY CLUSTERED ([PLAPPLICATIONADDRESSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLApplicationAddress_MailingAddress] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_PLApplicationAddress_PLApplication] FOREIGN KEY ([PLAPPLICATIONID]) REFERENCES [dbo].[PLAPPLICATION] ([PLAPPLICATIONID])
);

