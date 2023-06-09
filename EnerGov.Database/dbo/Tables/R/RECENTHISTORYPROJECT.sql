﻿CREATE TABLE [dbo].[RECENTHISTORYPROJECT] (
    [RECENTHISTORYPROJECTID] CHAR (36)      NOT NULL,
    [PROJECTID]              CHAR (36)      NOT NULL,
    [LOGGEDDATETIME]         DATETIME       NOT NULL,
    [USERID]                 CHAR (36)      NOT NULL,
    [PROJECTNUMBER]          NVARCHAR (200) NOT NULL,
    CONSTRAINT [PK_RECENTHISTORYPROJECT] PRIMARY KEY CLUSTERED ([RECENTHISTORYPROJECTID] ASC),
    CONSTRAINT [FK_RECENTHISTORYPROJECT_USER] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPROJECT_QUERY]
    ON [dbo].[RECENTHISTORYPROJECT]([USERID] ASC)
    INCLUDE([PROJECTID], [LOGGEDDATETIME]);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPROJECT_ALL]
    ON [dbo].[RECENTHISTORYPROJECT]([USERID] ASC, [PROJECTNUMBER] DESC, [PROJECTID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPROJECT_LOOKUP]
    ON [dbo].[RECENTHISTORYPROJECT]([PROJECTID] ASC, [USERID] ASC, [PROJECTNUMBER] DESC);

