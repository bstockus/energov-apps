CREATE TYPE [dbo].[CUSTOM_STR_TYPE] AS TABLE (
    [ID]              CHAR (36)     NOT NULL,
    [PARENT_ID]       CHAR (36)     NOT NULL,
    [MODULEID]        INT           NOT NULL,
    [CUSTOM_FIELD_ID] CHAR (36)     NOT NULL,
    [STRINGVALUE]     NVARCHAR (50) NULL,
    [ROWNUMBER]       INT           NOT NULL);

