﻿CREATE TABLE [dbo].[CAFEETYPE] (
    [CAFEETYPEID]           INT            NOT NULL,
    [NAME]                  NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [USEDFEEADJUSTMENTCALC] BIT            NOT NULL,
    CONSTRAINT [PK_CAFeeType] PRIMARY KEY CLUSTERED ([CAFEETYPEID] ASC) WITH (FILLFACTOR = 90)
);

