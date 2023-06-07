﻿CREATE TABLE [dbo].[BLEINFORMAT] (
    [BLEINFORMATID] INT            NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [EINFORMAT]     NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_BLEINFormat] PRIMARY KEY CLUSTERED ([BLEINFORMATID] ASC) WITH (FILLFACTOR = 90)
);
