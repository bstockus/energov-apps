﻿CREATE TABLE [dbo].[PRPROJECTFEE] (
    [PRPROJECTFEEID]  CHAR (36) NOT NULL,
    [PRPROJECTID]     CHAR (36) NOT NULL,
    [CACOMPUTEDFEEID] CHAR (36) NOT NULL,
    [CREATEDON]       DATETIME  NOT NULL,
    CONSTRAINT [PK_PRProjectFee] PRIMARY KEY NONCLUSTERED ([PRPROJECTFEEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PRProjectFee_ComputedFee] FOREIGN KEY ([CACOMPUTEDFEEID]) REFERENCES [dbo].[CACOMPUTEDFEE] ([CACOMPUTEDFEEID]),
    CONSTRAINT [FK_PRProjectFee_PRProject] FOREIGN KEY ([PRPROJECTID]) REFERENCES [dbo].[PRPROJECT] ([PRPROJECTID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PRProjectFee_Project]
    ON [dbo].[PRPROJECTFEE]([PRPROJECTID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_PRProjectFee_Fee]
    ON [dbo].[PRPROJECTFEE]([CACOMPUTEDFEEID] ASC);

