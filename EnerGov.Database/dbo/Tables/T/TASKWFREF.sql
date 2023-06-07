﻿CREATE TABLE [dbo].[TASKWFREF] (
    [TASKWFREFID] CHAR (36)      NOT NULL,
    [TASKID]      CHAR (36)      NOT NULL,
    [TASKWFMSG]   NVARCHAR (200) NULL,
    CONSTRAINT [PK_TaskWFRef] PRIMARY KEY CLUSTERED ([TASKWFREFID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_TaskWFRef_Task] FOREIGN KEY ([TASKID]) REFERENCES [dbo].[TASK] ([TASKID])
);

