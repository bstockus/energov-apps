﻿CREATE TABLE [dbo].[IPMILESTONETYPE] (
    [IPMILESTONETYPEID] INT           NOT NULL,
    [NAME]              NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_IPMILESTONETYPE] PRIMARY KEY CLUSTERED ([IPMILESTONETYPEID] ASC) WITH (FILLFACTOR = 90)
);

