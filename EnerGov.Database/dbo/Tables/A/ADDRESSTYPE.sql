﻿CREATE TABLE [dbo].[ADDRESSTYPE] (
    [ADDRESSTYPEID] CHAR (36)     CONSTRAINT [DF_AddressType_AddTypeID] DEFAULT (newid()) NOT NULL,
    [NAME]          NVARCHAR (50) NOT NULL,
    [SITEID]        NVARCHAR (25) NULL,
    CONSTRAINT [PK_AddressType] PRIMARY KEY CLUSTERED ([ADDRESSTYPEID] ASC) WITH (FILLFACTOR = 90)
);
