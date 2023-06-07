﻿CREATE TABLE [dbo].[CAFINANCIALINTARAUDIT] (
    [CAFINANCIALINTARAUDITID]  BIGINT         IDENTITY (1, 1) NOT NULL,
    [CATRANSACTIONARPOSTINGID] CHAR (36)      NOT NULL,
    [CHARGECODE]               NVARCHAR (100) NULL,
    [INVOICENUMBER]            NVARCHAR (500) NOT NULL,
    [BATCHNUMBER]              NVARCHAR (50)  NOT NULL,
    [BATCHPROCESSEDDATE]       DATETIME       NOT NULL,
    CONSTRAINT [PK_CAFINANCIALINTARAUDIT] PRIMARY KEY CLUSTERED ([CAFINANCIALINTARAUDITID] ASC),
    CONSTRAINT [FK_CAFININTARAUDIT_ARPOSTING] FOREIGN KEY ([CATRANSACTIONARPOSTINGID]) REFERENCES [dbo].[CATRANSACTIONARPOSTING] ([CATRANSACTIONARPOSTINGID])
);

