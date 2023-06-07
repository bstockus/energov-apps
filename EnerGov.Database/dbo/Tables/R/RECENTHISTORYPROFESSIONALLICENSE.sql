﻿CREATE TABLE [dbo].[RECENTHISTORYPROFESSIONALLICENSE] (
    [RECENTHISTORYPROFESSIONALLICENSEID] CHAR (36)     NOT NULL,
    [ILLICENSEID]                        CHAR (36)     NOT NULL,
    [LOGGEDDATETIME]                     DATETIME      NOT NULL,
    [USERID]                             CHAR (36)     NOT NULL,
    [ACCOUNTNUMBER]                      NVARCHAR (50) NULL,
    CONSTRAINT [PK_RECENTHISTORYPROFESSIONALLICENSE] PRIMARY KEY CLUSTERED ([RECENTHISTORYPROFESSIONALLICENSEID] ASC),
    CONSTRAINT [FK_RECENTHISTORYPROFESSIONALLICENSE_USERS] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPROFESSIONALLICENSE_ALL]
    ON [dbo].[RECENTHISTORYPROFESSIONALLICENSE]([USERID] ASC, [ACCOUNTNUMBER] DESC, [ILLICENSEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RECENTHISTORYPROFESSIONALLICENSE_LOOKUP]
    ON [dbo].[RECENTHISTORYPROFESSIONALLICENSE]([ILLICENSEID] ASC, [USERID] ASC, [ACCOUNTNUMBER] DESC);
