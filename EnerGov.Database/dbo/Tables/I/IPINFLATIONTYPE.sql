﻿CREATE TABLE [dbo].[IPINFLATIONTYPE] (
    [IPINFLATIONTYPEID] INT           NOT NULL,
    [NAME]              NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_IPINFLATIONTYPE] PRIMARY KEY CLUSTERED ([IPINFLATIONTYPEID] ASC) WITH (FILLFACTOR = 90)
);

