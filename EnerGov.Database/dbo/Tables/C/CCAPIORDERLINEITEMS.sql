﻿CREATE TABLE [dbo].[CCAPIORDERLINEITEMS] (
    [ORDERLINEITEMID] CHAR (36)      NOT NULL,
    [ORDERID]         CHAR (36)      NOT NULL,
    [QUANTITY]        INT            NULL,
    [DESCRIPTION]     NVARCHAR (MAX) NULL,
    [UNITPRICE]       MONEY          NULL,
    [LINEITEMPRICE]   MONEY          NULL,
    CONSTRAINT [PK_CCAPIORDERLINEITEMS] PRIMARY KEY CLUSTERED ([ORDERLINEITEMID] ASC),
    CONSTRAINT [FK_ORDERLINEITEMS_ORDERS] FOREIGN KEY ([ORDERID]) REFERENCES [dbo].[CCAPIORDERS] ([ORDERID])
);

