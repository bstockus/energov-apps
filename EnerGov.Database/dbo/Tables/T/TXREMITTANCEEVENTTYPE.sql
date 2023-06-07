﻿CREATE TABLE [dbo].[TXREMITTANCEEVENTTYPE] (
    [TXREMITTANCEEVENTTYPEID] INT            NOT NULL,
    [NAME]                    NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [ACTIVE]                  BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_TXREMITTANCEEVENTTYPE] PRIMARY KEY CLUSTERED ([TXREMITTANCEEVENTTYPEID] ASC)
);
