﻿CREATE TABLE [dbo].[ILLICENSEWFSTEP] (
    [ILLICENSEWFSTEPID]       CHAR (36)       NOT NULL,
    [ILLICENSEID]             CHAR (36)       NOT NULL,
    [WFTEMPLATESTEPID]        CHAR (36)       NULL,
    [WFSTEPTYPEID]            INT             NOT NULL,
    [PRIORITYORDER]           INT             NOT NULL,
    [STARTDATE]               DATETIME        NULL,
    [ENDDATE]                 DATETIME        NULL,
    [DESCRIPTION]             NVARCHAR (MAX)  NULL,
    [WORKFLOWSTATUSID]        INT             NOT NULL,
    [ROWVERSION]              INT             NOT NULL,
    [LASTCHANGEDON]           DATETIME        NOT NULL,
    [LASTCHANGEDBY]           CHAR (36)       NOT NULL,
    [NAME]                    NVARCHAR (100)  NOT NULL,
    [WORKFLOWCOMPLETETYPEID]  INT             NULL,
    [ICON]                    VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]          INT             NULL,
    [ILLICENSEWFPARENTSTEPID] CHAR (36)       NULL,
    [VERSIONNUMBER]           INT             NULL,
    [SORTORDER]               INT             NOT NULL,
    [GENERALREASON]           NVARCHAR (MAX)  NULL,
    [AUTOCOMPLETED]           BIT             NOT NULL,
    [NOPRIORITY]              BIT             CONSTRAINT [DF_ILLICENSEWFSTEP_NOPRIORITY] DEFAULT ((0)) NOT NULL,
    [DUEDATE]                 DATETIME        NULL,
    CONSTRAINT [PK_ILLICENSEWFSTEP] PRIMARY KEY CLUSTERED ([ILLICENSEWFSTEPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ILLICENSEWFSTEP_ILLICENSE] FOREIGN KEY ([ILLICENSEID]) REFERENCES [dbo].[ILLICENSE] ([ILLICENSEID]),
    CONSTRAINT [FK_ILLICENSEWFSTEP_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_ILLICENSEWFSTEP_WORKFLOWSTATUS] FOREIGN KEY ([WORKFLOWSTATUSID]) REFERENCES [dbo].[WORKFLOWSTATUS] ([WORKFLOWSTATUSID]),
    CONSTRAINT [FK_ILLICWFSTEP_ILLICWFSTEP] FOREIGN KEY ([ILLICENSEWFPARENTSTEPID]) REFERENCES [dbo].[ILLICENSEWFSTEP] ([ILLICENSEWFSTEPID]),
    CONSTRAINT [FK_ILLICWFSTEP_WFCOMPTYPE] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID]),
    CONSTRAINT [FK_ILLICWFSTEP_WFSTEPTYPE] FOREIGN KEY ([WFSTEPTYPEID]) REFERENCES [dbo].[WFSTEPTYPE] ([WFSTEPTYPEID]),
    CONSTRAINT [FK_ILLICWFSTEP_WFTEMPSTEP] FOREIGN KEY ([WFTEMPLATESTEPID]) REFERENCES [dbo].[WFTEMPLATESTEP] ([WFTEMPLATESTEPID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ILLICENSESTEP_LIC]
    ON [dbo].[ILLICENSEWFSTEP]([ILLICENSEID] ASC) WITH (FILLFACTOR = 90);

