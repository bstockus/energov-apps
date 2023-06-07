﻿CREATE TABLE [dbo].[CATRANSACTIONARINTEGRATION] (
    [CATRANSACTIONARINTEGRATIONID] CHAR (36)     NOT NULL,
    [CATRANSACTIONARPOSTINGID]     CHAR (36)     NOT NULL,
    [BATCHNUMBER]                  NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CATRANSACTIONARINTEGRATION] PRIMARY KEY CLUSTERED ([CATRANSACTIONARINTEGRATIONID] ASC),
    CONSTRAINT [FK_CATRANSACTIONARINT_ARPOST] FOREIGN KEY ([CATRANSACTIONARPOSTINGID]) REFERENCES [dbo].[CATRANSACTIONARPOSTING] ([CATRANSACTIONARPOSTINGID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CATRANSACTIONARINTEGRATION_BATCHNUMBER]
    ON [dbo].[CATRANSACTIONARINTEGRATION]([BATCHNUMBER] ASC);
