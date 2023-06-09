﻿CREATE TABLE [dbo].[SCHEDULEACTION] (
    [SCHEDULEACTIONID] CHAR (36)    NOT NULL,
    [CREATEDDATE]      DATETIME     NOT NULL,
    [RUNDATE]          DATETIME     NULL,
    [ACTIONKEY]        CHAR (36)    NOT NULL,
    [ACTIONTABLE]      VARCHAR (50) NOT NULL,
    [ACTIONDATE]       DATETIME     NOT NULL,
    CONSTRAINT [PK_ScheduleAction] PRIMARY KEY CLUSTERED ([SCHEDULEACTIONID] ASC) WITH (FILLFACTOR = 90)
);

