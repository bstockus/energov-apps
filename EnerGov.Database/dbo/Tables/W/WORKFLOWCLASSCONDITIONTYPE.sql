﻿CREATE TABLE [dbo].[WORKFLOWCLASSCONDITIONTYPE] (
    [WORKFLOWCLASSCONDITIONTYPEID] INT           NOT NULL,
    [CLASSCONDITIONTYPENAME]       NVARCHAR (20) NULL,
    CONSTRAINT [PK_WorkflowClassConditionType] PRIMARY KEY CLUSTERED ([WORKFLOWCLASSCONDITIONTYPEID] ASC) WITH (FILLFACTOR = 90)
);

