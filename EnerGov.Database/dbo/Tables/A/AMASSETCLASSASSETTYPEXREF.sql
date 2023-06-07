﻿CREATE TABLE [dbo].[AMASSETCLASSASSETTYPEXREF] (
    [AMASSETCLASSASSETTYPEXREFID] CHAR (36) NOT NULL,
    [AMASSETCLASSID]              CHAR (36) NOT NULL,
    [AMASSETTYPEID]               CHAR (36) NOT NULL,
    CONSTRAINT [PK_AMAssetClassAssetTypeXRef] PRIMARY KEY CLUSTERED ([AMASSETCLASSASSETTYPEXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMAstClassAstTypeXRef_AMAst] FOREIGN KEY ([AMASSETCLASSID]) REFERENCES [dbo].[AMASSETCLASS] ([AMASSETCLASSID]),
    CONSTRAINT [FK_AMAstClassAstTypeXRef_AMAstType] FOREIGN KEY ([AMASSETTYPEID]) REFERENCES [dbo].[AMASSETTYPE] ([AMASSETTYPEID])
);
