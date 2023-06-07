﻿CREATE TABLE [dbo].[ERSESSIONTRANSACTION] (
    [ERSESSIONTRANSACTIONID] CHAR (36)     NOT NULL,
    [PROCESSTYPE]            INT           NOT NULL,
    [ERENTITYPROJECTID]      VARCHAR (36)  NULL,
    [ERENTITYSESSIONID]      VARCHAR (36)  NULL,
    [CREATEDATE]             DATETIME      NOT NULL,
    [CREATEDBY]              CHAR (36)     NOT NULL,
    [TOTALSTEPS]             INT           CONSTRAINT [DF_ERSessionTransaction_TotalSteps] DEFAULT ((0)) NOT NULL,
    [CURRENTSTEP]            INT           NULL,
    [LASTCHANGEDON]          DATETIME      NULL,
    [PROCESSSTATUS]          INT           NULL,
    [RESULTLOG]              VARCHAR (MAX) NULL,
    [EMAILSENTDATE]          DATETIME      NULL,
    [NUMBEROFATTEMPTS]       INT           DEFAULT ((0)) NOT NULL,
    [PLSUBMITTALID]          CHAR (36)     NULL,
    CONSTRAINT [PK_ERSESSIONTRANSACTIONID] PRIMARY KEY CLUSTERED ([ERSESSIONTRANSACTIONID] ASC),
    CONSTRAINT [FK_ERSESSIONTRANSACTION_ERENTITYPROJECT] FOREIGN KEY ([ERENTITYPROJECTID]) REFERENCES [dbo].[ERENTITYPROJECT] ([ERENTITYPROJECTID]),
    CONSTRAINT [FK_ERSESSIONTRANSACTION_ERENTITYSESSION] FOREIGN KEY ([ERENTITYSESSIONID]) REFERENCES [dbo].[ERENTITYSESSION] ([ERENTITYSESSIONID]),
    CONSTRAINT [FK_ERSESSIONTRANSACTION_PLSUBMITTAL] FOREIGN KEY ([PLSUBMITTALID]) REFERENCES [dbo].[PLSUBMITTAL] ([PLSUBMITTALID]),
    CONSTRAINT [FK_ERSESSIONTRANSACTION_USERS] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ERSESSIONTRANSACTION_ProcessType_SessionID]
    ON [dbo].[ERSESSIONTRANSACTION]([PROCESSTYPE] ASC, [ERENTITYSESSIONID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ERSESSIONTRANSACTION_ProcessType_SubmittalID]
    ON [dbo].[ERSESSIONTRANSACTION]([PROCESSTYPE] ASC, [PLSUBMITTALID] ASC);
