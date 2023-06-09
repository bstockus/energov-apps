﻿CREATE TABLE [dbo].[CMCODEWFACTIONSTEPUSER] (
    [CMCODEWFACTIONSTEPUSERID] CHAR (36) NOT NULL,
    [CMCODEWFACTIONSTEPID]     CHAR (36) NOT NULL,
    [USERID]                   CHAR (36) NOT NULL,
    CONSTRAINT [PK_CodeWFActionStepUser] PRIMARY KEY CLUSTERED ([CMCODEWFACTIONSTEPUSERID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CMActStepUser_ActionStep] FOREIGN KEY ([CMCODEWFACTIONSTEPID]) REFERENCES [dbo].[CMCODEWFACTIONSTEP] ([CMCODEWFACTIONSTEPID]),
    CONSTRAINT [FK_CodeWFActionStepUser_Users] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

