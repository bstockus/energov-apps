﻿CREATE TABLE [dbo].[PMPERMITIMPACTUNIT] (
    [PMPERMITIMPACTUNITID] CHAR (36)       NOT NULL,
    [PMPERMITID]           CHAR (36)       NOT NULL,
    [IPUNITTYPEID]         CHAR (36)       NOT NULL,
    [NUMOFUNIT]            DECIMAL (20, 4) NOT NULL,
    [COMMENTS]             NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_PMPERMITIMPACTUNIT] PRIMARY KEY CLUSTERED ([PMPERMITIMPACTUNITID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PMPERMITUNIT_IPUNITTYPE] FOREIGN KEY ([IPUNITTYPEID]) REFERENCES [dbo].[IPUNITTYPE] ([IPUNITTYPEID]),
    CONSTRAINT [FK_PMPERMITUNIT_PMPERMIT] FOREIGN KEY ([PMPERMITID]) REFERENCES [dbo].[PMPERMIT] ([PMPERMITID])
);

