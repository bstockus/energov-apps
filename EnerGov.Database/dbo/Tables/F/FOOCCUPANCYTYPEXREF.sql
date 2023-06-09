﻿CREATE TABLE [dbo].[FOOCCUPANCYTYPEXREF] (
    [FOOCCUPANCYTYPEXREFID] CHAR (36) NOT NULL,
    [FIREOCCUPANCYID]       CHAR (36) NOT NULL,
    [FOOCCUPANCYTYPEID]     CHAR (36) NOT NULL,
    CONSTRAINT [PK_FOOCCUPANCYTYPEIDXREFID] PRIMARY KEY NONCLUSTERED ([FOOCCUPANCYTYPEXREFID] ASC),
    CONSTRAINT [FK_FIREOCCUPANCYOCCUPANCYTYPEXREF_FIREOCCUPANCY] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID]),
    CONSTRAINT [FK_FIREOCCUPANCYOCCUPANCYTYPEXREF_FOOCCUPANCYTYPE] FOREIGN KEY ([FOOCCUPANCYTYPEID]) REFERENCES [dbo].[FOOCCUPANCYTYPE] ([FOOCCUPANCYTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FOOCCUPANCYTYPEXREF_FIREOCCUPANCY]
    ON [dbo].[FOOCCUPANCYTYPEXREF]([FIREOCCUPANCYID] ASC);

