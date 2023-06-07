﻿CREATE TABLE [dbo].[PLPLANWFACTIONSTEPENTITY] (
    [PLPLANWFACTIONSTEPENTITYID] CHAR (36) NOT NULL,
    [GLOBALENTITYID]             CHAR (36) NOT NULL,
    [PLPLANWFACTIONSTEPID]       CHAR (36) NOT NULL,
    CONSTRAINT [PK_PLPlanWFActionStepEntity] PRIMARY KEY CLUSTERED ([PLPLANWFACTIONSTEPENTITYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ActionStep_GlobalEntity] FOREIGN KEY ([GLOBALENTITYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID]),
    CONSTRAINT [FK_ActionStepEntity_ActionStep] FOREIGN KEY ([PLPLANWFACTIONSTEPID]) REFERENCES [dbo].[PLPLANWFACTIONSTEP] ([PLPLANWFACTIONSTEPID])
);
