CREATE TABLE [osdba].[QueueIndexRebuildDiscriminateObjects] (
    [Class]      CHAR (2)  NOT NULL,
    [Schema]     [sysname] NOT NULL,
    [ObjectName] [sysname] NOT NULL,
    CONSTRAINT [PK_QueueIndexRebuildDiscriminateObjects] PRIMARY KEY CLUSTERED ([Class] ASC, [Schema] ASC, [ObjectName] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [CK_QueueIndexRebuildDiscriminateObjects_Class] CHECK ([Class]='EX' OR [Class]='WE')
);

