﻿CREATE TABLE [dbo].[INADJUSTMENTTYPE] (
    [INADJUSTMENTTYPEID] CHAR (36)      NOT NULL,
    [NAME]               NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX) NULL,
    [SYSTEMDEFINED]      BIT            NOT NULL,
    [ALLOWPOSITIVE]      BIT            NULL,
    [ALLOWNEGATIVE]      BIT            NULL,
    CONSTRAINT [PK_INAdjustmentType] PRIMARY KEY CLUSTERED ([INADJUSTMENTTYPEID] ASC) WITH (FILLFACTOR = 90)
);

