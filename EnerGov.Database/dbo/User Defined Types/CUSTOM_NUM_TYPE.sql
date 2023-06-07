CREATE TYPE [dbo].[CUSTOM_NUM_TYPE] AS TABLE (
    [ID]              CHAR (36) NOT NULL,
    [PARENT_ID]       CHAR (36) NOT NULL,
    [MODULEID]        INT       NOT NULL,
    [CUSTOM_FIELD_ID] CHAR (36) NOT NULL,
    [INTVALUE]        INT       NULL,
    [ROWNUMBER]       INT       NOT NULL);

