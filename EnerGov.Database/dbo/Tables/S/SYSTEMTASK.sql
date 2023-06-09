﻿CREATE TABLE [dbo].[SYSTEMTASK] (
    [SYSTEMTASKID]      CHAR (36)      NOT NULL,
    [SYSTEMTASKTYPEID]  INT            NOT NULL,
    [PROCESSTYPE]       INT            NOT NULL,
    [STARTDATE]         DATETIME       NULL,
    [DUEDATE]           DATETIME       NULL,
    [ASSIGNEDTO]        CHAR (36)      NULL,
    [TEAMASSIGNEDTO]    CHAR (36)      NULL,
    [CREATEDBYID]       CHAR (36)      NOT NULL,
    [CREATEDON]         DATETIME       NOT NULL,
    [UNIQUERECORDID]    CHAR (36)      NULL,
    [COMPLETEDDATE]     DATETIME       NULL,
    [COMPLETEDBY]       CHAR (36)      NULL,
    [COMMENTS]          NVARCHAR (MAX) NULL,
    [ATTENTIONRESOLVED] BIT            CONSTRAINT [DF_SYSTEMTASK_ATTENTIONRESOLVED] DEFAULT ((0)) NOT NULL,
    [SNOOZETYPEID]      INT            NULL,
    [SNOOZEUNTILDATE]   DATETIME       NULL,
    CONSTRAINT [PK_SystemTask] PRIMARY KEY CLUSTERED ([SYSTEMTASKID] ASC),
    CONSTRAINT [FK_SystemTask_AssignedToUsers] FOREIGN KEY ([ASSIGNEDTO]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SystemTask_CompletedBy] FOREIGN KEY ([COMPLETEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SystemTask_SnoozeType] FOREIGN KEY ([SNOOZETYPEID]) REFERENCES [dbo].[SNOOZETYPE] ([SNOOZETYPEID]),
    CONSTRAINT [FK_SystemTask_SystemTaskType] FOREIGN KEY ([SYSTEMTASKTYPEID]) REFERENCES [dbo].[SYSTEMTASKTYPE] ([SYSTEMTASKTYPEID]),
    CONSTRAINT [FK_SystemTask_TeamAssignedTo] FOREIGN KEY ([TEAMASSIGNEDTO]) REFERENCES [dbo].[TEAM] ([TEAMID]),
    CONSTRAINT [FK_SystemTask_Users] FOREIGN KEY ([CREATEDBYID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SYSTEMTASK_ASSIGNEDTO]
    ON [dbo].[SYSTEMTASK]([ASSIGNEDTO] ASC)
    INCLUDE([SYSTEMTASKTYPEID], [TEAMASSIGNEDTO], [UNIQUERECORDID], [COMPLETEDDATE], [SNOOZETYPEID], [SNOOZEUNTILDATE]);


GO
CREATE NONCLUSTERED INDEX [IX_SYSTEMTASK_ASSIGNEDTO_COMPLETED_DUE]
    ON [dbo].[SYSTEMTASK]([ASSIGNEDTO] ASC, [COMPLETEDDATE] ASC, [DUEDATE] ASC, [CREATEDON] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SYSTEMTASK_SNOOZETYPEID_SYSTEMTASKID]
    ON [dbo].[SYSTEMTASK]([SNOOZETYPEID] ASC, [SYSTEMTASKTYPEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SYSTEMTASK_SYSTEMTASKTYPEID]
    ON [dbo].[SYSTEMTASK]([SYSTEMTASKTYPEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SYSTEMTASK_UNIQUERECORDID]
    ON [dbo].[SYSTEMTASK]([UNIQUERECORDID] ASC)
    INCLUDE([ASSIGNEDTO], [TEAMASSIGNEDTO], [COMPLETEDDATE], [SNOOZETYPEID], [SNOOZEUNTILDATE]);


GO
CREATE NONCLUSTERED INDEX [SYSTEMTASK_COMPLETEDDATE_DUEDATE]
    ON [dbo].[SYSTEMTASK]([COMPLETEDDATE] ASC, [DUEDATE] ASC);

