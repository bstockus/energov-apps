﻿CREATE TABLE [dbo].[FOFIREALARMTYPE] (
    [FOFIREALARMTYPEID] CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_FOFIREALARMTYPE] PRIMARY KEY CLUSTERED ([FOFIREALARMTYPEID] ASC)
);

