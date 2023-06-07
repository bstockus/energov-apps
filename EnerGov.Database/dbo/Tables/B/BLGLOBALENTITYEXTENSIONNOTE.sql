﻿CREATE TABLE [dbo].[BLGLOBALENTITYEXTENSIONNOTE] (
    [BLGLOBALENTITYEXTENSIONNOTEID] CHAR (36)      NOT NULL,
    [BLGLOBALENTITYEXTENSIONID]     CHAR (36)      NULL,
    [TEXT]                          NVARCHAR (MAX) NULL,
    [CREATEDBY]                     CHAR (36)      NULL,
    [CREATEDDATE]                   DATETIME       NULL,
    [TITLE]                         NVARCHAR (50)  CONSTRAINT [DF_BLGLOBALENTITYEXTENSIONNOTE_TITLE] DEFAULT ('') NULL,
    [PIN]                           BIT            CONSTRAINT [DF_BLGLOBALENTITYEXTENSIONNOTE_PIN] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_BLGlobalEntityExtensionNote] PRIMARY KEY CLUSTERED ([BLGLOBALENTITYEXTENSIONNOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLGlobalEntityExtensionNote_BLGlobalEntityExtension] FOREIGN KEY ([BLGLOBALENTITYEXTENSIONID]) REFERENCES [dbo].[BLGLOBALENTITYEXTENSION] ([BLGLOBALENTITYEXTENSIONID]),
    CONSTRAINT [FK_BLGlobalEntityExtensionNote_Users] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

