﻿CREATE TABLE [dbo].[RPPROPERTYADDRESS] (
    [RPPROPERTYADDRESSID] CHAR (36) NOT NULL,
    [RPPROPERTYID]        CHAR (36) NOT NULL,
    [MAILINGADDRESSID]    CHAR (36) NOT NULL,
    [MAIN]                BIT       NOT NULL,
    CONSTRAINT [PK_RPPROPERTYADDRESS] PRIMARY KEY NONCLUSTERED ([RPPROPERTYADDRESSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPPROPERTYADDRESS_ADDRESS] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_RPPROPERTYADDRESS_PROPERTY] FOREIGN KEY ([RPPROPERTYID]) REFERENCES [dbo].[RPPROPERTY] ([RPPROPERTYID])
);


GO
CREATE NONCLUSTERED INDEX [NCIDX_RPPROPERTYADDRESS_MAILINGADDRESSID_MAIN_INCL]
    ON [dbo].[RPPROPERTYADDRESS]([MAILINGADDRESSID] ASC, [MAIN] ASC)
    INCLUDE([RPPROPERTYID]) WITH (FILLFACTOR = 90, PAD_INDEX = ON);

