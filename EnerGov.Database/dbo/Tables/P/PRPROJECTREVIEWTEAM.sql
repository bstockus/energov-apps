﻿CREATE TABLE [dbo].[PRPROJECTREVIEWTEAM] (
    [PRPROJECTREVIEWTEAMID] CHAR (36) NOT NULL,
    [PRPROJECTID]           CHAR (36) NOT NULL,
    [DEPARTMENTID]          CHAR (36) NOT NULL,
    [USERID]                CHAR (36) NOT NULL,
    CONSTRAINT [PK_PRPROJECTReviewTeam] PRIMARY KEY CLUSTERED ([PRPROJECTREVIEWTEAMID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PROJReviewTeam_Dept] FOREIGN KEY ([DEPARTMENTID]) REFERENCES [dbo].[DEPARTMENT] ([DEPARTMENTID]),
    CONSTRAINT [FK_PROJReviewTeam_PROJ] FOREIGN KEY ([PRPROJECTID]) REFERENCES [dbo].[PRPROJECT] ([PRPROJECTID]),
    CONSTRAINT [FK_PROJReviewTeam_Users] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);
