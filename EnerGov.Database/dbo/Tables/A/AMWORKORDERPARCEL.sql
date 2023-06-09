﻿CREATE TABLE [dbo].[AMWORKORDERPARCEL] (
    [AMWORKORDERPARCELID] CHAR (36) NOT NULL,
    [AMWORKORDERID]       CHAR (36) NOT NULL,
    [PARCELID]            CHAR (36) NOT NULL,
    [MAIN]                BIT       NOT NULL,
    CONSTRAINT [PK_AMWorkOrderParcel] PRIMARY KEY CLUSTERED ([AMWORKORDERPARCELID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWOParcel_Parcel] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID]),
    CONSTRAINT [FK_AMWOParcel_WorkOrder] FOREIGN KEY ([AMWORKORDERID]) REFERENCES [dbo].[AMWORKORDER] ([AMWORKORDERID])
);

