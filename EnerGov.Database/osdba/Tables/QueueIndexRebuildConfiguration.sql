CREATE TABLE [osdba].[QueueIndexRebuildConfiguration] (
    [RunType]                CHAR (2) NOT NULL,
    [AgeOut]                 SMALLINT NOT NULL,
    [ConstraintTime]         SMALLINT NOT NULL,
    [ConstraintMaxMemory]    INT      NOT NULL,
    [ConstraintServerMemory] SMALLINT NOT NULL,
    [ConstraintPreference]   CHAR (2) NOT NULL,
    CONSTRAINT [PK_QueueIndexRebuildConfiguration] PRIMARY KEY CLUSTERED ([RunType] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [CK_QueueIndexRebuildConfiguration_AgeOut] CHECK ([AgeOut]>=(2) AND [AgeOut]<=(7)),
    CONSTRAINT [CK_QueueIndexRebuildConfiguration_ConstraintMaxMemory] CHECK ([ConstraintMaxMemory]>=(2048)),
    CONSTRAINT [CK_QueueIndexRebuildConfiguration_ConstraintPreference] CHECK ([ConstraintPreference]='SM' OR [ConstraintPreference]='MM' OR [ConstraintPreference]='TM'),
    CONSTRAINT [CK_QueueIndexRebuildConfiguration_ConstraintServerMemory] CHECK ([ConstraintServerMemory]>=(30)),
    CONSTRAINT [CK_QueueIndexRebuildConfiguration_ConstraintTime] CHECK ([ConstraintTime]>=(10))
);

