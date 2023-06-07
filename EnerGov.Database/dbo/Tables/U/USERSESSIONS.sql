﻿CREATE TABLE [dbo].[USERSESSIONS] (
    [SESSIONID]         CHAR (36) NULL,
    [USERID]            CHAR (36) NOT NULL,
    [LOGIN]             DATETIME  NOT NULL,
    [LOGOUT]            DATETIME  NULL,
    [ISLOGINSUCCESSFUL] BIT       NULL,
    [USERSESSIONID]     INT       IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_USERSESSIONS] PRIMARY KEY CLUSTERED ([USERSESSIONID] ASC),
    CONSTRAINT [FK_USERSESSIONS_USERS] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

