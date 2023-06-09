﻿CREATE TABLE [dbo].[ENTITYCACHEDEPENDENCY] (
    [ENTITYCACHEDEPENDENCYID] CHAR (36)      NOT NULL,
    [CLASSNAME]               NVARCHAR (250) NOT NULL,
    [CACHECLASSNAME]          NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_ENTITYCACHEDEPENDENCY] PRIMARY KEY CLUSTERED ([ENTITYCACHEDEPENDENCYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ENTITY_ENTITYDEPENDENCY] FOREIGN KEY ([CLASSNAME]) REFERENCES [dbo].[ENTITYCACHE] ([CLASSNAME])
);

