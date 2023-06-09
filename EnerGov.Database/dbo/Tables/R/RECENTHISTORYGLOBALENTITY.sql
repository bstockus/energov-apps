﻿CREATE TABLE [dbo].[RECENTHISTORYGLOBALENTITY] (
    [RECENTHISTORYGLOBALENTITYID] CHAR (36)      NOT NULL,
    [GLOBALENTITYID]              CHAR (36)      NOT NULL,
    [LOGGEDDATETIME]              DATETIME       NOT NULL,
    [USERID]                      CHAR (36)      NOT NULL,
    [CONTACTNAME]                 NVARCHAR (200) NOT NULL,
    CONSTRAINT [PK_RECENTHISTORYGLOBALENTITY] PRIMARY KEY CLUSTERED ([RECENTHISTORYGLOBALENTITYID] ASC),
    CONSTRAINT [FK_RECENTHISTORYGLOBALENTITY_USER] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYGLOBALENTITY_ALL]
    ON [dbo].[RECENTHISTORYGLOBALENTITY]([USERID] ASC, [CONTACTNAME] DESC, [GLOBALENTITYID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYGLOBALENTITY_LOOKUP]
    ON [dbo].[RECENTHISTORYGLOBALENTITY]([GLOBALENTITYID] ASC, [USERID] ASC, [CONTACTNAME] DESC);

