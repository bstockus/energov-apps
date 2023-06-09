﻿CREATE TABLE [dbo].[PLPLANZONE] (
    [PLPLANZONEID] CHAR (36) NOT NULL,
    [ZONEID]       CHAR (36) NOT NULL,
    [PLPLANID]     CHAR (36) NOT NULL,
    [MAIN]         BIT       NOT NULL,
    CONSTRAINT [PK_PLPlanZone] PRIMARY KEY CLUSTERED ([PLPLANZONEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLPlanZone_PLPlan] FOREIGN KEY ([PLPLANID]) REFERENCES [dbo].[PLPLAN] ([PLPLANID]),
    CONSTRAINT [FK_PLPlanZone_Zone] FOREIGN KEY ([ZONEID]) REFERENCES [dbo].[ZONE] ([ZONEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PLPLNZONE_PERMIT_ALL]
    ON [dbo].[PLPLANZONE]([PLPLANID] ASC)
    INCLUDE([ZONEID], [MAIN]) WITH (FILLFACTOR = 90);

