﻿CREATE TABLE [dbo].[HISTORYPROJMANAGEMENT] (
    [HISTORYPROJMANAGEMENTID] INT            IDENTITY (1, 1) NOT NULL,
    [ID]                      CHAR (36)      NOT NULL,
    [ROWVERSION]              INT            NOT NULL,
    [CHANGEDON]               DATETIME       NOT NULL,
    [CHANGEDBY]               CHAR (36)      NOT NULL,
    [FIELDNAME]               NVARCHAR (250) NOT NULL,
    [OLDVALUE]                NVARCHAR (MAX) NOT NULL,
    [NEWVALUE]                NVARCHAR (MAX) NOT NULL,
    [ADDITIONALINFO]          NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_HistoryProjManagement] PRIMARY KEY CLUSTERED ([HISTORYPROJMANAGEMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HistoryProjMgmt_Users] FOREIGN KEY ([CHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_HProj_ChangedOn]
    ON [dbo].[HISTORYPROJMANAGEMENT]([ID] ASC, [CHANGEDON] ASC, [HISTORYPROJMANAGEMENTID] ASC, [CHANGEDBY] ASC, [FIELDNAME] ASC)
    INCLUDE([ROWVERSION], [OLDVALUE], [NEWVALUE], [ADDITIONALINFO]) WITH (FILLFACTOR = 90);
