﻿CREATE TABLE [dbo].[INSPECTION_VIOLATION_CHANGE] (
    [INSPECTION_VIOLATION_CHANGEID] CHAR (36) NOT NULL,
    [VIOLATION_ID]                  CHAR (36) NOT NULL,
    [INSPECTION_ID]                 CHAR (36) NOT NULL,
    [STATUS_ID]                     CHAR (36) NOT NULL,
    [SENT]                          BIT       NOT NULL,
    [APPLIED]                       BIT       NOT NULL,
    [CHANGE_TYPE]                   INT       NOT NULL,
    [CHANGE_COUNT]                  INT       NOT NULL,
    [CHANGESET_TAG]                 CHAR (36) NOT NULL,
    CONSTRAINT [PK_INSPECTION_VIOLATION_CHANGESET] PRIMARY KEY CLUSTERED ([INSPECTION_VIOLATION_CHANGEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_INSPECTION_VIOLATION_CHANGE_SET]
    ON [dbo].[INSPECTION_VIOLATION_CHANGE]([CHANGESET_TAG] ASC);

