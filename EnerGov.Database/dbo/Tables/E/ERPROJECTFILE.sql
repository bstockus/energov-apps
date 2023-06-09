﻿CREATE TABLE [dbo].[ERPROJECTFILE] (
    [ERPROJECTFILEID]         CHAR (36)      NOT NULL,
    [ERPROJECTID]             CHAR (36)      NOT NULL,
    [FILENAME]                NVARCHAR (200) NOT NULL,
    [ROWVERSION]              INT            NOT NULL,
    [CREATEDATE]              DATETIME       NOT NULL,
    [ALLOWREVISIONFILEUPLOAD] BIT            NOT NULL,
    [PENDING]                 BIT            CONSTRAINT [DF_ERProjectFile_Pending] DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       NULL,
    [MARKDELETE]              BIT            CONSTRAINT [DF_ERProjectFile_MarkDelete] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ERProjectFile] PRIMARY KEY CLUSTERED ([ERPROJECTFILEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ERProjectFile_ERProject] FOREIGN KEY ([ERPROJECTID]) REFERENCES [dbo].[ERPROJECT] ([ERPROJECTID]),
    CONSTRAINT [FK_ERProjectFile_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [NCIDX_ERPROJECTFILEID]
    ON [dbo].[ERPROJECTFILE]([ERPROJECTFILEID] ASC);

