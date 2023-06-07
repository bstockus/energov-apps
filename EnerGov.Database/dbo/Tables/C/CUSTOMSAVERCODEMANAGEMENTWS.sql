﻿CREATE TABLE [dbo].[CUSTOMSAVERCODEMANAGEMENTWS] (
    [ID]                         CHAR (36)       NOT NULL,
    [CUSTOMFIELDID]              CHAR (36)       NOT NULL,
    [CUSTOMFIELDWORKSHEETITEMID] CHAR (36)       NOT NULL,
    [NUMERICVALUE]               DECIMAL (15, 2) NULL,
    CONSTRAINT [PK_CUSTOMSAVERCODEMGMTWS] PRIMARY KEY NONCLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDWORKSHEETITEMID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [CUSTOMSAVERCMWS_CFWSI] FOREIGN KEY ([CUSTOMFIELDWORKSHEETITEMID]) REFERENCES [dbo].[CUSTOMFIELDWORKSHEETITEM] ([GCUSTOMFIELDWORKSHEETITEM]),
    CONSTRAINT [CUSTOMSAVERCMWS_CODE] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVERCODEMANAGEMENT] ([ID]),
    CONSTRAINT [CUSTOMSAVERCMWS_CUSTFIELD] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD])
);

