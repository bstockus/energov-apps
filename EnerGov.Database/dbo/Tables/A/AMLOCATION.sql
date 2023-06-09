﻿CREATE TABLE [dbo].[AMLOCATION] (
    [AMLOCATIONID] CHAR (36)        NOT NULL,
    [NAME]         NVARCHAR (50)    NOT NULL,
    [DESCRIPTION]  NVARCHAR (MAX)   NULL,
    [GISX]         NUMERIC (29, 15) NULL,
    [GISY]         NUMERIC (29, 15) NULL,
    CONSTRAINT [PK_AMLocation] PRIMARY KEY CLUSTERED ([AMLOCATIONID] ASC) WITH (FILLFACTOR = 90)
);

