﻿CREATE TABLE [dbo].[CMCODECASEWORKORDER] (
    [CMCODECASEWORKORDERID]  CHAR (36)      NOT NULL,
    [CMCODECASEID]           CHAR (36)      NOT NULL,
    [WORKORDERTYPEID]        INT            NOT NULL,
    [WORKORDERTYPENAME]      NVARCHAR (255) NOT NULL,
    [WORKORDERTYPECLASSID]   INT            NOT NULL,
    [WORKORDERTYPECLASSNAME] NVARCHAR (255) NOT NULL,
    [WORKORDERSTATUSID]      INT            NOT NULL,
    [WORKORDERSTATUSNAME]    NVARCHAR (255) NULL,
    [WORKORDERID]            NVARCHAR (255) NULL,
    [WORKORDERENCRYPTEDID]   VARCHAR (255)  NULL,
    [WORKORDERNUMBER]        NVARCHAR (255) NULL,
    [DESCRIPTION]            NVARCHAR (MAX) NULL,
    [CREATEDATE]             DATETIME       NULL,
    [LASTCHANGEDBY]          CHAR (36)      NOT NULL,
    [ERRORID]                CHAR (36)      NULL,
    [CREATEATTEMPT]          INT            DEFAULT ((0)) NULL,
    [CMCODEWFACTIONSTEPID]   CHAR (36)      NOT NULL,
    [CREATEDBY]              CHAR (36)      NOT NULL,
    [DATEPOSTED]             DATETIME       NULL,
    CONSTRAINT [PK_CMC_WKO] PRIMARY KEY CLUSTERED ([CMCODECASEWORKORDERID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CMC_WKO] FOREIGN KEY ([CMCODECASEID]) REFERENCES [dbo].[CMCODECASE] ([CMCODECASEID]),
    CONSTRAINT [FK_CMC_WKO_CHANGE_USR] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CMC_WKO_CREATE_USR] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CMC_WKO_WF_SA] FOREIGN KEY ([CMCODEWFACTIONSTEPID]) REFERENCES [dbo].[CMCODEWFACTIONSTEP] ([CMCODEWFACTIONSTEPID])
);
