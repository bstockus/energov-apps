﻿CREATE TABLE [dbo].[CUSTOMFIELDTYPE] (
    [ICUSTOMFIELDTYPE] INT          NOT NULL,
    [SNAME]            VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CustomFieldTypes] PRIMARY KEY CLUSTERED ([ICUSTOMFIELDTYPE] ASC) WITH (FILLFACTOR = 90)
);

