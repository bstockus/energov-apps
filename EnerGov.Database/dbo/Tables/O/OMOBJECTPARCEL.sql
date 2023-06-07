﻿CREATE TABLE [dbo].[OMOBJECTPARCEL] (
    [OMOBJECTPARCELID] CHAR (36) NOT NULL,
    [OMOBJECTID]       CHAR (36) NOT NULL,
    [PARCELID]         CHAR (36) NOT NULL,
    [MAIN]             BIT       NOT NULL,
    CONSTRAINT [PK_OMOBJECTPARCEL] PRIMARY KEY CLUSTERED ([OMOBJECTPARCELID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OMOBJECTPARCEL_OMOBJECT] FOREIGN KEY ([OMOBJECTID]) REFERENCES [dbo].[OMOBJECT] ([OMOBJECTID]),
    CONSTRAINT [FK_OMOBJECTPARCEL_PARCEL] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID])
);


GO
CREATE NONCLUSTERED INDEX [OMOBJECTPARCEL_IX_OBJECT]
    ON [dbo].[OMOBJECTPARCEL]([OMOBJECTID] ASC, [PARCELID] ASC);
