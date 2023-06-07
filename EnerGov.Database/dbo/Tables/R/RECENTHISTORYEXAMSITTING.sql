﻿CREATE TABLE [dbo].[RECENTHISTORYEXAMSITTING] (
    [RECENTHISTORYEXAMSITTINGID] CHAR (36)     NOT NULL,
    [EXAMSITTINGID]              CHAR (36)     NOT NULL,
    [LOGGEDDATETIME]             DATETIME      NOT NULL,
    [USERID]                     CHAR (36)     NOT NULL,
    [SITTINGNUMBER]              NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_RECENTHISTORYEXAMSITTING] PRIMARY KEY CLUSTERED ([RECENTHISTORYEXAMSITTINGID] ASC),
    CONSTRAINT [FK_RECENTHISTORYEXAMSITTING_USER] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYEXAMSITTING_LOOKUP]
    ON [dbo].[RECENTHISTORYEXAMSITTING]([EXAMSITTINGID] ASC, [USERID] ASC, [SITTINGNUMBER] DESC);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYEXAMSITTING_QUERY]
    ON [dbo].[RECENTHISTORYEXAMSITTING]([USERID] ASC)
    INCLUDE([EXAMSITTINGID], [LOGGEDDATETIME]);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYEXAMSITTING_ALL]
    ON [dbo].[RECENTHISTORYEXAMSITTING]([USERID] ASC, [SITTINGNUMBER] DESC, [EXAMSITTINGID] ASC);

