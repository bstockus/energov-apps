﻿CREATE TABLE [dbo].[PERMITEVENTQUEUE] (
    [PERMITEVENTQUEUEID]  BIGINT        IDENTITY (1, 1) NOT NULL,
    [PMPERMITID]          CHAR (36)     NOT NULL,
    [PERMITNUMBER]        NVARCHAR (50) NULL,
    [PERMITEVENTTYPEID]   INT           NOT NULL,
    [EVENTSTATUSID]       INT           NOT NULL,
    [CREATEDDATE]         DATETIME      NOT NULL,
    [PROCESSEDDATE]       DATETIME      NULL,
    [PERMITLASTCHANGEDBY] CHAR (36)     NULL,
    CONSTRAINT [PK_PERMITEVENTQUEUE] PRIMARY KEY CLUSTERED ([PERMITEVENTQUEUEID] ASC),
    CONSTRAINT [FK_PermitEventQueue_EventStatus] FOREIGN KEY ([EVENTSTATUSID]) REFERENCES [dbo].[EVENTSTATUS] ([EVENTSTATUSID]),
    CONSTRAINT [FK_PermitEventQueue_PermitEventType] FOREIGN KEY ([PERMITEVENTTYPEID]) REFERENCES [dbo].[PERMITEVENTTYPE] ([PERMITEVENTTYPEID]),
    CONSTRAINT [FK_PermitEventQueue_Users] FOREIGN KEY ([PERMITLASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PERMITEVENTQUEUE_CREATEDDATE]
    ON [dbo].[PERMITEVENTQUEUE]([CREATEDDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PERMITEVENTQUEUE_PMPERMITID]
    ON [dbo].[PERMITEVENTQUEUE]([PMPERMITID] ASC);


GO
CREATE NONCLUSTERED INDEX [PERMITEVENTQUEUE_PROCESSEDDATE]
    ON [dbo].[PERMITEVENTQUEUE]([PROCESSEDDATE] ASC);

