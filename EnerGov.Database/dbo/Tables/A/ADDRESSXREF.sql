﻿CREATE TABLE [dbo].[ADDRESSXREF] (
    [ADDRESSXREFID] CHAR (36) NOT NULL,
    [ADDRESSTYPEID] CHAR (36) NULL,
    [ADDRESSID]     CHAR (36) NOT NULL,
    [PARCELID]      CHAR (36) NOT NULL,
    CONSTRAINT [PK_AddressXRef_1] PRIMARY KEY CLUSTERED ([ADDRESSXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AddressXRef_AddressType] FOREIGN KEY ([ADDRESSTYPEID]) REFERENCES [dbo].[ADDRESSTYPE] ([ADDRESSTYPEID])
);

