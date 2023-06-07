CREATE TYPE [dbo].[CUSTOM_BLN_TYPE] AS TABLE (
    [ID]              CHAR (36) NOT NULL,
    [PARENT_ID]       CHAR (36) NOT NULL,
    [MODULEID]        INT       NOT NULL,
    [CUSTOM_FIELD_ID] CHAR (36) NOT NULL,
    [BITVALUE]        BIT       NOT NULL,
    [ROWNUMBER]       INT       NOT NULL);

