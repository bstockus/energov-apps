﻿CREATE TABLE [dbo].[SESSIONS] (
    [SESSIONID]     CHAR (36)      NOT NULL,
    [ACTIVETIME]    DATETIME       NOT NULL,
    [LICENSE_SUITE] NVARCHAR (MAX) NULL,
    [SUSERGUID]     NVARCHAR (36)  NULL,
    CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED ([SESSIONID] ASC) WITH (FILLFACTOR = 80)
);

