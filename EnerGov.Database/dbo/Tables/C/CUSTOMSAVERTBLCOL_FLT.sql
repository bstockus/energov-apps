﻿CREATE TABLE [dbo].[CUSTOMSAVERTBLCOL_FLT] (
    [CUSTOMSAVERTABLECOLUMNID] CHAR (36)  NOT NULL,
    [OBJECTID]                 CHAR (36)  NOT NULL,
    [MODULEID]                 INT        NOT NULL,
    [FLOATVALUE]               FLOAT (53) NULL,
    [CFTABLECOLUMNREFID]       CHAR (36)  NOT NULL,
    [ROWNUMBER]                INT        NOT NULL,
    CONSTRAINT [PK_CUSTOMSAVERTBLCOL_FLT] PRIMARY KEY CLUSTERED ([CUSTOMSAVERTABLECOLUMNID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CFSAVERTBL_COLREF_FLT] FOREIGN KEY ([CFTABLECOLUMNREFID]) REFERENCES [dbo].[CUSTOMFIELDTABLECOLUMNREF] ([CUSTOMFIELDTABLECOLUMNREFID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CUSTOMSAVOBJID_FLT]
    ON [dbo].[CUSTOMSAVERTBLCOL_FLT]([OBJECTID] ASC, [CFTABLECOLUMNREFID] ASC, [ROWNUMBER] ASC)
    INCLUDE([FLOATVALUE]);


GO
CREATE NONCLUSTERED INDEX [IX_CFTABLECOLUMNREFID_FLT]
    ON [dbo].[CUSTOMSAVERTBLCOL_FLT]([CFTABLECOLUMNREFID] ASC);

