﻿CREATE TABLE [dbo].[FOINSPECTIONQUEUE] (
    [FOINSPECTIONQUEUEID] INT            IDENTITY (1, 1) NOT NULL,
    [IMINSPECTIONTYPEID]  CHAR (36)      NOT NULL,
    [INSPECTIONSTARTDATE] DATETIME       NOT NULL,
    [INSPECTORID]         CHAR (36)      NULL,
    [FIREOCCUPANCYID]     CHAR (36)      NOT NULL,
    [FIREOCCUPANCYNUMBER] NVARCHAR (100) NOT NULL,
    [INSPECTIONID]        CHAR (36)      NULL,
    [ISINITIALINSPECTION] BIT            DEFAULT ((1)) NULL,
    [ISSENTTOBUS]         BIT            DEFAULT ((0)) NULL,
    [PROCESSEDDATE]       DATETIME       NULL,
    [RESULTLOG]           VARCHAR (MAX)  NULL,
    [CREATEDON]           DATETIME       NOT NULL,
    [CREATEDBY]           CHAR (36)      NOT NULL,
    CONSTRAINT [PK_FOINSPECTIONQUEUE] PRIMARY KEY CLUSTERED ([FOINSPECTIONQUEUEID] ASC),
    CONSTRAINT [FK_FOINSPECTIONQUEUE_FIREOCCUPANCY] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID]),
    CONSTRAINT [FK_FOINSPECTIONQUEUE_IMINSPECTIONTYPE] FOREIGN KEY ([IMINSPECTIONTYPEID]) REFERENCES [dbo].[IMINSPECTIONTYPE] ([IMINSPECTIONTYPEID]),
    CONSTRAINT [FK_FOINSPECTIONQUEUE_INSPECTOR] FOREIGN KEY ([INSPECTORID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_FOINSPECTIONQUEUE_USERS] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FOINSPECTIONQUEUE_ISSENTTOBUS]
    ON [dbo].[FOINSPECTIONQUEUE]([ISSENTTOBUS] ASC, [FOINSPECTIONQUEUEID] ASC);

