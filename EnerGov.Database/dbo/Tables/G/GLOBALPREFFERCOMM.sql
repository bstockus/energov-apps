﻿CREATE TABLE [dbo].[GLOBALPREFFERCOMM] (
    [GLOBALPREFFERCOMMID] INT            NOT NULL,
    [PREFNAME]            NVARCHAR (100) NULL,
    CONSTRAINT [PK_GLOBALPREFFERCOMM] PRIMARY KEY CLUSTERED ([GLOBALPREFFERCOMMID] ASC) WITH (FILLFACTOR = 90)
);

