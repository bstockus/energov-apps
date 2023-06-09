﻿CREATE TABLE [dbo].[WORKFLOWACTIONTYPE] (
    [WORKFLOWACTIONTYPEID]   INT           NOT NULL,
    [WORKFLOWACTIONTYPENAME] NVARCHAR (20) NOT NULL,
    [ISSERVER]               BIT           CONSTRAINT [DF_WorkflowActionType_IsServer] DEFAULT ((1)) NOT NULL,
    [ISCLIENT]               BIT           CONSTRAINT [DF_WorkflowActionType_IsClient] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WorkflowActionType] PRIMARY KEY CLUSTERED ([WORKFLOWACTIONTYPEID] ASC) WITH (FILLFACTOR = 90)
);

