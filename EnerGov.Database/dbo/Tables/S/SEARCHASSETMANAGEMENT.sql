﻿CREATE TABLE [dbo].[SEARCHASSETMANAGEMENT] (
    [SEARCHASSETMANAGEMENTID]        CHAR (36)     NOT NULL,
    [SEARCHCOLUMNSLIST]              VARCHAR (MAX) NOT NULL,
    [AMWORKORDERSTATUSID]            CHAR (36)     NULL,
    [AMWORKORDERPRIORITYID]          CHAR (36)     NULL,
    [AMWORKORDERTYPEID]              CHAR (36)     NULL,
    [WORKORDERPLANNEDSTARTDATEFROM]  DATETIME      NULL,
    [AMWORKORDERPLANNEDSTARTDATETO]  DATETIME      NULL,
    [AMWORKORDERPLANNEDDUEDATEFROM]  DATETIME      NULL,
    [AMWORKORDERPLANNEDDUEDATETO]    DATETIME      NULL,
    [AMWORKORDERACTUALSTARTDATEFROM] DATETIME      NULL,
    [AMWORKORDERACTUALSTARTDATETO]   DATETIME      NULL,
    [AMWORKORDERACTUALDUEDATEFROM]   DATETIME      NULL,
    [AMWORKORDERACTUALDUEDATETO]     DATETIME      NULL,
    [AMWORKORDERCREATEDATEFROM]      DATETIME      NULL,
    [AMWORKORDERCREATEDATETO]        DATETIME      NULL,
    [AMWORKORDEREMERGENCY]           NVARCHAR (10) NOT NULL,
    [AMWORKORDERHAZARD]              NVARCHAR (10) NOT NULL,
    [AMWORKORDERCOMPLETE]            NVARCHAR (10) NOT NULL,
    [AMWORKORDERNO]                  NVARCHAR (50) NOT NULL,
    [AMWORKORDERHEADLINE]            NVARCHAR (50) NOT NULL,
    [AMWORKORDERSUPERVISOR]          CHAR (36)     NULL,
    [AMWORKORDERSUBMITTEDTO]         CHAR (36)     NULL,
    [AMWORKORDERASSIGNEDTO]          CHAR (36)     NULL,
    [USERID]                         CHAR (36)     NOT NULL,
    [ISSHARED]                       BIT           NOT NULL,
    [CRITERIANAME]                   NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_SearchAssetManagement] PRIMARY KEY CLUSTERED ([SEARCHASSETMANAGEMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_SearchAssetManagement_AMWor] FOREIGN KEY ([AMWORKORDERPRIORITYID]) REFERENCES [dbo].[AMWORKORDERPRIORITY] ([AMWORKORDERPRIORITYID]),
    CONSTRAINT [FK_SearchAssetManagement_Assig] FOREIGN KEY ([AMWORKORDERASSIGNEDTO]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SearchAssetManagement_Stat] FOREIGN KEY ([AMWORKORDERSTATUSID]) REFERENCES [dbo].[AMWORKORDERSTATUS] ([AMWORKORDERSTATUSID]),
    CONSTRAINT [FK_SearchAssetManagement_Submi] FOREIGN KEY ([AMWORKORDERSUBMITTEDTO]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SearchAssetManagement_Super] FOREIGN KEY ([AMWORKORDERSUPERVISOR]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SearchAssetManagement_Type] FOREIGN KEY ([AMWORKORDERTYPEID]) REFERENCES [dbo].[AMWORKORDERTYPE] ([AMWORKORDERTYPEID]),
    CONSTRAINT [FK_SearchAssetManagement_Users] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);
