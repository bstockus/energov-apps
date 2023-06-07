﻿CREATE TABLE [dbo].[FORMSUBCATEGORYSUBMENUXREF] (
    [FKFORMSUBCATEGORYID] CHAR (36) NOT NULL,
    [FKSUBMENUID]         CHAR (36) NOT NULL,
    [DISPLAYORDER]        INT       NOT NULL,
    CONSTRAINT [PK_FORMSUBCATEGORYSUBMENUXREF] PRIMARY KEY CLUSTERED ([FKFORMSUBCATEGORYID] ASC, [FKSUBMENUID] ASC),
    CONSTRAINT [FK_FORMSUBCATEGORYSUBMENUXREF_FORMSUBCATEGORY] FOREIGN KEY ([FKFORMSUBCATEGORYID]) REFERENCES [dbo].[FORMSUBCATEGORY] ([FORMSUBCATEGORYID]),
    CONSTRAINT [FK_FORMSUBCATEGORYSUBMENUXREF_SUBMENU] FOREIGN KEY ([FKSUBMENUID]) REFERENCES [dbo].[SUBMENUS] ([SSUBMENUGUID])
);

