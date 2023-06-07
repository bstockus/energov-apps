﻿CREATE TABLE [dbo].[CACOMPUTATIONTYPE] (
    [CACOMPUTATIONTYPEID] INT            NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_CAComputationType] PRIMARY KEY CLUSTERED ([CACOMPUTATIONTYPEID] ASC) WITH (FILLFACTOR = 90)
);
