﻿CREATE TABLE [dbo].[CMCODECASEADDRESS] (
    [CMCODECASEADDRESSID] CHAR (36) NOT NULL,
    [CMCODECASEID]        CHAR (36) NOT NULL,
    [MAILINGADDRESSID]    CHAR (36) NOT NULL,
    [MAIN]                BIT       NOT NULL,
    CONSTRAINT [PK_CodeAddress] PRIMARY KEY CLUSTERED ([CMCODECASEADDRESSID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Address_CodeCase] FOREIGN KEY ([CMCODECASEID]) REFERENCES [dbo].[CMCODECASE] ([CMCODECASEID]),
    CONSTRAINT [FK_CodeAddress_MailingAddress] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[CMCODECASEADDRESS]([MAILINGADDRESSID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[CMCODECASEADDRESS]([CMCODECASEID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CMCODECASEADDRESS_MAIN]
    ON [dbo].[CMCODECASEADDRESS]([CMCODECASEID] ASC, [MAILINGADDRESSID] ASC, [MAIN] ASC);

