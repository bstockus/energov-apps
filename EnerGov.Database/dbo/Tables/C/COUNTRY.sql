﻿CREATE TABLE [dbo].[COUNTRY] (
    [COUNTRYID]   INT           IDENTITY (1, 1) NOT NULL,
    [COUNTRYNAME] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([COUNTRYID] ASC) WITH (FILLFACTOR = 90)
);
