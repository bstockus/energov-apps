﻿CREATE TABLE [dbo].[FIREOCCUPANCYPERMIT] (
    [FIREOCCUPANCYPERMITID] CHAR (36) NOT NULL,
    [FIREOCCUPANCYID]       CHAR (36) NOT NULL,
    [PMPERMITID]            CHAR (36) NOT NULL,
    CONSTRAINT [PK_FIREOCCUPANCYPERMIT] PRIMARY KEY NONCLUSTERED ([FIREOCCUPANCYPERMITID] ASC),
    CONSTRAINT [FK_FIREOCCUPANCYPERMIT_FO] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID]),
    CONSTRAINT [FK_FIREOCCUPANCYPERMIT_PM] FOREIGN KEY ([PMPERMITID]) REFERENCES [dbo].[PMPERMIT] ([PMPERMITID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FIREOCCUPANCYPERMIT_PM]
    ON [dbo].[FIREOCCUPANCYPERMIT]([PMPERMITID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FIREOCCUPANCYPERMIT_FO]
    ON [dbo].[FIREOCCUPANCYPERMIT]([FIREOCCUPANCYID] ASC);
