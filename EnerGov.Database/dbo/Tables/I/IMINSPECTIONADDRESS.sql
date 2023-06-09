﻿CREATE TABLE [dbo].[IMINSPECTIONADDRESS] (
    [INSPECTIONADDRESSID] CHAR (36) NOT NULL,
    [IMINSPECTIONID]      CHAR (36) NOT NULL,
    [MAILINGADDRESSID]    CHAR (36) NOT NULL,
    [MAIN]                BIT       NOT NULL,
    CONSTRAINT [PK_IMInspectionAddress] PRIMARY KEY CLUSTERED ([INSPECTIONADDRESSID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_InspectionAdd_Add] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_InspectionAdd_Insp] FOREIGN KEY ([IMINSPECTIONID]) REFERENCES [dbo].[IMINSPECTION] ([IMINSPECTIONID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[IMINSPECTIONADDRESS]([IMINSPECTIONID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[IMINSPECTIONADDRESS]([MAILINGADDRESSID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_IMINSPECTIONADDRESS_MAIN]
    ON [dbo].[IMINSPECTIONADDRESS]([IMINSPECTIONID] ASC, [MAILINGADDRESSID] ASC, [MAIN] ASC) WITH (FILLFACTOR = 90, PAD_INDEX = ON);

