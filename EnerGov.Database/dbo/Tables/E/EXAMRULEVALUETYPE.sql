﻿CREATE TABLE [dbo].[EXAMRULEVALUETYPE] (
    [EXAMRULEVALUETYPEID] INT           NOT NULL,
    [NAME]                NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EXAMRULEVALUETYPE] PRIMARY KEY CLUSTERED ([EXAMRULEVALUETYPEID] ASC) WITH (FILLFACTOR = 90)
);
