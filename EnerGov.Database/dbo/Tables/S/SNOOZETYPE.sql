﻿CREATE TABLE [dbo].[SNOOZETYPE] (
    [SNOOZETYPEID] INT           NOT NULL,
    [NAME]         NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_SnoozeType] PRIMARY KEY CLUSTERED ([SNOOZETYPEID] ASC)
);
