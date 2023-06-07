CREATE TYPE [dbo].[CUSTOM_MEM_TYPE] AS TABLE (
    [ID]              CHAR (36)       NOT NULL,
    [PARENT_ID]       CHAR (36)       NOT NULL,
    [MODULEID]        INT             NOT NULL,
    [CUSTOM_FIELD_ID] CHAR (36)       NOT NULL,
    [MEMO_VALUE]      NVARCHAR (4000) NULL,
    [ROWNUMBER]       INT             NOT NULL);

