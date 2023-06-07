﻿CREATE TABLE [dbo].[PMPERMITREVIEWTEAM] (
    [PMPERMITREVIEWTEAMID] CHAR (36) NOT NULL,
    [PMPERMITID]           CHAR (36) NOT NULL,
    [DEPARTMENTID]         CHAR (36) NOT NULL,
    [USERID]               CHAR (36) NOT NULL,
    CONSTRAINT [PK_PMPERMITREVIEWTEAM] PRIMARY KEY CLUSTERED ([PMPERMITREVIEWTEAMID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PERMITREVIEWTEAM_DEPT] FOREIGN KEY ([DEPARTMENTID]) REFERENCES [dbo].[DEPARTMENT] ([DEPARTMENTID]),
    CONSTRAINT [FK_PMPERMITREVIEWTEAM_PMPERMIT] FOREIGN KEY ([PMPERMITID]) REFERENCES [dbo].[PMPERMIT] ([PMPERMITID]),
    CONSTRAINT [FK_PMPERMITREVIEWTEAM_USERS] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

