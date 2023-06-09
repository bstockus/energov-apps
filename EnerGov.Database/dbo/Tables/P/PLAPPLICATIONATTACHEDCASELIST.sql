﻿CREATE TABLE [dbo].[PLAPPLICATIONATTACHEDCASELIST] (
    [APPLICATIONID]                 CHAR (36)     NULL,
    [APPLICATIONATTACHEDCASETYPEID] CHAR (36)     NULL,
    [ATTACHEDCASEID]                CHAR (36)     NULL,
    [APPLICATIONATTACHEDCASELISTID] CHAR (36)     CONSTRAINT [DF_PLPlanAttachedCaseList_PLPlanAttachedCaseListID] DEFAULT (newid()) NOT NULL,
    [ATTACHEDCASENUMBER]            NVARCHAR (50) NULL,
    CONSTRAINT [PK_PLPlanAttachedCaseList] PRIMARY KEY CLUSTERED ([APPLICATIONATTACHEDCASELISTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLApplicationAttachedCaseList_PLApplication] FOREIGN KEY ([APPLICATIONID]) REFERENCES [dbo].[PLAPPLICATION] ([PLAPPLICATIONID]),
    CONSTRAINT [FK_PLApplicationAttachedCaseList_PLApplicationAttachedCaseType] FOREIGN KEY ([APPLICATIONATTACHEDCASETYPEID]) REFERENCES [dbo].[PLAPPLICATIONATTACHEDCASETYPE] ([APPLICATIONATTACHEDCASETYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PLAPPLICATIONCONTACT_ATTACHEDCASEENTITY]
    ON [dbo].[PLAPPLICATIONATTACHEDCASELIST]([ATTACHEDCASEID] ASC);

