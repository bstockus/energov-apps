﻿CREATE TABLE [dbo].[RPLANDLORDLICENSEADDRESS] (
    [RPLANDLORDLICENSEADDRESSID] CHAR (36) NOT NULL,
    [RPLANDLORDLICENSEID]        CHAR (36) NOT NULL,
    [MAILINGADDRESSID]           CHAR (36) NOT NULL,
    [MAIN]                       BIT       NOT NULL,
    CONSTRAINT [PK_RPLANDLORDLICENSEADDRESS] PRIMARY KEY NONCLUSTERED ([RPLANDLORDLICENSEADDRESSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPLLLICADDR_MAILADDRESS] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_RPLLLICADDR_RPLLLICENSE] FOREIGN KEY ([RPLANDLORDLICENSEID]) REFERENCES [dbo].[RPLANDLORDLICENSE] ([RPLANDLORDLICENSEID])
);

