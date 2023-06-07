﻿CREATE TABLE [dbo].[CUSTOMSAVERINVMANAGEMENTMS] (
    [ID]                        CHAR (36) NOT NULL,
    [CUSTOMFIELDID]             CHAR (36) NOT NULL,
    [CUSTOMFIELDPICKLISTITEMID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_InventoryManagementMS] PRIMARY KEY NONCLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDPICKLISTITEMID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [InventoryManagementMS_CFPLI] FOREIGN KEY ([CUSTOMFIELDPICKLISTITEMID]) REFERENCES [dbo].[CUSTOMFIELDPICKLISTITEM] ([GCUSTOMFIELDPICKLISTITEM]),
    CONSTRAINT [InventoryManagementMS_CodeMana] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVERINVMANAGEMENT] ([ID]),
    CONSTRAINT [InventoryManagementMS_CustomFi] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD])
);
