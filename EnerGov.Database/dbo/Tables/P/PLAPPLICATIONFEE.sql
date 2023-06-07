﻿CREATE TABLE [dbo].[PLAPPLICATIONFEE] (
    [PLAPPLICATIONFEEID] CHAR (36) NOT NULL,
    [PLAPPLICATIONID]    CHAR (36) NOT NULL,
    [CACOMPUTEDFEEID]    CHAR (36) NOT NULL,
    [CREATEDON]          DATETIME  NOT NULL,
    CONSTRAINT [PK_PLApplicationFee] PRIMARY KEY NONCLUSTERED ([PLAPPLICATIONFEEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLApplicationFee_App] FOREIGN KEY ([PLAPPLICATIONID]) REFERENCES [dbo].[PLAPPLICATION] ([PLAPPLICATIONID]),
    CONSTRAINT [FK_PLApplicationFee_ComputedFee] FOREIGN KEY ([CACOMPUTEDFEEID]) REFERENCES [dbo].[CACOMPUTEDFEE] ([CACOMPUTEDFEEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PLApplicationFee_App]
    ON [dbo].[PLAPPLICATIONFEE]([PLAPPLICATIONID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_PLApplicationFee_Fee]
    ON [dbo].[PLAPPLICATIONFEE]([CACOMPUTEDFEEID] ASC);
