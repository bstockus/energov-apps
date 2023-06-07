﻿CREATE TABLE [dbo].[FOPROPERTYUSE] (
    [FOPROPERTYUSEID] CHAR (36)      NOT NULL,
    [NAME]            NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_FOPROPERTYUSE] PRIMARY KEY CLUSTERED ([FOPROPERTYUSEID] ASC)
);
