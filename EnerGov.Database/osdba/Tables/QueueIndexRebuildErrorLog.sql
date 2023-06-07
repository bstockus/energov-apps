CREATE TABLE [osdba].[QueueIndexRebuildErrorLog] (
    [SerialId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [Schema]     [sysname]     NOT NULL,
    [ObjectName] [sysname]     NOT NULL,
    [IndexName]  [sysname]     NOT NULL,
    [Severity]   INT           NOT NULL,
    [Error]      VARCHAR (MAX) NOT NULL,
    [State]      INT           NOT NULL,
    [BummerDate] DATETIME      CONSTRAINT [DF_QueueIndexRebuildErrorLog_BummerDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_QueueIndexRebuildErrorLog] PRIMARY KEY CLUSTERED ([SerialId] ASC) WITH (FILLFACTOR = 100)
);

