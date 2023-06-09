﻿CREATE TABLE [dbo].[AMASSETCHILD] (
    [AMASSETCHILDID] CHAR (36)     NOT NULL,
    [AMASSETID]      CHAR (36)     NOT NULL,
    [POSITION]       VARCHAR (100) NULL,
    [COMMENTS]       VARCHAR (100) NULL,
    [CHILDASSETID]   CHAR (36)     NULL,
    CONSTRAINT [AMChildAsset] PRIMARY KEY CLUSTERED ([AMASSETCHILDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMAsset_AMChildAsset] FOREIGN KEY ([CHILDASSETID]) REFERENCES [dbo].[AMASSET] ([AMASSETID]),
    CONSTRAINT [FK_AMAssetChild_AMAsset] FOREIGN KEY ([AMASSETID]) REFERENCES [dbo].[AMASSET] ([AMASSETID])
);

