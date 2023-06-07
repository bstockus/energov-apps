﻿CREATE TABLE [dbo].[CUSTOMSAVEROBJECTMANAGEMENTMS] (
    [ID]                        CHAR (36) NOT NULL,
    [CUSTOMFIELDID]             CHAR (36) NOT NULL,
    [CUSTOMFIELDPICKLISTITEMID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_CUSTOMSAVEROBJECTMANAGEMENTMS] PRIMARY KEY CLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDPICKLISTITEMID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CUSTOMSAVEOBJ_CUSTOMFIELD] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD]),
    CONSTRAINT [FK_CUSTOMSAVEROBJECTMGMT_MS] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVEROBJECTMANAGEMENT] ([ID]),
    CONSTRAINT [FK_CUSTOMSAVEROBJECTMGMTMS_CFP] FOREIGN KEY ([CUSTOMFIELDPICKLISTITEMID]) REFERENCES [dbo].[CUSTOMFIELDPICKLISTITEM] ([GCUSTOMFIELDPICKLISTITEM])
);

