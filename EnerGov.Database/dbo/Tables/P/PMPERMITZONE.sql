﻿CREATE TABLE [dbo].[PMPERMITZONE] (
    [PMPERMITZONEID] CHAR (36) NOT NULL,
    [PMPERMITID]     CHAR (36) NOT NULL,
    [ZONEID]         CHAR (36) NOT NULL,
    [MAIN]           BIT       NOT NULL,
    CONSTRAINT [PK_PMPermitZone] PRIMARY KEY CLUSTERED ([PMPERMITZONEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PMPermitZone_PMPermit] FOREIGN KEY ([PMPERMITID]) REFERENCES [dbo].[PMPERMIT] ([PMPERMITID]),
    CONSTRAINT [FK_PMPermitZone_Zone] FOREIGN KEY ([ZONEID]) REFERENCES [dbo].[ZONE] ([ZONEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PMPERMZONE_PERMIT_ALL]
    ON [dbo].[PMPERMITZONE]([PMPERMITID] ASC)
    INCLUDE([ZONEID], [MAIN]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [PMPERMITZONE_INSP]
    ON [dbo].[PMPERMITZONE]([PMPERMITID] ASC) WITH (FILLFACTOR = 80);

