﻿CREATE TABLE [dbo].[CAACCOUNTACTION] (
    [CAACCOUNTACTIONID] INT            NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_CAAccountAction] PRIMARY KEY CLUSTERED ([CAACCOUNTACTIONID] ASC) WITH (FILLFACTOR = 90)
);

