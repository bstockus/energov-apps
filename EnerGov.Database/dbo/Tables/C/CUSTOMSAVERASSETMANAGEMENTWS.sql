﻿CREATE TABLE [dbo].[CUSTOMSAVERASSETMANAGEMENTWS] (
    [ID]                         CHAR (36)       NOT NULL,
    [CUSTOMFIELDID]              CHAR (36)       NOT NULL,
    [CUSTOMFIELDWORKSHEETITEMID] CHAR (36)       NOT NULL,
    [NUMERICVALUE]               DECIMAL (15, 2) NULL,
    CONSTRAINT [PK_CUSTOMSAVERASSETMGMTWS] PRIMARY KEY NONCLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDWORKSHEETITEMID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [CUSTOMSAVERAMWS_ASSET] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVERASSETMANAGEMENT] ([ID]),
    CONSTRAINT [CUSTOMSAVERAMWS_CFWSI] FOREIGN KEY ([CUSTOMFIELDWORKSHEETITEMID]) REFERENCES [dbo].[CUSTOMFIELDWORKSHEETITEM] ([GCUSTOMFIELDWORKSHEETITEM]),
    CONSTRAINT [CUSTOMSAVERAMWS_CUSTFIELD] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD])
);

