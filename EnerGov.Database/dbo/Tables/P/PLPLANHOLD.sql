﻿CREATE TABLE [dbo].[PLPLANHOLD] (
    [PLPLANHOLDID]       CHAR (36)      NOT NULL,
    [PLPLANID]           CHAR (36)      NOT NULL,
    [HOLDSETUPID]        CHAR (36)      NULL,
    [ORIGIN]             CHAR (36)      NULL,
    [ORIGINNUMBER]       NVARCHAR (150) NULL,
    [SUSERGUID]          CHAR (36)      NULL,
    [COMMENTS]           NVARCHAR (MAX) NULL,
    [CREATEDDATE]        DATETIME       NULL,
    [EFFECTIVEENDDATE]   DATETIME       NULL,
    [ACTIVE]             BIT            CONSTRAINT [DF_PLPlanHold_Active] DEFAULT ((1)) NOT NULL,
    [HOLDSEVERITYID]     INT            DEFAULT ((1)) NOT NULL,
    [COPYTOSUBRECORD]    BIT            CONSTRAINT [DF_PLPlanHold_COPYTOSUBRECORD] DEFAULT ((1)) NOT NULL,
    [ORIGINCMCODECASEID] CHAR (36)      NULL,
    CONSTRAINT [PK_PLPlanHold] PRIMARY KEY CLUSTERED ([PLPLANHOLDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLPlanHold_Hold] FOREIGN KEY ([HOLDSETUPID]) REFERENCES [dbo].[HOLDTYPESETUPS] ([HOLDSETUPID]),
    CONSTRAINT [FK_PLPlanHold_HoldSeverity] FOREIGN KEY ([HOLDSEVERITYID]) REFERENCES [dbo].[HOLDSEVERITY] ([HOLDSEVERITYID]),
    CONSTRAINT [FK_PLPlanHold_OriginCodeCase] FOREIGN KEY ([ORIGINCMCODECASEID]) REFERENCES [dbo].[CMCODECASE] ([CMCODECASEID]),
    CONSTRAINT [FK_PLPlanHold_PLPlan] FOREIGN KEY ([PLPLANID]) REFERENCES [dbo].[PLPLAN] ([PLPLANID]),
    CONSTRAINT [FK_PLPlanHold_User] FOREIGN KEY ([SUSERGUID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PLPLANHOLD_PLPLANID]
    ON [dbo].[PLPLANHOLD]([PLPLANID] ASC)
    INCLUDE([PLPLANHOLDID]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_PLPLANHOLD_ORIGINCMCODECASEID]
    ON [dbo].[PLPLANHOLD]([ORIGINCMCODECASEID] ASC)
    INCLUDE([PLPLANHOLDID]);
