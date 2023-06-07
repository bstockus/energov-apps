﻿CREATE TABLE [dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] (
    [ID]                         CHAR (36)       NOT NULL,
    [CUSTOMFIELDID]              CHAR (36)       NOT NULL,
    [CUSTOMFIELDWORKSHEETITEMID] CHAR (36)       NOT NULL,
    [NUMERICVALUE]               DECIMAL (15, 2) NULL,
    CONSTRAINT [PK_CUSTOMSAVERPERMITMGMTWS] PRIMARY KEY NONCLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDWORKSHEETITEMID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [CUSTOMSAVERPMWS_CFWSI] FOREIGN KEY ([CUSTOMFIELDWORKSHEETITEMID]) REFERENCES [dbo].[CUSTOMFIELDWORKSHEETITEM] ([GCUSTOMFIELDWORKSHEETITEM]),
    CONSTRAINT [CUSTOMSAVERPMWS_CUSTFIELD] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD]),
    CONSTRAINT [CUSTOMSAVERPMWS_PERMIT] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVERPERMITMANAGEMENT] ([ID])
);

