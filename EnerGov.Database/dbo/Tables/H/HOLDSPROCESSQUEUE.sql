﻿CREATE TABLE [dbo].[HOLDSPROCESSQUEUE] (
    [HOLDSPROCESSQUEUEID] INT            IDENTITY (1, 1) NOT NULL,
    [CLASSNAME]           NVARCHAR (250) NOT NULL,
    [ENTITYID]            CHAR (36)      NOT NULL,
    [HOLDID]              CHAR (36)      NULL,
    [HOLDSETUPID]         CHAR (36)      NULL,
    [ORIGIN]              CHAR (36)      NULL,
    [ORIGINNUMBER]        NVARCHAR (150) NULL,
    [USERID]              CHAR (36)      NOT NULL,
    [COMMENTS]            NVARCHAR (MAX) NULL,
    [CREATEDDATE]         DATETIME       NOT NULL,
    [EFFECTIVEENDDATE]    DATETIME       NULL,
    [ACTIVE]              BIT            NOT NULL,
    [HOLDSEVERITYID]      INT            DEFAULT ((1)) NOT NULL,
    [CMCODECASEID]        CHAR (36)      NULL,
    [PROCESSEDDATE]       DATETIME       NULL,
    [SUCCESS]             BIT            NULL,
    [RESULTLOG]           VARCHAR (MAX)  NULL,
    [SENTTOBUS]           BIT            DEFAULT ((0)) NULL,
    [ACTION]              INT            NULL,
    CONSTRAINT [PK_HOLDPROCESSQUEUEID] PRIMARY KEY CLUSTERED ([HOLDSPROCESSQUEUEID] ASC),
    CONSTRAINT [FK_HOLDPROCESSQUEUEID_USERS] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_HOLDSPROCESSQUEUE_SENTTOBUS]
    ON [dbo].[HOLDSPROCESSQUEUE]([SENTTOBUS] ASC);

