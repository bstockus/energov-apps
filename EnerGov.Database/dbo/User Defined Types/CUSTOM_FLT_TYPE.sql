﻿CREATE TYPE [dbo].[CUSTOM_FLT_TYPE] AS TABLE (
    [ID]              CHAR (36)  NOT NULL,
    [PARENT_ID]       CHAR (36)  NOT NULL,
    [MODULEID]        INT        NOT NULL,
    [CUSTOM_FIELD_ID] CHAR (36)  NOT NULL,
    [FLOATVALUE]      FLOAT (53) NULL,
    [ROWNUMBER]       INT        NOT NULL);

