﻿CREATE TABLE [dbo].[CUSTOMSAVERINSPECTIONSWS] (
    [ID]                         CHAR (36)       NOT NULL,
    [CUSTOMFIELDID]              CHAR (36)       NOT NULL,
    [CUSTOMFIELDWORKSHEETITEMID] CHAR (36)       NOT NULL,
    [NUMERICVALUE]               DECIMAL (15, 2) NULL,
    CONSTRAINT [PK_CUSTOMSAVERINSPECTIONWS] PRIMARY KEY NONCLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDWORKSHEETITEMID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [CUSTOMSAVERINSPECTWS_CFWSI] FOREIGN KEY ([CUSTOMFIELDWORKSHEETITEMID]) REFERENCES [dbo].[CUSTOMFIELDWORKSHEETITEM] ([GCUSTOMFIELDWORKSHEETITEM]),
    CONSTRAINT [CUSTOMSAVERINSPECTWS_CUSTFIELD] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD]),
    CONSTRAINT [CUSTOMSAVERINSPECTWS_INSPECT] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVERINSPECTIONS] ([ID])
);

