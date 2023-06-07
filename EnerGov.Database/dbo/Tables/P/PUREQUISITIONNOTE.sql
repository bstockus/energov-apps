﻿CREATE TABLE [dbo].[PUREQUISITIONNOTE] (
    [PUREQUISITIONNOTEID] CHAR (36)     NOT NULL,
    [PUREQUISITIONID]     CHAR (36)     NOT NULL,
    [TEXT]                VARCHAR (MAX) NULL,
    [CREATEDBY]           CHAR (36)     NOT NULL,
    [CREATEDDATE]         DATETIME      NOT NULL,
    CONSTRAINT [PK_PURequisitionNote] PRIMARY KEY CLUSTERED ([PUREQUISITIONNOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PUReqNote_PUReq] FOREIGN KEY ([PUREQUISITIONID]) REFERENCES [dbo].[PUREQUISITION] ([PUREQUISITIONID]),
    CONSTRAINT [FK_PUReqNote_Users] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

