﻿CREATE TABLE [dbo].[GLOBALALLOWEDACTIVITY] (
    [GLOBALALLOWEDACTIVITYID] CHAR (36) NOT NULL,
    [GLOBALTYPEID]            CHAR (36) NOT NULL,
    [GLOBALACTIVITYTYPEID]    CHAR (36) NOT NULL,
    CONSTRAINT [PK_GlobalAllowedActivity] PRIMARY KEY CLUSTERED ([GLOBALALLOWEDACTIVITYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GlobalAllowedActivity_GlobalActivityType] FOREIGN KEY ([GLOBALACTIVITYTYPEID]) REFERENCES [dbo].[GLOBALACTIVITYTYPE] ([GLOBALACTIVITYTYPEID])
);

