﻿CREATE TABLE [dbo].[RECENTHISTORYEXAMREQUEST] (
    [RECENTHISTORYEXAMREQUESTID] CHAR (36)     NOT NULL,
    [EXAMREQUESTID]              CHAR (36)     NOT NULL,
    [LOGGEDDATETIME]             DATETIME      NOT NULL,
    [USERID]                     CHAR (36)     NOT NULL,
    [REQUESTNUMBER]              NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_RECENTHISTORYEXAMREQUEST] PRIMARY KEY CLUSTERED ([RECENTHISTORYEXAMREQUESTID] ASC),
    CONSTRAINT [FK_RECENTHISTORYEXAMREQUEST_USER] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYEXAMREQUEST_LOOKUP]
    ON [dbo].[RECENTHISTORYEXAMREQUEST]([EXAMREQUESTID] ASC, [USERID] ASC, [REQUESTNUMBER] DESC);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYEXAMREQUEST_QUERY]
    ON [dbo].[RECENTHISTORYEXAMREQUEST]([USERID] ASC)
    INCLUDE([EXAMREQUESTID], [LOGGEDDATETIME]);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYEXAMREQUEST_ALL]
    ON [dbo].[RECENTHISTORYEXAMREQUEST]([USERID] ASC, [REQUESTNUMBER] DESC, [EXAMREQUESTID] ASC);
