﻿CREATE TABLE [dbo].[CUSTOMSAVERTAXREMMANAGEMENTMS] (
    [ID]                        CHAR (36) NOT NULL,
    [CUSTOMFIELDID]             CHAR (36) NOT NULL,
    [CUSTOMFIELDPICKLISTITEMID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_TAXREMManagementMS] PRIMARY KEY NONCLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDPICKLISTITEMID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [TAXREMManagementMS_CFPLI] FOREIGN KEY ([CUSTOMFIELDPICKLISTITEMID]) REFERENCES [dbo].[CUSTOMFIELDPICKLISTITEM] ([GCUSTOMFIELDPICKLISTITEM]),
    CONSTRAINT [TAXREMManagementMS_CustomFiel] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD]),
    CONSTRAINT [TAXREMManagementMS_TAXREMMan] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVERTAXREMMANAGEMENT] ([ID])
);

