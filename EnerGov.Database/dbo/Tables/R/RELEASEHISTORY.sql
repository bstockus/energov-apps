﻿CREATE TABLE [dbo].[RELEASEHISTORY] (
    [RELEASEHISTORYID] CHAR (36)     NOT NULL,
    [VERSIONCHANGEDTO] VARCHAR (100) NULL,
    [CHANGEDATE]       DATETIME      NULL,
    [SHORTDESCRIPTION] VARCHAR (100) NULL,
    [LONGDESCRIPTION]  VARCHAR (500) NULL,
    CONSTRAINT [PK_RELEASEHISTORY] PRIMARY KEY CLUSTERED ([RELEASEHISTORYID] ASC) WITH (FILLFACTOR = 90)
);
