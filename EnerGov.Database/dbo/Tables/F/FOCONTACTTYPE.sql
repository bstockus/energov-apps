﻿CREATE TABLE [dbo].[FOCONTACTTYPE] (
    [FOCONTACTTYPEID]       CHAR (36)      NOT NULL,
    [NAME]                  NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [FOSYSTEMCONTACTTYPEID] INT            NOT NULL,
    CONSTRAINT [PK_FOCONTACTTYPE] PRIMARY KEY CLUSTERED ([FOCONTACTTYPEID] ASC),
    CONSTRAINT [FK_FOCONTACTTYPE_FOSYSTEMCONTACTTYPE] FOREIGN KEY ([FOSYSTEMCONTACTTYPEID]) REFERENCES [dbo].[FOSYSTEMCONTACTTYPE] ([FOSYSTEMCONTACTTYPEID])
);

