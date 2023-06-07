﻿CREATE TABLE [dbo].[BUILDINGSTATUS] (
    [BUILDINGSTATUSID] CHAR (36)      NOT NULL,
    [NAME]             NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_BUILDINGSTATUSID] PRIMARY KEY CLUSTERED ([BUILDINGSTATUSID] ASC)
);
