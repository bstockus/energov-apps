﻿CREATE TABLE [dbo].[WFENTITYACTIONTYPE] (
    [WFENTITYID]     INT NOT NULL,
    [WFACTIONTYPEID] INT NOT NULL,
    CONSTRAINT [PK_WFEntityActionType] PRIMARY KEY CLUSTERED ([WFENTITYID] ASC, [WFACTIONTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_WFEntityActionType_Type] FOREIGN KEY ([WFACTIONTYPEID]) REFERENCES [dbo].[WFACTIONTYPE] ([WFACTIONTYPEID]),
    CONSTRAINT [FK_WFEntityActionType_WFEntity] FOREIGN KEY ([WFENTITYID]) REFERENCES [dbo].[WFENTITY] ([WFENTITYID])
);

