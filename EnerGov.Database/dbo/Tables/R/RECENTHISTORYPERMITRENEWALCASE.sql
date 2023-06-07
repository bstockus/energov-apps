﻿CREATE TABLE [dbo].[RECENTHISTORYPERMITRENEWALCASE] (
    [RECENTHISTORYPERMITRENEWALCASEID] CHAR (36)     NOT NULL,
    [PERMITRENEWALCASEID]              CHAR (36)     NOT NULL,
    [LOGGEDDATETIME]                   DATETIME      NOT NULL,
    [USERID]                           CHAR (36)     NOT NULL,
    [PERMITRENEWALCASENUMBER]          NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_RECENTHISTORYPERMITRENEWALCASE] PRIMARY KEY CLUSTERED ([RECENTHISTORYPERMITRENEWALCASEID] ASC),
    CONSTRAINT [FK_RECENTHISTORYPERMITRENEWALCASE_USER] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPERMITRENEWALCASE_LOOKUP]
    ON [dbo].[RECENTHISTORYPERMITRENEWALCASE]([PERMITRENEWALCASEID] ASC, [USERID] ASC, [PERMITRENEWALCASENUMBER] DESC);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPERMITRENEWALCASE_QUERY]
    ON [dbo].[RECENTHISTORYPERMITRENEWALCASE]([USERID] ASC)
    INCLUDE([PERMITRENEWALCASEID], [LOGGEDDATETIME]);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPERMITRENEWALCASE_ALL]
    ON [dbo].[RECENTHISTORYPERMITRENEWALCASE]([USERID] ASC, [PERMITRENEWALCASENUMBER] DESC, [PERMITRENEWALCASEID] ASC);
