﻿CREATE TABLE [dbo].[HISTORYPURMANAGEMENT] (
    [HISTORYPURMANAGEMENTID] INT            IDENTITY (1, 1) NOT NULL,
    [ID]                     CHAR (36)      NOT NULL,
    [ROWVERSION]             INT            NOT NULL,
    [CHANGEDON]              DATETIME       NOT NULL,
    [CHANGEDBY]              CHAR (36)      NOT NULL,
    [FIELDNAME]              NVARCHAR (250) NOT NULL,
    [OLDVALUE]               NVARCHAR (MAX) NOT NULL,
    [NEWVALUE]               NVARCHAR (MAX) NOT NULL,
    [ADDITIONALINFO]         NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_HistoryPurManagement] PRIMARY KEY CLUSTERED ([HISTORYPURMANAGEMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HistoryPurMgmt_Users] FOREIGN KEY ([CHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_HPur_ChangedOn]
    ON [dbo].[HISTORYPURMANAGEMENT]([ID] ASC, [CHANGEDON] ASC, [HISTORYPURMANAGEMENTID] ASC, [CHANGEDBY] ASC, [FIELDNAME] ASC)
    INCLUDE([ROWVERSION], [OLDVALUE], [NEWVALUE], [ADDITIONALINFO]) WITH (FILLFACTOR = 90);

