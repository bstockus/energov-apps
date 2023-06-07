﻿CREATE TABLE [dbo].[WORKFLOWRUNHISTORY] (
    [WORKFLOWRUNHISTORYID] CHAR (36)      NOT NULL,
    [WORKFLOWNAME]         NVARCHAR (50)  NOT NULL,
    [ACTIONNAME]           NVARCHAR (50)  NOT NULL,
    [CLASSNAME]            NVARCHAR (MAX) NOT NULL,
    [UNIQUERECORDID]       CHAR (36)      NOT NULL,
    [USERID]               CHAR (36)      NOT NULL,
    [DATERUN]              DATETIME       NOT NULL,
    CONSTRAINT [PK_WorkflowRunHistory] PRIMARY KEY CLUSTERED ([WORKFLOWRUNHISTORYID] ASC) WITH (FILLFACTOR = 90)
);
