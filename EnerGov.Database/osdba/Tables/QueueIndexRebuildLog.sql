CREATE TABLE [osdba].[QueueIndexRebuildLog] (
    [Schema]         [sysname] NOT NULL,
    [ObjectName]     [sysname] NOT NULL,
    [IndexName]      [sysname] NOT NULL,
    [FillFactor]     SMALLINT  NOT NULL,
    [RowCount]       BIGINT    NULL,
    [SizeMB]         INT       NULL,
    [RebuildStart]   DATETIME  NULL,
    [RebuildEnd]     DATETIME  NULL,
    [RebuildSeconds] INT       NULL,
    CONSTRAINT [PK_QueueIndexRebuildLog] PRIMARY KEY CLUSTERED ([Schema] ASC, [ObjectName] ASC, [IndexName] ASC) WITH (FILLFACTOR = 100)
);

