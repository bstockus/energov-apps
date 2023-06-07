﻿CREATE TABLE [dbo].[AMWORKORDERWFSTEP] (
    [AMWORKORDERWFSTEPID]       CHAR (36)       NOT NULL,
    [AMWORKORDERID]             CHAR (36)       NOT NULL,
    [WFTEMPLATESTEPID]          CHAR (36)       NULL,
    [WFSTEPTYPEID]              INT             NOT NULL,
    [PRIORITYORDER]             INT             NOT NULL,
    [STARTDATE]                 DATETIME        NULL,
    [ENDDATE]                   DATETIME        NULL,
    [DESCRIPTION]               NVARCHAR (MAX)  NULL,
    [WORKFLOWSTATUSID]          INT             NOT NULL,
    [ROWVERSION]                INT             NOT NULL,
    [LASTCHANGEDON]             DATETIME        NOT NULL,
    [LASTCHANGEDBY]             CHAR (36)       NOT NULL,
    [REQUIREDSUBPLPLANID]       CHAR (36)       NULL,
    [NAME]                      NVARCHAR (100)  NOT NULL,
    [WORKFLOWCOMPLETETYPEID]    INT             NULL,
    [ICON]                      VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]            INT             NULL,
    [AMWORKORDERWFPARENTSTEPID] CHAR (36)       NULL,
    [VERSIONNUMBER]             INT             NULL,
    [SORTORDER]                 INT             NOT NULL,
    [GENERALREASON]             NVARCHAR (MAX)  NULL,
    [AUTOCOMPLETED]             BIT             NOT NULL,
    [DUEDATE]                   DATETIME        NULL,
    CONSTRAINT [PK_AMWorkOrderWFStep] PRIMARY KEY CLUSTERED ([AMWORKORDERWFSTEPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWorkOrderWFStep_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_AMWOWFStep_ParentStep] FOREIGN KEY ([AMWORKORDERWFPARENTSTEPID]) REFERENCES [dbo].[AMWORKORDERWFSTEP] ([AMWORKORDERWFSTEPID]),
    CONSTRAINT [FK_AMWOWFStep_StepType] FOREIGN KEY ([WFSTEPTYPEID]) REFERENCES [dbo].[WFSTEPTYPE] ([WFSTEPTYPEID]),
    CONSTRAINT [FK_AMWOWFStep_TemplateStep] FOREIGN KEY ([WFTEMPLATESTEPID]) REFERENCES [dbo].[WFTEMPLATESTEP] ([WFTEMPLATESTEPID]),
    CONSTRAINT [FK_AMWOWFStep_WFCompleteType] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID]),
    CONSTRAINT [FK_AMWOWFStep_WFStatus] FOREIGN KEY ([WORKFLOWSTATUSID]) REFERENCES [dbo].[WORKFLOWSTATUS] ([WORKFLOWSTATUSID]),
    CONSTRAINT [FK_AMWOWFStep_WorkOrder] FOREIGN KEY ([AMWORKORDERID]) REFERENCES [dbo].[AMWORKORDER] ([AMWORKORDERID])
);
