﻿CREATE TABLE [dbo].[AMASSETTYPEASSETSTATUSXREF] (
    [AMASSETTYPEASSETSTATUSXREFID] CHAR (36) NOT NULL,
    [AMASSETTYPEID]                CHAR (36) NOT NULL,
    [AMASSETSTATUSID]              CHAR (36) NOT NULL,
    CONSTRAINT [PK_AMTypeAssetStatusXRef] PRIMARY KEY CLUSTERED ([AMASSETTYPEASSETSTATUSXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMAstTypeAstStatusXRef] FOREIGN KEY ([AMASSETSTATUSID]) REFERENCES [dbo].[AMASSETSTATUS] ([AMASSETSTATUSID]),
    CONSTRAINT [FK_AMTypeStatusXRef_AMType] FOREIGN KEY ([AMASSETTYPEID]) REFERENCES [dbo].[AMASSETTYPE] ([AMASSETTYPEID])
);

