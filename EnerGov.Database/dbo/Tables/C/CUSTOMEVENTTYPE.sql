﻿CREATE TABLE [dbo].[CUSTOMEVENTTYPE] (
    [CUSTOMEVENTTYPEID]   INT             IDENTITY (1, 1) NOT NULL,
    [TYPENAME]            NVARCHAR (200)  NOT NULL,
    [STOREDPROCEDURENAME] NVARCHAR (1000) NOT NULL,
    [ACTIVE]              BIT             CONSTRAINT [DF_CUSTOMEVENTTYPE_ACTIVE] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CUSTOMEVENTTYPE] PRIMARY KEY CLUSTERED ([CUSTOMEVENTTYPEID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CUSTOMEVENTTYPE_TYPENAME]
    ON [dbo].[CUSTOMEVENTTYPE]([TYPENAME] ASC);
