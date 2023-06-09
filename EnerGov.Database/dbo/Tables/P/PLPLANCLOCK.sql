﻿CREATE TABLE [dbo].[PLPLANCLOCK] (
    [PLANCLOCKID]   CHAR (36)     NOT NULL,
    [REASON]        VARCHAR (MAX) NULL,
    [CREATEDBY]     CHAR (36)     NULL,
    [ELAPSEDDAYS]   INT           NULL,
    [PLANID]        CHAR (36)     NULL,
    [STOPPEDDT]     DATETIME      NULL,
    [STOPPEDREASON] VARCHAR (MAX) NULL,
    [STOPPEDBY]     CHAR (36)     NULL,
    [STARTDT]       DATETIME      NULL,
    CONSTRAINT [PK_PLPlanClock] PRIMARY KEY CLUSTERED ([PLANCLOCKID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLPlanClock_PLPlan] FOREIGN KEY ([PLANID]) REFERENCES [dbo].[PLPLAN] ([PLPLANID]),
    CONSTRAINT [FK_PLPlanClock_StopUsers] FOREIGN KEY ([STOPPEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_PLPlanClock_Users] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

