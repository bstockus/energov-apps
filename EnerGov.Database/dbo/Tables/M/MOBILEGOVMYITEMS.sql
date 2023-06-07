﻿CREATE TABLE [dbo].[MOBILEGOVMYITEMS] (
    [ITEMID]                  CHAR (36)      NOT NULL,
    [ITEMTYPE]                NVARCHAR (200) NOT NULL,
    [SERVERROWVERSION]        INT            NULL,
    [REQUIRESWAREHOUSEUPDATE] BIT            DEFAULT ((0)) NULL,
    [SYNCERROR]               NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_MobileGovMyItems] PRIMARY KEY CLUSTERED ([ITEMID] ASC, [ITEMTYPE] ASC) WITH (FILLFACTOR = 90)
);
