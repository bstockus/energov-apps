﻿CREATE TABLE [dbo].[CUSTOMSAVERPROPMANAGEMENTMS] (
    [ID]                        CHAR (36) NOT NULL,
    [CUSTOMFIELDID]             CHAR (36) NOT NULL,
    [CUSTOMFIELDPICKLISTITEMID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_CUSTOMSAVERPROPMANAGEMENTMS] PRIMARY KEY CLUSTERED ([ID] ASC, [CUSTOMFIELDID] ASC, [CUSTOMFIELDPICKLISTITEMID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CUSTOMSAVEPROP_CUSTOMFIELD] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELD] ([GCUSTOMFIELD]),
    CONSTRAINT [FK_CUSTOMSAVERPROPMGMT_MS] FOREIGN KEY ([ID]) REFERENCES [dbo].[CUSTOMSAVERPROPMANAGEMENT] ([ID]),
    CONSTRAINT [FK_CUSTOMSAVERPROPMGMTMS_CFPI] FOREIGN KEY ([CUSTOMFIELDPICKLISTITEMID]) REFERENCES [dbo].[CUSTOMFIELDPICKLISTITEM] ([GCUSTOMFIELDPICKLISTITEM])
);
