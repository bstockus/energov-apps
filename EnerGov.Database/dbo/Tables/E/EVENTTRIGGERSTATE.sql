﻿CREATE TABLE [dbo].[EVENTTRIGGERSTATE] (
    [TRIGGERNAME] NVARCHAR (200) NOT NULL,
    [TABLENAME]   NVARCHAR (200) NOT NULL,
    [DISABLED]    BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([TRIGGERNAME] ASC)
);
