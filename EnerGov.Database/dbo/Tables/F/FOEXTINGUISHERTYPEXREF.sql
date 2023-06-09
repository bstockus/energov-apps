﻿CREATE TABLE [dbo].[FOEXTINGUISHERTYPEXREF] (
    [FOEXTINGUISHERTYPEXREFID] CHAR (36) NOT NULL,
    [FIREOCCUPANCYID]          CHAR (36) NOT NULL,
    [FOEXTINGUISHERTYPEID]     CHAR (36) NOT NULL,
    CONSTRAINT [PK_FOEXTINGUISHERTYPEXREFID] PRIMARY KEY CLUSTERED ([FOEXTINGUISHERTYPEXREFID] ASC),
    CONSTRAINT [FK_FOEXTINGUISHERTYPEXREF_FIREOCCUPANCY] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID]),
    CONSTRAINT [FK_FOEXTINGUISHERTYPEXREF_FOEXTINGUISHERTYPE] FOREIGN KEY ([FOEXTINGUISHERTYPEID]) REFERENCES [dbo].[FOEXTINGUISHERTYPE] ([FOEXTINGUISHERTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FOEXTINGUISHERTYPEXREF_FIREOCCUPANCY]
    ON [dbo].[FOEXTINGUISHERTYPEXREF]([FIREOCCUPANCYID] ASC, [FOEXTINGUISHERTYPEID] ASC);

