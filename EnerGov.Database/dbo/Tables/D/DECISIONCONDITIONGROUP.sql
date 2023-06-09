﻿CREATE TABLE [dbo].[DECISIONCONDITIONGROUP] (
    [DECISIONCONDITIONGROUPID] CHAR (36) NOT NULL,
    [DECISIONPAGEID]           CHAR (36) NOT NULL,
    [ISORBASED]                BIT       NOT NULL,
    [GROUPNUMBER]              INT       NOT NULL,
    CONSTRAINT [PK_DecisionConditionGroup] PRIMARY KEY CLUSTERED ([DECISIONCONDITIONGROUPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DecisionGroup_DecisionPage] FOREIGN KEY ([DECISIONPAGEID]) REFERENCES [dbo].[DECISIONPAGE] ([DECISIONPAGEID])
);

