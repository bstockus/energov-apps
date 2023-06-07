﻿CREATE TABLE [dbo].[FTPFILENAMEOPTION] (
    [FTPFILENAMEOPTIONID] INT            NOT NULL,
    [NAME]                NVARCHAR (100) NOT NULL,
    [DESCRIPTION]         NVARCHAR (255) NULL,
    CONSTRAINT [PK_FTPFILENAMEOPTION] PRIMARY KEY CLUSTERED ([FTPFILENAMEOPTIONID] ASC)
);
