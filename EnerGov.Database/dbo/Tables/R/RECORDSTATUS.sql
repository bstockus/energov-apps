﻿CREATE TABLE [dbo].[RECORDSTATUS] (
    [RECORDSTATUSID] INT            NOT NULL,
    [NAME]           NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]    NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_RECORDSTATUS] PRIMARY KEY CLUSTERED ([RECORDSTATUSID] ASC)
);

