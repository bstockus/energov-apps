﻿CREATE TABLE [dbo].[RECENTHISTORYTAXREMIITANCEACCOUNT] (
    [RECENTHISTORYTAXREMIITANCEACCOUNTID] CHAR (36)     NOT NULL,
    [TXREMITTANCEACCOUNTID]               CHAR (36)     NOT NULL,
    [LOGGEDDATETIME]                      DATETIME      NOT NULL,
    [USERID]                              CHAR (36)     NOT NULL,
    [ACCOUNTNUMBER]                       NVARCHAR (50) NULL,
    CONSTRAINT [PK_RECENTHISTORYTAXREMIITANCEACCOUNT] PRIMARY KEY CLUSTERED ([RECENTHISTORYTAXREMIITANCEACCOUNTID] ASC),
    CONSTRAINT [FK_RECENTHISTORYTAXREMIITANCEACCOUNT_USERS] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYTAXREMIITANCEACCOUNT_ALL]
    ON [dbo].[RECENTHISTORYTAXREMIITANCEACCOUNT]([USERID] ASC, [ACCOUNTNUMBER] DESC, [TXREMITTANCEACCOUNTID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYTAXREMIITANCEACCOUNT_LOOKUP]
    ON [dbo].[RECENTHISTORYTAXREMIITANCEACCOUNT]([TXREMITTANCEACCOUNTID] ASC, [USERID] ASC, [ACCOUNTNUMBER] DESC);

