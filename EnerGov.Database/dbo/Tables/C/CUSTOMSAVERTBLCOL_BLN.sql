﻿CREATE TABLE [dbo].[CUSTOMSAVERTBLCOL_BLN] (
    [CUSTOMSAVERTABLECOLUMNID] CHAR (36) NOT NULL,
    [OBJECTID]                 CHAR (36) NOT NULL,
    [MODULEID]                 INT       NOT NULL,
    [BITVALUE]                 BIT       NULL,
    [CFTABLECOLUMNREFID]       CHAR (36) NOT NULL,
    [ROWNUMBER]                INT       NOT NULL,
    CONSTRAINT [PK_CUSTOMSAVERTBLCOL_BLN] PRIMARY KEY CLUSTERED ([CUSTOMSAVERTABLECOLUMNID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CFSAVERTBL_COLREF_BLN] FOREIGN KEY ([CFTABLECOLUMNREFID]) REFERENCES [dbo].[CUSTOMFIELDTABLECOLUMNREF] ([CUSTOMFIELDTABLECOLUMNREFID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTOMSAVOBJID_BLN]
    ON [dbo].[CUSTOMSAVERTBLCOL_BLN]([OBJECTID] ASC, [CFTABLECOLUMNREFID] ASC, [ROWNUMBER] ASC)
    INCLUDE([BITVALUE]);


GO
CREATE NONCLUSTERED INDEX [IX_CFTABLECOLUMNREFID_BLN]
    ON [dbo].[CUSTOMSAVERTBLCOL_BLN]([CFTABLECOLUMNREFID] ASC);
