﻿CREATE TABLE [dbo].[PLPLANPARCEL] (
    [PLPLANPARCELID]     CHAR (36) NOT NULL,
    [PARCELID]           CHAR (36) NOT NULL,
    [PLPLANID]           CHAR (36) NOT NULL,
    [MAIN]               BIT       NOT NULL,
    [PARCELSPLITPROCESS] BIT       CONSTRAINT [DF_PLPLANPARCEL_PARCELSPLITPROCESS] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PLPlanParcel] PRIMARY KEY CLUSTERED ([PLPLANPARCELID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLPlanParcel_Parcel] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID]),
    CONSTRAINT [FK_PLPlanParcel_PLPlan] FOREIGN KEY ([PLPLANID]) REFERENCES [dbo].[PLPLAN] ([PLPLANID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[PLPLANPARCEL]([PLPLANID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[PLPLANPARCEL]([PARCELID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_PLPLANPARCEL_PLANID_MAIN]
    ON [dbo].[PLPLANPARCEL]([PLPLANID] ASC, [MAIN] ASC)
    INCLUDE([PARCELID]);

