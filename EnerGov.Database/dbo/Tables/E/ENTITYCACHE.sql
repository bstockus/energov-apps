﻿CREATE TABLE [dbo].[ENTITYCACHE] (
    [CLASSNAME] NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_ENTITYCACHE] PRIMARY KEY CLUSTERED ([CLASSNAME] ASC) WITH (FILLFACTOR = 90)
);
