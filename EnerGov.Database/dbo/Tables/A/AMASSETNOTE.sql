﻿CREATE TABLE [dbo].[AMASSETNOTE] (
    [AMASSETNOTEID] CHAR (36)     NOT NULL,
    [AMASSETID]     CHAR (36)     NOT NULL,
    [TEXT]          NVARCHAR (50) NULL,
    [CREATEDBY]     CHAR (36)     NULL,
    [CREATEDDATE]   DATETIME      NULL,
    CONSTRAINT [PK_AMAssetNote] PRIMARY KEY CLUSTERED ([AMASSETNOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMAssetNote_AMAsset] FOREIGN KEY ([AMASSETID]) REFERENCES [dbo].[AMASSET] ([AMASSETID]),
    CONSTRAINT [FK_AMAssetNote_Users_CreatedBy] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

