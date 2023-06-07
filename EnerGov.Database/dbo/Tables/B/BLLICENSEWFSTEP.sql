﻿CREATE TABLE [dbo].[BLLICENSEWFSTEP] (
    [BLLICENSEWFSTEPID]       CHAR (36)       NOT NULL,
    [BLLICENSEID]             CHAR (36)       NOT NULL,
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
    [REQUIREDSUBPLPLANID]     CHAR (36)       NULL,
    [NAME]                    NVARCHAR (100)  NOT NULL,
    [WORKFLOWCOMPLETETYPEID]  INT             NULL,
    [ICON]                    VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]          INT             NULL,
    [BLLICENSEWFPARENTSTEPID] CHAR (36)       NULL,
    [VERSIONNUMBER]           INT             NULL,
    [SORTORDER]               INT             NOT NULL,
    [GENERALREASON]           NVARCHAR (MAX)  NULL,
    [AUTOCOMPLETED]           BIT             NOT NULL,
    [NOPRIORITY]              BIT             DEFAULT ((0)) NOT NULL,
    [DUEDATE]                 DATETIME        NULL,
    [IDENTITYCOLUMN]          BIGINT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_BLLicenseWFStep] PRIMARY KEY NONCLUSTERED ([BLLICENSEWFSTEPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLLicenseWFStep_BLLicense] FOREIGN KEY ([BLLICENSEID]) REFERENCES [dbo].[BLLICENSE] ([BLLICENSEID]),
    CONSTRAINT [FK_BLLicenseWFStep_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_BLLicWFStep_BLLicWFStep] FOREIGN KEY ([BLLICENSEWFPARENTSTEPID]) REFERENCES [dbo].[BLLICENSEWFSTEP] ([BLLICENSEWFSTEPID]),
    CONSTRAINT [FK_BLLicWFStep_WFCompType] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID]),
    CONSTRAINT [FK_BLLicWFStep_WFStatus] FOREIGN KEY ([WORKFLOWSTATUSID]) REFERENCES [dbo].[WORKFLOWSTATUS] ([WORKFLOWSTATUSID]),
    CONSTRAINT [FK_BLLicWFStep_WFStepType] FOREIGN KEY ([WFSTEPTYPEID]) REFERENCES [dbo].[WFSTEPTYPE] ([WFSTEPTYPEID]),
    CONSTRAINT [FK_BLLicWFStep_WFTempStep] FOREIGN KEY ([WFTEMPLATESTEPID]) REFERENCES [dbo].[WFTEMPLATESTEP] ([WFTEMPLATESTEPID])
);


GO
CREATE CLUSTERED INDEX [CLIDX_BLLICENSEWFSTEP_IDCOL]
    ON [dbo].[BLLICENSEWFSTEP]([IDENTITYCOLUMN] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICENSESTEP_LIC]
    ON [dbo].[BLLICENSEWFSTEP]([BLLICENSEID] ASC, [BLLICENSEWFSTEPID] ASC) WITH (FILLFACTOR = 90);

