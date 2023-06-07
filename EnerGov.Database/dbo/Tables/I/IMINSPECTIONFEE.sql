﻿CREATE TABLE [dbo].[IMINSPECTIONFEE] (
    [IMINSPECTIONFEEID] CHAR (36) NOT NULL,
    [IMINSPECTIONID]    CHAR (36) NOT NULL,
    [CACOMPUTEDFEEID]   CHAR (36) NOT NULL,
    [CREATEDON]         DATETIME  NOT NULL,
    CONSTRAINT [PK_IMINSPECTIONFEE] PRIMARY KEY NONCLUSTERED ([IMINSPECTIONFEEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IMINSPECTIONFEE_FEE] FOREIGN KEY ([CACOMPUTEDFEEID]) REFERENCES [dbo].[CACOMPUTEDFEE] ([CACOMPUTEDFEEID]),
    CONSTRAINT [FK_IMINSPFEE_IMINSP] FOREIGN KEY ([IMINSPECTIONID]) REFERENCES [dbo].[IMINSPECTION] ([IMINSPECTIONID])
);


GO
CREATE NONCLUSTERED INDEX [NCIDX_IMINSPECTIONFEE_IMINSPECTIONID]
    ON [dbo].[IMINSPECTIONFEE]([IMINSPECTIONID] ASC, [CACOMPUTEDFEEID] ASC) WITH (FILLFACTOR = 90, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [IX_IMINSPECTIONFEE_CACOMPUTEDFEEID]
    ON [dbo].[IMINSPECTIONFEE]([CACOMPUTEDFEEID] ASC);

