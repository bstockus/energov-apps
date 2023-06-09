﻿CREATE TABLE [dbo].[CACOMPUTEDFEEDISCOUNTXREF] (
    [CACOMPUTEDFEEDISCOUNTXREFID] CHAR (36) NOT NULL,
    [CACOMPUTEDFEEID]             CHAR (36) NOT NULL,
    [CACOMPUTEDDISCOUNTID]        CHAR (36) NOT NULL,
    [APPLYORDER]                  INT       CONSTRAINT [DF_CAFeeDiscnt_ApplyOrder] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CAComputedFeeDiscountXRef] PRIMARY KEY CLUSTERED ([CACOMPUTEDFEEDISCOUNTXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CAFeeDiscnt_Discnt] FOREIGN KEY ([CACOMPUTEDDISCOUNTID]) REFERENCES [dbo].[CACOMPUTEDDISCOUNT] ([CACOMPUTEDDISCOUNTID]),
    CONSTRAINT [FK_CAFeeDiscnt_Fee] FOREIGN KEY ([CACOMPUTEDFEEID]) REFERENCES [dbo].[CACOMPUTEDFEE] ([CACOMPUTEDFEEID]),
    CONSTRAINT [UK_CAFeeDiscnt_Fee_Discnt] UNIQUE NONCLUSTERED ([CACOMPUTEDFEEID] ASC, [CACOMPUTEDDISCOUNTID] ASC) WITH (FILLFACTOR = 90)
);

