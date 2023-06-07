﻿CREATE TABLE [dbo].[OMOBJECTGISFEATURE] (
    [OMOBJECTGISFEATUREID] CHAR (36)     NOT NULL,
    [FEATURELAYER]         VARCHAR (100) NOT NULL,
    [ATTRIBUTEFIELD]       VARCHAR (50)  NULL,
    [KEYVALUE]             VARCHAR (50)  NOT NULL,
    [OMOBJECTID]           CHAR (36)     NOT NULL,
    CONSTRAINT [PK_OMOBJECTGISFEATURES] PRIMARY KEY CLUSTERED ([OMOBJECTGISFEATUREID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OMOBJGISFEATURE_OMOBJ] FOREIGN KEY ([OMOBJECTID]) REFERENCES [dbo].[OMOBJECT] ([OMOBJECTID])
);
