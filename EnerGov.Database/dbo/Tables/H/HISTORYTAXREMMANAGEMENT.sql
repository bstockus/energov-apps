﻿CREATE TABLE [dbo].[HISTORYTAXREMMANAGEMENT] (
    [HISTORYTAXREMMANAGEMENTID] INT            IDENTITY (1, 1) NOT NULL,
    [ID]                        CHAR (36)      NOT NULL,
    [ROWVERSION]                INT            NOT NULL,
    [CHANGEDON]                 DATETIME       NOT NULL,
    [CHANGEDBY]                 CHAR (36)      NOT NULL,
    [FIELDNAME]                 NVARCHAR (250) NOT NULL,
    [OLDVALUE]                  NVARCHAR (MAX) NOT NULL,
    [NEWVALUE]                  NVARCHAR (MAX) NOT NULL,
    [ADDITIONALINFO]            NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([HISTORYTAXREMMANAGEMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TAXREMCHANGEDBY] FOREIGN KEY ([CHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

