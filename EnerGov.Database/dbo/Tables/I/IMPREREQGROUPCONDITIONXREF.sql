﻿CREATE TABLE [dbo].[IMPREREQGROUPCONDITIONXREF] (
    [IMPREREQGROUPID]     CHAR (36) NOT NULL,
    [IMPREREQCONDITIONID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_IMPREREQGROUPCONDITIONXREF] PRIMARY KEY CLUSTERED ([IMPREREQGROUPID] ASC, [IMPREREQCONDITIONID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GROUPCONDXREF_IMPREREQCOND] FOREIGN KEY ([IMPREREQCONDITIONID]) REFERENCES [dbo].[IMPREREQCONDITION] ([IMPREREQCONDITIONID]),
    CONSTRAINT [FK_GROUPCONDXREF_IMPREREQGROUP] FOREIGN KEY ([IMPREREQGROUPID]) REFERENCES [dbo].[IMPREREQGROUP] ([IMPREREQGROUPID])
);
