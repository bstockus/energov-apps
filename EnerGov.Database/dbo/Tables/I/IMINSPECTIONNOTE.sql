﻿CREATE TABLE [dbo].[IMINSPECTIONNOTE] (
    [IMINSPECTIONNOTEID] CHAR (36)      NOT NULL,
    [IMINSPECTIONID]     CHAR (36)      NOT NULL,
    [TEXT]               NVARCHAR (MAX) NULL,
    [CREATEDBY]          CHAR (36)      NOT NULL,
    [CREATEDDATE]        DATETIME       NOT NULL,
    [TITLE]              NVARCHAR (50)  CONSTRAINT [DF_IMINSPECTIONNOTE_TITLE] DEFAULT ('') NULL,
    [PIN]                BIT            CONSTRAINT [DF_IMINSPECTIONNOTE_PIN] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_IMInspectionNote] PRIMARY KEY CLUSTERED ([IMINSPECTIONNOTEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_IMInspectionNote_Users] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_Note_Inspection] FOREIGN KEY ([IMINSPECTIONID]) REFERENCES [dbo].[IMINSPECTION] ([IMINSPECTIONID])
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTIONNOTE_INSP]
    ON [dbo].[IMINSPECTIONNOTE]([IMINSPECTIONID] ASC) WITH (FILLFACTOR = 80);

