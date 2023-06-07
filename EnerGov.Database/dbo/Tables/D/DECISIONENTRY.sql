﻿CREATE TABLE [dbo].[DECISIONENTRY] (
    [DECISIONENTRYID]         CHAR (36) NOT NULL,
    [DECISIONQUESTIONNAIREID] CHAR (36) NOT NULL,
    [ENTEREDBY]               CHAR (36) NOT NULL,
    [ENTEREDON]               DATETIME  NOT NULL,
    CONSTRAINT [PK_DecisionEntry] PRIMARY KEY CLUSTERED ([DECISIONENTRYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DecisionEntry_Quest] FOREIGN KEY ([DECISIONQUESTIONNAIREID]) REFERENCES [dbo].[DECISIONQUESTIONNAIRE] ([DECISIONQUESTIONNAIREID]),
    CONSTRAINT [FK_DecisionEntry_Users] FOREIGN KEY ([ENTEREDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);
