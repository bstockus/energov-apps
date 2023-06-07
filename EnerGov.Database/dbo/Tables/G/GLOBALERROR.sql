﻿CREATE TABLE [dbo].[GLOBALERROR] (
    [GGLOBALERROR]      CHAR (36)      NOT NULL,
    [USERNAME]          NVARCHAR (200) NULL,
    [LOGDATE]           DATETIME       NULL,
    [EXCEPTION]         NVARCHAR (MAX) NULL,
    [SENTTOENERGOV]     DATETIME       NULL,
    [GLOBALERRORNUMBER] NVARCHAR (50)  NULL,
    CONSTRAINT [PK_GlobalError] PRIMARY KEY CLUSTERED ([GGLOBALERROR] ASC) WITH (FILLFACTOR = 80)
);
