﻿CREATE TABLE [dbo].[CUSTOMSAVERTBLCOL_LST] (
    [CUSTOMSAVERTABLECOLUMNID] CHAR (36) NOT NULL,
    [OBJECTID]                 CHAR (36) NOT NULL,
    [MODULEID]                 INT       NOT NULL,
    [PICKLISTVALUE]            CHAR (36) NULL,
    [CFTABLECOLUMNREFID]       CHAR (36) NOT NULL,
    [ROWNUMBER]                INT       NOT NULL,
    CONSTRAINT [PK_CUSTOMSAVERTBLCOL_LST] PRIMARY KEY CLUSTERED ([CUSTOMSAVERTABLECOLUMNID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CFSAVERTBL_COLREF_LST] FOREIGN KEY ([CFTABLECOLUMNREFID]) REFERENCES [dbo].[CUSTOMFIELDTABLECOLUMNREF] ([CUSTOMFIELDTABLECOLUMNREFID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTOMSAVOBJID_LST]
    ON [dbo].[CUSTOMSAVERTBLCOL_LST]([OBJECTID] ASC, [CFTABLECOLUMNREFID] ASC, [ROWNUMBER] ASC)
    INCLUDE([PICKLISTVALUE]);


GO
CREATE NONCLUSTERED INDEX [IX_CFTABLECOLUMNREFID_LST]
    ON [dbo].[CUSTOMSAVERTBLCOL_LST]([CFTABLECOLUMNREFID] ASC);

