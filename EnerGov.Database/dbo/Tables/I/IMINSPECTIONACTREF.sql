﻿CREATE TABLE [dbo].[IMINSPECTIONACTREF] (
    [OBJECTID]       CHAR (36)      NOT NULL,
    [IMINSPECTIONID] CHAR (36)      NOT NULL,
    [OBJECTMSG]      NVARCHAR (255) NULL,
    CONSTRAINT [PK_IMInspectionActRef] PRIMARY KEY CLUSTERED ([OBJECTID] ASC, [IMINSPECTIONID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_IMInspectionActRef_Ins] FOREIGN KEY ([IMINSPECTIONID]) REFERENCES [dbo].[IMINSPECTION] ([IMINSPECTIONID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[IMINSPECTIONACTREF]([IMINSPECTIONID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[IMINSPECTIONACTREF]([OBJECTID] ASC) WITH (FILLFACTOR = 80);

