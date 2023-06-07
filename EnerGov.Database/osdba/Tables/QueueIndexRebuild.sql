CREATE TABLE [osdba].[QueueIndexRebuild] (
    [SerialId]   BIGINT    IDENTITY (1, 1) NOT NULL,
    [Schema]     [sysname] NOT NULL,
    [ObjectName] [sysname] NOT NULL,
    [IndexName]  [sysname] NOT NULL,
    [FillFactor] SMALLINT  NOT NULL,
    [TimePeriod] CHAR (2)  NOT NULL,
    [RowCount]   BIGINT    NOT NULL,
    [SizeMB]     INT       NOT NULL,
    [Age]        SMALLINT  NOT NULL,
    CONSTRAINT [PK_QueueIndexRebuild] PRIMARY KEY CLUSTERED ([Schema] ASC, [ObjectName] ASC, [IndexName] ASC) WITH (FILLFACTOR = 100)
);

