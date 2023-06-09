﻿CREATE TABLE [dbo].[CUSTOMEVENTQUEUE] (
    [CUSTOMEVENTQUEUEID]  BIGINT    IDENTITY (1, 1) NOT NULL,
    [RECORDID]            CHAR (36) NOT NULL,
    [CUSTOMEVENTTYPEID]   INT       NOT NULL,
    [EVENTSTATUSID]       INT       NOT NULL,
    [CREATEDDATE]         DATETIME  NOT NULL,
    [PROCESSEDDATE]       DATETIME  NULL,
    [RECORDLASTCHANGEDBY] CHAR (36) NULL,
    CONSTRAINT [PK_CUSTOMEVENTQUEUE] PRIMARY KEY CLUSTERED ([CUSTOMEVENTQUEUEID] ASC),
    CONSTRAINT [FK_CUSTOMEVENTQUEUE_CUSTOMEVENTTYPE] FOREIGN KEY ([CUSTOMEVENTTYPEID]) REFERENCES [dbo].[CUSTOMEVENTTYPE] ([CUSTOMEVENTTYPEID]),
    CONSTRAINT [FK_CUSTOMEVENTQUEUE_EVENTSTATUS] FOREIGN KEY ([EVENTSTATUSID]) REFERENCES [dbo].[EVENTSTATUS] ([EVENTSTATUSID]),
    CONSTRAINT [FK_CUSTOMEVENTQUEUE_USERS] FOREIGN KEY ([RECORDLASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTOMEVENTQUEUE_PROCESSEDDATE]
    ON [dbo].[CUSTOMEVENTQUEUE]([PROCESSEDDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTOMEVENTQUEUE_CREATEDDATE]
    ON [dbo].[CUSTOMEVENTQUEUE]([CREATEDDATE] ASC);

