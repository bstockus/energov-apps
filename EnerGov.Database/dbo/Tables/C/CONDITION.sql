﻿CREATE TABLE [dbo].[CONDITION] (
    [CONDITIONID]         CHAR (36)      NOT NULL,
    [CONDITIONCATEGORYID] CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (255) NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NOT NULL,
    [COMMENTS]            NVARCHAR (MAX) NULL,
    [ISENABLE]            BIT            NOT NULL,
    [ORIGINOBJECT]        NVARCHAR (255) NOT NULL,
    [ORIGINOBJECTID]      VARCHAR (50)   NOT NULL,
    [ORIGINOBJECTNAME]    NVARCHAR (255) NULL,
    [ORDER]               VARCHAR (5)    NULL,
    CONSTRAINT [PK_conCondition] PRIMARY KEY CLUSTERED ([CONDITIONID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Condition_ConditionCategory] FOREIGN KEY ([CONDITIONCATEGORYID]) REFERENCES [dbo].[CONDITIONCATEGORY] ([CONDITIONCATEGORYID])
);

