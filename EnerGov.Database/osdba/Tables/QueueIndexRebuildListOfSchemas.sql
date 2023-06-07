CREATE TABLE [osdba].[QueueIndexRebuildListOfSchemas] (
    [Schema] [sysname]    NOT NULL,
    [Owner]  VARCHAR (16) NOT NULL,
    CONSTRAINT [PK_QueueIndexRebuildListOfSchemas] PRIMARY KEY CLUSTERED ([Schema] ASC) WITH (FILLFACTOR = 100)
);

