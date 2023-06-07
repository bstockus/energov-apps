﻿CREATE TABLE [dbo].[MENUS] (
    [SMENUGUID]    CHAR (36)     CONSTRAINT [DF_Menus_sMenuGUID] DEFAULT (newid()) NOT NULL,
    [SDESCRIPTION] NVARCHAR (50) NOT NULL,
    [IORDER]       SMALLINT      CONSTRAINT [DF_Menus_iOrder] DEFAULT ((0)) NOT NULL,
    [MODULE_ID]    INT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED ([SMENUGUID] ASC) WITH (FILLFACTOR = 90)
);
