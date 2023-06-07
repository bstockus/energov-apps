﻿CREATE TABLE [dbo].[AMWORKORDERWFACTIONSTEP] (
    [AMWORKORDERWFACTIONSTEPID]    CHAR (36)       NOT NULL,
    [AMWORKORDERWFSTEPID]          CHAR (36)       NOT NULL,
    [WFACTIONTYPEID]               INT             NOT NULL,
    [DESCRIPTION]                  NVARCHAR (MAX)  NULL,
    [PRIORITYORDER]                INT             NOT NULL,
    [STARTDATE]                    DATETIME        NULL,
    [ENDDATE]                      DATETIME        NULL,
    [ROWVERSION]                   INT             NOT NULL,
    [LASTCHANGEDON]                DATETIME        NOT NULL,
    [LASTCHANGEDBY]                CHAR (36)       NOT NULL,
    [WORKFLOWSTATUSID]             INT             NOT NULL,
    [LOCATION]                     NVARCHAR (50)   NULL,
    [EXPECTEDDURATIONHOURS]        DECIMAL (6, 2)  NULL,
    [EVENTDATE]                    DATETIME        NULL,
    [NAME]                         NVARCHAR (100)  NOT NULL,
    [HEARINGTYPEID]                CHAR (36)       NULL,
    [PASSDESCRIPTION]              NVARCHAR (30)   NOT NULL,
    [FAILDESCRIPTION]              NVARCHAR (30)   NOT NULL,
    [ALLOWREDO]                    BIT             NOT NULL,
    [REDODESCRIPTION]              NVARCHAR (30)   NULL,
    [ICON]                         VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]               INT             NULL,
    [PLSUBMITTALTYPEID]            CHAR (36)       NULL,
    [MEETINGTYPEID]                CHAR (36)       NULL,
    [AMWORKORDERWFPARENTACTSTEPID] CHAR (36)       NULL,
    [VERSIONNUMBER]                INT             NULL,
    [SORTORDER]                    INT             NOT NULL,
    [GENERALREASON]                NVARCHAR (MAX)  NULL,
    [AUTORECEIVE]                  BIT             NOT NULL,
    [AUTOCOMPLETED]                BIT             NOT NULL,
    [WORKFLOWCOMPLETETYPEID]       INT             NULL,
    [IMINSPECTIONTYPEID]           CHAR (36)       NULL,
    [PMPERMITTYPEID]               CHAR (36)       NULL,
    [PMPERMITWORKCLASSID]          CHAR (36)       NULL,
    [RPTREPORTID]                  CHAR (36)       NULL,
    [PLPLANTYPEID]                 CHAR (36)       NULL,
    [PLPLANWORKCLASSID]            CHAR (36)       NULL,
    [TASKTYPEID]                   CHAR (36)       NULL,
    [DUEDATE]                      DATETIME        NULL,
    [PARENTINSPECTIONNUMBER]       NVARCHAR (50)   NULL,
    [COMPUTEFEEACTIONTYPEID]       INT             DEFAULT ((0)) NULL,
    [ISUSEACTIONDATEASFEEDATE]     BIT             DEFAULT ((0)) NOT NULL,
    [ISCOMPUTEMAINFEETEMPLATE]     BIT             DEFAULT ((0)) NOT NULL,
    [INSPECTIONSET]                INT             CONSTRAINT [DF_AMWORKORDERWFACTIONSTEP_SET] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AMWorkOrderWFActionStep] PRIMARY KEY CLUSTERED ([AMWORKORDERWFACTIONSTEPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWFACT_ACTIONTYPEID] FOREIGN KEY ([COMPUTEFEEACTIONTYPEID]) REFERENCES [dbo].[WFACTIONSYSTEMTYPE] ([WFACTIONSYSTEMTYPEID]),
    CONSTRAINT [FK_AMWOWFActionStep_Step] FOREIGN KEY ([AMWORKORDERWFSTEPID]) REFERENCES [dbo].[AMWORKORDERWFSTEP] ([AMWORKORDERWFSTEPID]),
    CONSTRAINT [FK_AMWOWFActStep_ActStep] FOREIGN KEY ([AMWORKORDERWFPARENTACTSTEPID]) REFERENCES [dbo].[AMWORKORDERWFACTIONSTEP] ([AMWORKORDERWFACTIONSTEPID]),
    CONSTRAINT [FK_AMWOWFActStep_ActType] FOREIGN KEY ([WFACTIONTYPEID]) REFERENCES [dbo].[WFACTIONTYPE] ([WFACTIONTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_HearingType] FOREIGN KEY ([HEARINGTYPEID]) REFERENCES [dbo].[HEARINGTYPE] ([HEARINGTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_InspectType] FOREIGN KEY ([IMINSPECTIONTYPEID]) REFERENCES [dbo].[IMINSPECTIONTYPE] ([IMINSPECTIONTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_MeetingType] FOREIGN KEY ([MEETINGTYPEID]) REFERENCES [dbo].[MEETINGTYPE] ([MEETINGTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_PermitType] FOREIGN KEY ([PMPERMITTYPEID]) REFERENCES [dbo].[PMPERMITTYPE] ([PMPERMITTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_PerWorkClass] FOREIGN KEY ([PMPERMITWORKCLASSID]) REFERENCES [dbo].[PMPERMITWORKCLASS] ([PMPERMITWORKCLASSID]),
    CONSTRAINT [FK_AMWOWFActStep_PlanType] FOREIGN KEY ([PLPLANTYPEID]) REFERENCES [dbo].[PLPLANTYPE] ([PLPLANTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_PLSubType] FOREIGN KEY ([PLSUBMITTALTYPEID]) REFERENCES [dbo].[PLSUBMITTALTYPE] ([PLSUBMITTALTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_PLWorkClass] FOREIGN KEY ([PLPLANWORKCLASSID]) REFERENCES [dbo].[PLPLANWORKCLASS] ([PLPLANWORKCLASSID]),
    CONSTRAINT [FK_AMWOWFActStep_RPTReport] FOREIGN KEY ([RPTREPORTID]) REFERENCES [dbo].[RPTREPORT] ([RPTREPORTID]),
    CONSTRAINT [FK_AMWOWFActStep_TaskType] FOREIGN KEY ([TASKTYPEID]) REFERENCES [dbo].[TASKTYPE] ([TASKTYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_AMWOWFActStep_WFCompType] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID]),
    CONSTRAINT [FK_AMWOWFActStep_WFStatus] FOREIGN KEY ([WORKFLOWSTATUSID]) REFERENCES [dbo].[WORKFLOWSTATUS] ([WORKFLOWSTATUSID])
);
