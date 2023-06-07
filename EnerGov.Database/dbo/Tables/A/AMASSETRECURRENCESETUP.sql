﻿CREATE TABLE [dbo].[AMASSETRECURRENCESETUP] (
    [AMASSETRECURRENCESETUPID] CHAR (36)  NOT NULL,
    [NAME]                     CHAR (100) NOT NULL,
    [RECURRENCEID]             CHAR (36)  NOT NULL,
    [WORKFLOWID]               CHAR (36)  NULL,
    [AMWORKORDERID]            CHAR (36)  NULL,
    [SUPERVISOR]               CHAR (36)  NULL,
    [SUBMITTEDTO]              CHAR (36)  NULL,
    [ASSIGNEDTO]               CHAR (36)  NULL,
    CONSTRAINT [PK_AMAssetRecurrenceSetUp] PRIMARY KEY CLUSTERED ([AMASSETRECURRENCESETUPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMAssetRecurrenceSetUp_WorkOrder] FOREIGN KEY ([AMWORKORDERID]) REFERENCES [dbo].[AMWORKORDER] ([AMWORKORDERID]),
    CONSTRAINT [FK_AMAstRecurSetUp_Recurrence] FOREIGN KEY ([RECURRENCEID]) REFERENCES [dbo].[RECURRENCE] ([RECURRENCEID]),
    CONSTRAINT [FK_AssignedTo_Users] FOREIGN KEY ([ASSIGNEDTO]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SubmittedTo_Users] FOREIGN KEY ([SUBMITTEDTO]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_Supervisor_Users] FOREIGN KEY ([SUPERVISOR]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_WorkFlowID_Workflow] FOREIGN KEY ([WORKFLOWID]) REFERENCES [dbo].[WORKFLOW] ([WORKFLOWID])
);

