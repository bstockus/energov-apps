﻿CREATE TABLE [dbo].[FIREOCCUPANCYBLLICENSE] (
    [FIREOCCUPANCYBLLICENSEID] CHAR (36) NOT NULL,
    [FIREOCCUPANCYID]          CHAR (36) NOT NULL,
    [BLLICENSEID]              CHAR (36) NOT NULL,
    CONSTRAINT [PK_FIREOCCUPANCYBLLICENSE] PRIMARY KEY NONCLUSTERED ([FIREOCCUPANCYBLLICENSEID] ASC),
    CONSTRAINT [FK_FIREOCCUPANCYBLLICENSE_BL] FOREIGN KEY ([BLLICENSEID]) REFERENCES [dbo].[BLLICENSE] ([BLLICENSEID]),
    CONSTRAINT [FK_FIREOCCUPANCYBLLICENSE_FO] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FIREOCCUPANCYBLLICENSE_BL]
    ON [dbo].[FIREOCCUPANCYBLLICENSE]([BLLICENSEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FIREOCCUPANCYBLLICENSE_FO]
    ON [dbo].[FIREOCCUPANCYBLLICENSE]([FIREOCCUPANCYID] ASC);
