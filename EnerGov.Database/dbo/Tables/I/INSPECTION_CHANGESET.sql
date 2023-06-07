CREATE TABLE [dbo].[INSPECTION_CHANGESET] (
    [INSPECTION_CHANGESET_ID]       CHAR (36)      NOT NULL,
    [INSPECTION_ID]                 CHAR (36)      NOT NULL,
    [CHANGESET_TAG]                 CHAR (36)      NOT NULL,
    [OBJECT_NAME]                   NVARCHAR (500) NOT NULL,
    [PROPERTY_NAME]                 NVARCHAR (500) NOT NULL,
    [VALUE]                         NVARCHAR (MAX) NOT NULL,
    [CHANGE_TYPE]                   INT            NOT NULL,
    [SENT]                          BIT            NOT NULL,
    [APPLIED]                       BIT            NOT NULL,
    [DATE_STAMP]                    DATETIME       NOT NULL,
    [CHANGE_COUNT]                  INT            NOT NULL,
    [CHECKLIST_ITEMS_CHANGES_COUNT] INT            NOT NULL,
    [HOLDS_CHANGES_COUNT]           INT            NOT NULL,
    [ERROR_ID]                      CHAR (36)      NULL,
    CONSTRAINT [PK_INSPECTION_CHANGESET] PRIMARY KEY CLUSTERED ([INSPECTION_CHANGESET_ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_INSPECTION_CHANGESET_SET]
    ON [dbo].[INSPECTION_CHANGESET]([CHANGESET_TAG] ASC);

