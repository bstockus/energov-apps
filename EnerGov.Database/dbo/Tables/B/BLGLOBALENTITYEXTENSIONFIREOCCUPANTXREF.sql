﻿CREATE TABLE [dbo].[BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREF] (
    [BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREFID] CHAR (36)     NOT NULL,
    [BLGLOBALENTITYEXTENSIONID]                 CHAR (36)     NOT NULL,
    [FIREOCCUPANTID]                            INT           NOT NULL,
    [FIREOCCUPANCYNUMBER]                       NVARCHAR (50) NULL,
    CONSTRAINT [PK_BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREF] PRIMARY KEY CLUSTERED ([BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREFID] ASC),
    CONSTRAINT [FK_BLGLOBALENTITYEXTENSIONXREF] FOREIGN KEY ([BLGLOBALENTITYEXTENSIONID]) REFERENCES [dbo].[BLGLOBALENTITYEXTENSION] ([BLGLOBALENTITYEXTENSIONID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREF_BUSINESS_FIREOCCUPANT]
    ON [dbo].[BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREF]([BLGLOBALENTITYEXTENSIONID] ASC, [FIREOCCUPANTID] ASC);

