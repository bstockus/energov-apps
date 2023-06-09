﻿CREATE TABLE [dbo].[ERPROJECTFILEVERSIONFILEATTRIBUTES] (
    [ERPROJECTFILEVERSIONFILEATTRIBUTEID] CHAR (36)       NOT NULL,
    [ERPROJECTFILEVERSIONID]              CHAR (36)       NOT NULL,
    [ERPROJECTFILEATTRIBUTETYPEID]        INT             NOT NULL,
    [BITVALUE]                            BIT             CONSTRAINT [DF_ErProjectFileVersionFileAttributes_BitValue] DEFAULT ((0)) NULL,
    [STRINGVALUE]                         NVARCHAR (4000) NULL,
    CONSTRAINT [PK_ErProjectFileVersionFileAttributes] PRIMARY KEY CLUSTERED ([ERPROJECTFILEVERSIONFILEATTRIBUTEID] ASC),
    CONSTRAINT [FK_ErProjectFileVersionFileAttributes_ErProjectFileAttributeTypes_Id] FOREIGN KEY ([ERPROJECTFILEATTRIBUTETYPEID]) REFERENCES [dbo].[ERPROJECTFILEATTRIBUTETYPES] ([ERPROJECTFILEATTRIBUTETYPEID]),
    CONSTRAINT [FK_ErProjectFileVersionFileAttributes_ErProjectFileVersion_ErProjectFileVersionId] FOREIGN KEY ([ERPROJECTFILEVERSIONID]) REFERENCES [dbo].[ERPROJECTFILEVERSION] ([ERPROJECTFILEVERSIONID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ERPROJECTFILEVERSIONFILEATTRIBUTES_ERPROJECTFILEVERSIONID_ERPROJECTFILEATTRIBUTETYPEID]
    ON [dbo].[ERPROJECTFILEVERSIONFILEATTRIBUTES]([ERPROJECTFILEVERSIONID] ASC, [ERPROJECTFILEATTRIBUTETYPEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ERPROJECTFILEVERSIONFILEATTRIBUTES_ERPROJECTFILEVERSIONID]
    ON [dbo].[ERPROJECTFILEVERSIONFILEATTRIBUTES]([ERPROJECTFILEVERSIONID] ASC);

