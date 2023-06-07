﻿CREATE TABLE [dbo].[PLPLANWFSTEP] (
    [PLPLANWFSTEPID]         CHAR (36)       NOT NULL,
    [PLPLANID]               CHAR (36)       NOT NULL,
    [WFSTEPTYPEID]           INT             NOT NULL,
    [PRIORITYORDER]          INT             NOT NULL,
    [STARTDATE]              DATETIME        NULL,
    [ENDDATE]                DATETIME        NULL,
    [DESCRIPTION]            NVARCHAR (MAX)  NULL,
    [WORKFLOWSTATUSID]       INT             NOT NULL,
    [ROWVERSION]             INT             NOT NULL,
    [LASTCHANGEDON]          DATETIME        NOT NULL,
    [LASTCHANGEDBY]          CHAR (36)       NOT NULL,
    [REQUIREDSUBPLPLANID]    CHAR (36)       NULL,
    [NAME]                   NVARCHAR (100)  NOT NULL,
    [WORKFLOWCOMPLETETYPEID] INT             NULL,
    [ICON]                   VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]         INT             NULL,
    [PLPLANWFPARENTSTEPID]   CHAR (36)       NULL,
    [VERSIONNUMBER]          INT             NULL,
    [SORTORDER]              INT             DEFAULT ((0)) NOT NULL,
    [GENERALREASON]          NVARCHAR (MAX)  NULL,
    [AUTOCOMPLETED]          BIT             CONSTRAINT [DF_StepAutoCompleted] DEFAULT ((0)) NOT NULL,
    [WFTEMPLATESTEPID]       CHAR (36)       NULL,
    [NOPRIORITY]             BIT             DEFAULT ((0)) NOT NULL,
    [DUEDATE]                DATETIME        NULL,
    [IDENTITYCOLUMN]         BIGINT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PLPlanWFStep] PRIMARY KEY NONCLUSTERED ([PLPLANWFSTEPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PlanWFStep_WFCompType] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID]),
    CONSTRAINT [FK_PLPlanStep_ParentStep] FOREIGN KEY ([PLPLANWFPARENTSTEPID]) REFERENCES [dbo].[PLPLANWFSTEP] ([PLPLANWFSTEPID]),
    CONSTRAINT [FK_PLPlanWFStep_PLPlan] FOREIGN KEY ([PLPLANID]) REFERENCES [dbo].[PLPLAN] ([PLPLANID]),
    CONSTRAINT [FK_PLPlanWFStep_PLSubPlan] FOREIGN KEY ([REQUIREDSUBPLPLANID]) REFERENCES [dbo].[PLPLAN] ([PLPLANID]),
    CONSTRAINT [FK_PLPlanWFStep_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_PLPlanWFStep_WFStepType] FOREIGN KEY ([WFSTEPTYPEID]) REFERENCES [dbo].[WFSTEPTYPE] ([WFSTEPTYPEID]),
    CONSTRAINT [FK_PLPlanWFStep_WFTemplateStep] FOREIGN KEY ([WFTEMPLATESTEPID]) REFERENCES [dbo].[WFTEMPLATESTEP] ([WFTEMPLATESTEPID]),
    CONSTRAINT [FK_PLPlanWFStep_WorkflowStatus] FOREIGN KEY ([WORKFLOWSTATUSID]) REFERENCES [dbo].[WORKFLOWSTATUS] ([WORKFLOWSTATUSID])
);


GO
CREATE CLUSTERED INDEX [CLIDX_PLPLANWFNSTEP_IDCOL]
    ON [dbo].[PLPLANWFSTEP]([IDENTITYCOLUMN] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[PLPLANWFSTEP]([PLPLANID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT3]
    ON [dbo].[PLPLANWFSTEP]([WFSTEPTYPEID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_PLPLANWFSTEP_PLPLANID]
    ON [dbo].[PLPLANWFSTEP]([PLPLANID] ASC);

