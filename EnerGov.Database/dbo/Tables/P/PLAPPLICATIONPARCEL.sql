﻿CREATE TABLE [dbo].[PLAPPLICATIONPARCEL] (
    [PLAPPLICATIONPARCELID] CHAR (36) NOT NULL,
    [PARCELID]              CHAR (36) NOT NULL,
    [PLAPPLICATIONID]       CHAR (36) NOT NULL,
    [MAIN]                  BIT       NOT NULL,
    CONSTRAINT [PK_PLApplicationParcel] PRIMARY KEY CLUSTERED ([PLAPPLICATIONPARCELID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLApplicationParcel_Parcel] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID]),
    CONSTRAINT [FK_PLApplicationParcel_PLApplication] FOREIGN KEY ([PLAPPLICATIONID]) REFERENCES [dbo].[PLAPPLICATION] ([PLAPPLICATIONID])
);


GO
CREATE NONCLUSTERED INDEX [IX_APPPARCEL_APPID]
    ON [dbo].[PLAPPLICATIONPARCEL]([PLAPPLICATIONID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_APPPARCEL_MAIN]
    ON [dbo].[PLAPPLICATIONPARCEL]([MAIN] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_APPPARCEL_PARCELID]
    ON [dbo].[PLAPPLICATIONPARCEL]([PARCELID] ASC);
