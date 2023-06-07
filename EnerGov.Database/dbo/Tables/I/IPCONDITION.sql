﻿CREATE TABLE [dbo].[IPCONDITION] (
    [IPCONDITIONID]           CHAR (36)       NOT NULL,
    [CONDITIONNUMBER]         NVARCHAR (50)   NOT NULL,
    [IPCONDITIONTYPEID]       CHAR (36)       NOT NULL,
    [IPCASEID]                CHAR (36)       NOT NULL,
    [IPUNITTYPEID]            CHAR (36)       NOT NULL,
    [ASSESSMENTTHRESHOLD]     INT             NOT NULL,
    [UNITASSESSEDTODATE]      DECIMAL (20, 4) NULL,
    [IPCONDITIONSTATUSID]     CHAR (36)       NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX)  NULL,
    [SATISFIEDDATE]           DATETIME        NULL,
    [MONETARY]                BIT             NOT NULL,
    [PARAGRAPH]               NVARCHAR (MAX)  NULL,
    [IPASSESSMENTMILESTONEID] CHAR (36)       NOT NULL,
    [MEMO]                    NVARCHAR (MAX)  NULL,
    [MILESTONEDATE]           DATETIME        NULL,
    [STARTDATE]               DATETIME        NULL,
    [ENDDATE]                 DATETIME        NULL,
    [LASTCHANGEDON]           DATETIME        NOT NULL,
    [LASTCHANGEDBY]           CHAR (36)       NOT NULL,
    [CREATEDDATE]             DATETIME        NOT NULL,
    [CAFEEID]                 CHAR (36)       NULL,
    CONSTRAINT [PK_IPCONDITION] PRIMARY KEY CLUSTERED ([IPCONDITIONID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IPCONDITION_CAFEE] FOREIGN KEY ([CAFEEID]) REFERENCES [dbo].[CAFEE] ([CAFEEID]),
    CONSTRAINT [FK_IPCONDITION_IPASSMILESTONE] FOREIGN KEY ([IPASSESSMENTMILESTONEID]) REFERENCES [dbo].[IPASSESSMENTMILESTONE] ([IPASSESSMENTMILESTONEID]),
    CONSTRAINT [FK_IPCONDITION_IPCASE] FOREIGN KEY ([IPCASEID]) REFERENCES [dbo].[IPCASE] ([IPCASEID]),
    CONSTRAINT [FK_IPCONDITION_IPCONDITIONTYPE] FOREIGN KEY ([IPCONDITIONTYPEID]) REFERENCES [dbo].[IPCONDITIONTYPE] ([IPCONDITIONTYPEID]),
    CONSTRAINT [FK_IPCONDITION_IPCONDSTATUS] FOREIGN KEY ([IPCONDITIONSTATUSID]) REFERENCES [dbo].[IPCONDITIONSTATUS] ([IPCONDITIONSTATUSID]),
    CONSTRAINT [FK_IPCONDITION_UNITTYPE] FOREIGN KEY ([IPUNITTYPEID]) REFERENCES [dbo].[IPUNITTYPE] ([IPUNITTYPEID]),
    CONSTRAINT [FK_IPCONDITION_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_IPCONDITION_IPCASEID]
    ON [dbo].[IPCONDITION]([IPCASEID] ASC);

