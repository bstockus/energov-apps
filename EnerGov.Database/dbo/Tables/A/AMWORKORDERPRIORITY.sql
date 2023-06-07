﻿CREATE TABLE [dbo].[AMWORKORDERPRIORITY] (
    [AMWORKORDERPRIORITYID] CHAR (36)     NOT NULL,
    [NAME]                  VARCHAR (50)  NOT NULL,
    [DESCRIPTION]           VARCHAR (MAX) NULL,
    CONSTRAINT [PK_AMWorkOrderPriority] PRIMARY KEY CLUSTERED ([AMWORKORDERPRIORITYID] ASC) WITH (FILLFACTOR = 90)
);

