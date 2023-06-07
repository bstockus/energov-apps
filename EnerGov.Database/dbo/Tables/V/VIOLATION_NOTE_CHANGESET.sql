﻿CREATE TABLE [dbo].[VIOLATION_NOTE_CHANGESET] (
    [VIOLATION_NOTE_CHANGESET_ID] CHAR (36)      NOT NULL,
    [VIOLATION_ID]                CHAR (36)      NOT NULL,
    [INSPECTION_ID]               CHAR (36)      NOT NULL,
    [CREATED_BY_ID]               CHAR (36)      NOT NULL,
    [TEXT]                        NVARCHAR (MAX) NOT NULL,
    [CHANGESET_TAG]               CHAR (36)      NOT NULL,
    [CHANGE_TYPE]                 INT            NOT NULL,
    [SENT]                        BIT            NOT NULL,
    [APPLIED]                     BIT            NOT NULL,
    [CHANGE_COUNT]                INT            NOT NULL,
    CONSTRAINT [PK_VIOLATION_NOTE_CHANGESET] PRIMARY KEY CLUSTERED ([VIOLATION_NOTE_CHANGESET_ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_VIOLATION_NOTE_CHANGESET_SET]
    ON [dbo].[VIOLATION_NOTE_CHANGESET]([CHANGESET_TAG] ASC);

