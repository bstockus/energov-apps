﻿CREATE TABLE [dbo].[ROLESSETTING] (
    [ROLESSETTINGID] CHAR (36)     NOT NULL,
    [NAME]           NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_RolesSetting] PRIMARY KEY CLUSTERED ([ROLESSETTINGID] ASC) WITH (FILLFACTOR = 90)
);

