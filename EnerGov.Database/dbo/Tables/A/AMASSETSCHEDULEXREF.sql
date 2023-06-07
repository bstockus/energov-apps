﻿CREATE TABLE [dbo].[AMASSETSCHEDULEXREF] (
    [AMASSETSCHEDULEXREFID] CHAR (36) NOT NULL,
    [AMASSETID]             CHAR (36) NOT NULL,
    [SCHEDULEEVENTID]       CHAR (36) NOT NULL,
    [WORKFLOWID]            CHAR (36) NULL,
    CONSTRAINT [PK_AssetScheduleXRef] PRIMARY KEY CLUSTERED ([AMASSETSCHEDULEXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMAssetSchdXRef_AMAsset] FOREIGN KEY ([AMASSETID]) REFERENCES [dbo].[AMASSET] ([AMASSETID]),
    CONSTRAINT [FK_AMAssetSchdXRef_SchdEvent] FOREIGN KEY ([SCHEDULEEVENTID]) REFERENCES [dbo].[SCHEDULEEVENT] ([SCHEDULEEVENTID])
);

