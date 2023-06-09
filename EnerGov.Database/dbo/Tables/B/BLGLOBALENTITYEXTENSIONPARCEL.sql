﻿CREATE TABLE [dbo].[BLGLOBALENTITYEXTENSIONPARCEL] (
    [BLGLOBALENTITYEXTPARCELID] CHAR (36) NOT NULL,
    [PARCELID]                  CHAR (36) NOT NULL,
    [BLGLOBALENTITYEXTENSIONID] CHAR (36) NOT NULL,
    [MAIN]                      BIT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_BLGlobalEntityExtensionParcel] PRIMARY KEY CLUSTERED ([BLGLOBALENTITYEXTPARCELID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_BLGlobalEntityExtensionParcel_BLGlobalEntityExtension] FOREIGN KEY ([BLGLOBALENTITYEXTENSIONID]) REFERENCES [dbo].[BLGLOBALENTITYEXTENSION] ([BLGLOBALENTITYEXTENSIONID]),
    CONSTRAINT [FK_BLGlobalEntityExtensionParcel_Parcel] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BUSINESSPARCEL_BUS]
    ON [dbo].[BLGLOBALENTITYEXTENSIONPARCEL]([BLGLOBALENTITYEXTENSIONID] ASC, [PARCELID] ASC, [MAIN] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[BLGLOBALENTITYEXTENSIONPARCEL]([BLGLOBALENTITYEXTENSIONID] ASC) WITH (FILLFACTOR = 80);

