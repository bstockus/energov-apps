﻿CREATE TABLE [dbo].[AMRESOURCESKILLRESOURCEXREF] (
    [AMRESOURCESKILLRESOURCEXREFID] CHAR (36) NOT NULL,
    [AMRESOURCEID]                  CHAR (36) NOT NULL,
    [AMRESOURCESKILLID]             CHAR (36) NOT NULL,
    CONSTRAINT [PK_AMResourceSkillResourceXRef] PRIMARY KEY CLUSTERED ([AMRESOURCESKILLRESOURCEXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ResourceSkillXRef] FOREIGN KEY ([AMRESOURCESKILLID]) REFERENCES [dbo].[AMRESOURCESKILL] ([AMRESOURCESKILLID]),
    CONSTRAINT [FK_ResourceSkillXRefResource] FOREIGN KEY ([AMRESOURCEID]) REFERENCES [dbo].[AMRESOURCE] ([AMRESOURCEID])
);
