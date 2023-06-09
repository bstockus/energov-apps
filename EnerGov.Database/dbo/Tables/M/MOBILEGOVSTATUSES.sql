﻿CREATE TABLE [dbo].[MOBILEGOVSTATUSES] (
    [ITEM]        INT            NOT NULL,
    [UPDATETIME]  DATETIME       NOT NULL,
    [DESCRIPTION] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_MobileGovStatuses] PRIMARY KEY CLUSTERED ([ITEM] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MobileGovStatuses_Item] FOREIGN KEY ([ITEM]) REFERENCES [dbo].[MOBILEGOVSTATUSTYPES] ([ITEM])
);

