﻿CREATE TABLE [dbo].[ASSETGEOMETRYPOINTS] (
    [ASSETGEOMETRYPOINTID] CHAR (36)        NOT NULL,
    [ASSETGEOMETRY]        CHAR (36)        NOT NULL,
    [POINTORDER]           INT              NULL,
    [POINTX]               NUMERIC (29, 15) NULL,
    [POINTY]               NUMERIC (29, 15) NULL,
    [SPATIALREFERENCE]     VARCHAR (50)     NULL,
    CONSTRAINT [PK_AssetGeometryPoints] PRIMARY KEY CLUSTERED ([ASSETGEOMETRYPOINTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AssetGeometryPoints_AssetGeometry] FOREIGN KEY ([ASSETGEOMETRY]) REFERENCES [dbo].[ASSETGEOMETRY] ([ASSETGEOMETRYID])
);

