﻿CREATE TABLE [dbo].[WFSTEPTYPE] (
    [WFSTEPTYPEID] INT           NOT NULL,
    [NAME]         NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_WFStepType] PRIMARY KEY CLUSTERED ([WFSTEPTYPEID] ASC) WITH (FILLFACTOR = 90)
);
