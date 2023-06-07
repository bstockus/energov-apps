﻿CREATE TABLE [dbo].[CUSTOMFIELDMODULES] (
    [CUSTOMFIELDMODULEID] INT           NOT NULL,
    [MODULENAME]          NVARCHAR (50) NOT NULL,
    [ISHTMLDEPRICATED]    BIT           NULL,
    CONSTRAINT [PK_CustomFieldModules] PRIMARY KEY CLUSTERED ([CUSTOMFIELDMODULEID] ASC) WITH (FILLFACTOR = 90)
);

