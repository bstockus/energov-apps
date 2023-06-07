﻿CREATE TABLE [dbo].[ADVANCEDSEARCHMODULESYSTEMFIELDMODULE] (
    [ADVANCEDSEARCHMODULEID]            INT NOT NULL,
    [ADVANCEDSEARCHSYSTEMFIELDMODULEID] INT NOT NULL,
    CONSTRAINT [PK_ADVANCEDSEARCHMODULESYSTEMFIELDMODULE] PRIMARY KEY CLUSTERED ([ADVANCEDSEARCHSYSTEMFIELDMODULEID] ASC, [ADVANCEDSEARCHMODULEID] ASC),
    CONSTRAINT [FK_ADVANCEDSEARCHMODULESYSTEMFIELDMODULE_FIELDMODULEID] FOREIGN KEY ([ADVANCEDSEARCHSYSTEMFIELDMODULEID]) REFERENCES [dbo].[ADVANCEDSEARCHSYSTEMFIELDMODULE] ([ADVANCEDSEARCHSYSTEMFIELDMODULEID]),
    CONSTRAINT [FK_ADVANCEDSEARCHMODULESYSTEMFIELDMODULE_MODULEID] FOREIGN KEY ([ADVANCEDSEARCHMODULEID]) REFERENCES [dbo].[ADVANCEDSEARCHMODULE] ([ADVANCEDSEARCHMODULEID])
);

