﻿CREATE TABLE [dbo].[DATABASEUPGRADELOG] (
    [DATABASEUPGRADELOGID] CHAR (36)      NOT NULL,
    [SCRIPTNAME]           NVARCHAR (256) NOT NULL,
    [MESSAGE]              NVARCHAR (MAX) NOT NULL,
    [LOGDATE]              DATETIME       NOT NULL,
    CONSTRAINT [PK_DATABASEUPGRADELOG] PRIMARY KEY NONCLUSTERED ([DATABASEUPGRADELOGID] ASC)
);
