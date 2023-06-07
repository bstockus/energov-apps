﻿CREATE TABLE [dbo].[ASSETGEOMETRY] (
    [ASSETGEOMETRYID]         CHAR (36)     NOT NULL,
    [ASSETGEOMETRYCOLLECTION] CHAR (36)     NOT NULL,
    [NAME]                    VARCHAR (50)  NULL,
    [DESCRIPTION]             VARCHAR (500) NULL,
    [GEOMETRYTYPE]            VARCHAR (50)  NULL,
    [FEATURELAYER]            VARCHAR (100) NULL,
    [ATTRIBUTEFIELD]          VARCHAR (50)  NULL,
    [KEYVALUE]                VARCHAR (50)  NULL,
    CONSTRAINT [PK_AssetGeometry] PRIMARY KEY CLUSTERED ([ASSETGEOMETRYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AssetGeometry_AssetGeometryCollection] FOREIGN KEY ([ASSETGEOMETRYCOLLECTION]) REFERENCES [dbo].[ASSETGEOMETRYCOLLECTION] ([ASSETGEOMETRYCOLLECTIONID])
);

