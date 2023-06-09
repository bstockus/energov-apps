﻿CREATE TABLE [dbo].[BLLICENSEADDRESS] (
    [BLLICENSEADDRESSID] CHAR (36) NOT NULL,
    [BLLICENSEID]        CHAR (36) NOT NULL,
    [MAILINGADDRESSID]   CHAR (36) NOT NULL,
    [MAIN]               BIT       NOT NULL,
    CONSTRAINT [PK_BLLicenseAddress] PRIMARY KEY CLUSTERED ([BLLICENSEADDRESSID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_BLLicAddr_BLLicense] FOREIGN KEY ([BLLICENSEID]) REFERENCES [dbo].[BLLICENSE] ([BLLICENSEID]),
    CONSTRAINT [FK_BLLicAddr_MailAddr] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICADD_LICENSE]
    ON [dbo].[BLLICENSEADDRESS]([BLLICENSEID] ASC, [MAILINGADDRESSID] ASC, [MAIN] ASC) WITH (FILLFACTOR = 80);

