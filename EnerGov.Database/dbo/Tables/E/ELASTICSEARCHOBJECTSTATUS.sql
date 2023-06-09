﻿CREATE TABLE [dbo].[ELASTICSEARCHOBJECTSTATUS] (
    [ELASTICSEARCHOBJECTSTATUSID] INT            NOT NULL,
    [NAME]                        NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                 NVARCHAR (255) NULL,
    CONSTRAINT [PK_ELASTICSEARCHOBJECTSTATUS_ELASTICSEARCHOBJECTSTATUSID] PRIMARY KEY CLUSTERED ([ELASTICSEARCHOBJECTSTATUSID] ASC),
    CONSTRAINT [UC_ELASTICSEARCHOBJECTSTATUS_NAME] UNIQUE NONCLUSTERED ([NAME] ASC)
);

