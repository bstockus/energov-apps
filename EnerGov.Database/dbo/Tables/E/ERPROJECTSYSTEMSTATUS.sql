﻿CREATE TABLE [dbo].[ERPROJECTSYSTEMSTATUS] (
    [ERPROJECTSYSTEMSTATUSID] INT           NOT NULL,
    [NAME]                    NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ERProjectSystemStatus] PRIMARY KEY CLUSTERED ([ERPROJECTSYSTEMSTATUSID] ASC) WITH (FILLFACTOR = 90)
);
