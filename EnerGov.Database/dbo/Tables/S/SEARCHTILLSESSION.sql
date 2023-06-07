﻿CREATE TABLE [dbo].[SEARCHTILLSESSION] (
    [SEARCHTILLSESSIONID] CHAR (36)     NOT NULL,
    [USERID]              CHAR (36)     NOT NULL,
    [TIISESSIONDATE]      DATETIME      NULL,
    [BEGINBALANCE]        MONEY         DEFAULT ((0)) NULL,
    [ENDBALANCE]          MONEY         DEFAULT ((0)) NULL,
    [OPENTILLSESSION]     BIT           DEFAULT ((0)) NOT NULL,
    [ISSHARED]            BIT           NULL,
    [GROUPNUMBER]         NVARCHAR (50) NULL,
    [CRITERIANAME]        NVARCHAR (50) NULL,
    [CASHIERID]           CHAR (36)     NULL,
    [OFFICEID]            CHAR (36)     NULL,
    CONSTRAINT [PK_SEARCHTILLSESSION] PRIMARY KEY CLUSTERED ([SEARCHTILLSESSIONID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_SEARCHTILLSESSION_Users] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);
