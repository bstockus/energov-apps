﻿CREATE TABLE [dbo].[AMENDMENTSTATUS] (
    [AMENDMENTSTATUSID] CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    [ACTIVE]            BIT            NOT NULL,
    [COMPLETE]          BIT            NOT NULL,
    CONSTRAINT [PK_AMENDMENTSTATUS] PRIMARY KEY CLUSTERED ([AMENDMENTSTATUSID] ASC) WITH (FILLFACTOR = 90)
);

