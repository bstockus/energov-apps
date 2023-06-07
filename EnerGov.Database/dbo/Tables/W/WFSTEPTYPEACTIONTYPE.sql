﻿CREATE TABLE [dbo].[WFSTEPTYPEACTIONTYPE] (
    [WFSTEPTYPEID]   INT NOT NULL,
    [WFACTIONTYPEID] INT NOT NULL,
    CONSTRAINT [PK_WFStepTypeActionType] PRIMARY KEY CLUSTERED ([WFSTEPTYPEID] ASC, [WFACTIONTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_WFStepActionType_ActType] FOREIGN KEY ([WFACTIONTYPEID]) REFERENCES [dbo].[WFACTIONTYPE] ([WFACTIONTYPEID]),
    CONSTRAINT [FK_WFStepActionType_StepType] FOREIGN KEY ([WFSTEPTYPEID]) REFERENCES [dbo].[WFSTEPTYPE] ([WFSTEPTYPEID])
);
