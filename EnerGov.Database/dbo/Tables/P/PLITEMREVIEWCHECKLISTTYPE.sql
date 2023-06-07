﻿CREATE TABLE [dbo].[PLITEMREVIEWCHECKLISTTYPE] (
    [PLITEMREVIEWCHECKLISTTYPEID] CHAR (36)      NOT NULL,
    [NAME]                        NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                 NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_PLItemReviewCheckListType] PRIMARY KEY CLUSTERED ([PLITEMREVIEWCHECKLISTTYPEID] ASC) WITH (FILLFACTOR = 90)
);
