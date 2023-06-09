﻿CREATE TABLE [dbo].[AMWORKORDERASSETXREF] (
    [AMWORKORDERASSETXREFID] CHAR (36) NOT NULL,
    [AMWORKORDERID]          CHAR (36) NOT NULL,
    [AMASSETID]              CHAR (36) NOT NULL,
    [COSTALLOCATION]         INT       NULL,
    [TIMEALLOCATION]         INT       NULL,
    CONSTRAINT [PK_AMWorkOrderAssetXRef] PRIMARY KEY NONCLUSTERED ([AMWORKORDERASSETXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWorkOrderAssetXRef_AMAsse] FOREIGN KEY ([AMASSETID]) REFERENCES [dbo].[AMASSET] ([AMASSETID]),
    CONSTRAINT [FK_AMWorkOrderAssetXRef_AMWork] FOREIGN KEY ([AMWORKORDERID]) REFERENCES [dbo].[AMWORKORDER] ([AMWORKORDERID])
);


GO
CREATE NONCLUSTERED INDEX [IX_OrderAssetXRef_AMAssetID]
    ON [dbo].[AMWORKORDERASSETXREF]([AMASSETID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_OrderAssetXRef_OrderID]
    ON [dbo].[AMWORKORDERASSETXREF]([AMWORKORDERID] ASC) WITH (FILLFACTOR = 90);

