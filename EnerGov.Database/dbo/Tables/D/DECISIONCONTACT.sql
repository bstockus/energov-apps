﻿CREATE TABLE [dbo].[DECISIONCONTACT] (
    [DECISIONCONTACTID] CHAR (36)     NOT NULL,
    [REQUIRED]          BIT           NULL,
    [INSTRUCTIONS]      VARCHAR (MAX) NULL,
    CONSTRAINT [PK_DECISIONCONTACT] PRIMARY KEY CLUSTERED ([DECISIONCONTACTID] ASC) WITH (FILLFACTOR = 90)
);

