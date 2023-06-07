﻿CREATE TABLE [dbo].[CITIZENREQUESTADDRESS] (
    [CITIZENREQUESTADDRESSID] CHAR (36) NOT NULL,
    [CITIZENREQUESTID]        CHAR (36) NOT NULL,
    [MAILINGADDRESSID]        CHAR (36) NOT NULL,
    [MAIN]                    BIT       NOT NULL,
    CONSTRAINT [PK_CitizenRequestAddress] PRIMARY KEY CLUSTERED ([CITIZENREQUESTADDRESSID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CitizenRequestAddress_Address] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_CitizenRequestAddress_CitizenRequest] FOREIGN KEY ([CITIZENREQUESTID]) REFERENCES [dbo].[CITIZENREQUEST] ([CITIZENREQUESTID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[CITIZENREQUESTADDRESS]([MAILINGADDRESSID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[CITIZENREQUESTADDRESS]([CITIZENREQUESTID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NCIDX_CITIZENREQUESTADDRESS_MAILINGADDRESSID_INCL]
    ON [dbo].[CITIZENREQUESTADDRESS]([MAILINGADDRESSID] ASC)
    INCLUDE([CITIZENREQUESTID], [MAIN]) WITH (FILLFACTOR = 90, PAD_INDEX = ON);
