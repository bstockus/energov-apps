﻿CREATE TABLE [dbo].[FIREOCCUPANCYBUSINESS] (
    [FIREOCCUPANCYBUSINESSID]   CHAR (36)      NOT NULL,
    [FIREOCCUPANCYID]           CHAR (36)      NOT NULL,
    [BLGLOBALENTITYEXTENSIONID] CHAR (36)      NULL,
    [NAME]                      NVARCHAR (100) NOT NULL,
    [DBA]                       NVARCHAR (100) NOT NULL,
    [FOBUSINESSSTATUSID]        CHAR (36)      NOT NULL,
    [SQUARESIZE]                INT            NULL,
    CONSTRAINT [PK_FIREOCCUPANCYBUSINESS] PRIMARY KEY NONCLUSTERED ([FIREOCCUPANCYBUSINESSID] ASC),
    CONSTRAINT [FK_FIREOCCUPANCYBUSINESS_FO] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID]),
    CONSTRAINT [FK_FIREOCCUPANCYBUSINESS_FOBUSINESSSTATUS] FOREIGN KEY ([FOBUSINESSSTATUSID]) REFERENCES [dbo].[FOBUSINESSSTATUS] ([FOBUSINESSSTATUSID]),
    CONSTRAINT [FK_FIREOCCUPANCYBUSINESS_PM] FOREIGN KEY ([BLGLOBALENTITYEXTENSIONID]) REFERENCES [dbo].[BLGLOBALENTITYEXTENSION] ([BLGLOBALENTITYEXTENSIONID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FIREOCCUPANCYBUSINESS_FO]
    ON [dbo].[FIREOCCUPANCYBUSINESS]([FIREOCCUPANCYID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FIREOCCUPANCYBUSINESS_BS]
    ON [dbo].[FIREOCCUPANCYBUSINESS]([BLGLOBALENTITYEXTENSIONID] ASC);

