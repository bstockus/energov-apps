﻿CREATE TABLE [dbo].[IMINSPECTIONSCHEDULETYPE] (
    [IMINSPECTIONSCHEDULETYPEID] CHAR (36)     NOT NULL,
    [NAME]                       NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_INSPECTSCHDTYPEID] PRIMARY KEY CLUSTERED ([IMINSPECTIONSCHEDULETYPEID] ASC) WITH (FILLFACTOR = 90)
);

