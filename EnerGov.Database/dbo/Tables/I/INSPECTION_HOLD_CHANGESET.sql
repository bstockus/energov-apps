﻿CREATE TABLE [dbo].[INSPECTION_HOLD_CHANGESET] (
    [HOLD_CHANGESET_ID] CHAR (36)      NOT NULL,
    [HOLD_ID]           CHAR (36)      NOT NULL,
    [INSPECTION_ID]     CHAR (36)      NOT NULL,
    [HOLD_TYPE_ID]      CHAR (36)      NOT NULL,
    [HOLD_SETUP_ID]     CHAR (36)      NOT NULL,
    [CHANGESET_TAG]     CHAR (36)      NOT NULL,
    [CHANGE_TYPE]       INT            NOT NULL,
    [COMMENTS]          NVARCHAR (MAX) NOT NULL,
    [DATE_STAMP]        DATETIME       NOT NULL,
    [CHANGE_COUNT]      INT            NOT NULL,
    [SENT]              BIT            NOT NULL,
    [APPLIED]           BIT            NOT NULL,
    [ORIGIN]            NVARCHAR (500) NOT NULL,
    [ACTIVE]            BIT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_INSPECTION_HOLD_CHANGESET] PRIMARY KEY CLUSTERED ([HOLD_CHANGESET_ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_INSPECTION_HOLD_CHANGESET_SET]
    ON [dbo].[INSPECTION_HOLD_CHANGESET]([CHANGESET_TAG] ASC);

