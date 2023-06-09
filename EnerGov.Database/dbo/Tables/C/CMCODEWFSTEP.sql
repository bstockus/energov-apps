﻿CREATE TABLE [dbo].[CMCODEWFSTEP] (
    [CMCODEWFSTEPID]         CHAR (36)       NOT NULL,
    [CMCODECASEID]           CHAR (36)       NOT NULL,
    [WFSTEPTYPEID]           INT             NOT NULL,
    [PRIORITYORDER]          INT             NOT NULL,
    [STARTDATE]              DATETIME        NULL,
    [ENDDATE]                DATETIME        NULL,
    [DESCRIPTION]            NVARCHAR (MAX)  NULL,
    [WORKFLOWSTATUSID]       INT             NOT NULL,
    [ROWVERSION]             INT             NOT NULL,
    [LASTCHANGEDON]          DATETIME        NOT NULL,
    [LASTCHANGEDBY]          CHAR (36)       NOT NULL,
    [NAME]                   NVARCHAR (100)  NOT NULL,
    [WORKFLOWCOMPLETETYPEID] INT             NULL,
    [ICON]                   VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]         INT             NULL,
    [CMCODEWFPARENTSTEPID]   CHAR (36)       NULL,
    [VERSIONNUMBER]          INT             NULL,
    [SORTORDER]              INT             NOT NULL,
    [GENERALREASON]          NVARCHAR (MAX)  NULL,
    [AUTOCOMPLETED]          BIT             NOT NULL,
    [WFTEMPLATESTEPID]       CHAR (36)       NULL,
    [CMCODEID]               CHAR (36)       NULL,
    [NOPRIORITY]             BIT             DEFAULT ((0)) NOT NULL,
    [DUEDATE]                DATETIME        NULL,
    [IDENTITYCOLUMN]         BIGINT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_CodeWFStep] PRIMARY KEY NONCLUSTERED ([CMCODEWFSTEPID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CMCodeWFStep_Code] FOREIGN KEY ([CMCODEID]) REFERENCES [dbo].[CMCODE] ([CMCODEID]),
    CONSTRAINT [FK_CMStep_CMCase] FOREIGN KEY ([CMCODECASEID]) REFERENCES [dbo].[CMCODECASE] ([CMCODECASEID]),
    CONSTRAINT [FK_CodeWFStep_TemplateStep] FOREIGN KEY ([WFTEMPLATESTEPID]) REFERENCES [dbo].[WFTEMPLATESTEP] ([WFTEMPLATESTEPID]),
    CONSTRAINT [FK_CodeWFStep_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CodeWFStep_WFStepType] FOREIGN KEY ([WFSTEPTYPEID]) REFERENCES [dbo].[WFSTEPTYPE] ([WFSTEPTYPEID]),
    CONSTRAINT [FK_CodeWFStep_WorkflowCompleteType] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID]),
    CONSTRAINT [FK_CodeWFStep_WorkflowStatus] FOREIGN KEY ([WORKFLOWSTATUSID]) REFERENCES [dbo].[WORKFLOWSTATUS] ([WORKFLOWSTATUSID]),
    CONSTRAINT [FK_ParentStep_Step] FOREIGN KEY ([CMCODEWFPARENTSTEPID]) REFERENCES [dbo].[CMCODEWFSTEP] ([CMCODEWFSTEPID])
);


GO
CREATE CLUSTERED INDEX [CLIDX_CMCODEWFSTEP_IDCOL]
    ON [dbo].[CMCODEWFSTEP]([IDENTITYCOLUMN] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[CMCODEWFSTEP]([CMCODECASEID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NCIDX_CMCODEWFSTEP_CMCODECASEID_NAME_INCL]
    ON [dbo].[CMCODEWFSTEP]([CMCODECASEID] ASC, [NAME] ASC)
    INCLUDE([CMCODEWFSTEPID]) WITH (FILLFACTOR = 90, PAD_INDEX = ON);

