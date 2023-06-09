﻿CREATE TABLE [dbo].[INBINTYPE] (
    [INBINTYPEID] CHAR (36)      NOT NULL,
    [NAME]        NVARCHAR (50)  NOT NULL,
    [DESCRIPTION] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_INBinType] PRIMARY KEY CLUSTERED ([INBINTYPEID] ASC) WITH (FILLFACTOR = 90)
);

