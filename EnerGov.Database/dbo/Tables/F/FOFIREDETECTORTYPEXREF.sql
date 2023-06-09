﻿CREATE TABLE [dbo].[FOFIREDETECTORTYPEXREF] (
    [FOFIREDETECTORYTYPEXREFID] CHAR (36) NOT NULL,
    [FIREOCCUPANCYID]           CHAR (36) NOT NULL,
    [FOFIREDETECTORTYPEID]      CHAR (36) NOT NULL,
    CONSTRAINT [PK_FOFIREDETECTORTYPEXREFID] PRIMARY KEY NONCLUSTERED ([FOFIREDETECTORYTYPEXREFID] ASC),
    CONSTRAINT [FK_FOFIREDETECTORTYPEXREF_FIREOCCUPANCY] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID]),
    CONSTRAINT [FK_FOFIREDETECTORTYPEXREF_FOFIREDETECTORTYPE] FOREIGN KEY ([FOFIREDETECTORTYPEID]) REFERENCES [dbo].[FOFIREDETECTORTYPE] ([FOFIREDETECTORTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FOFIREDETECTORTYPEXREF_FIREOCCUPANCY]
    ON [dbo].[FOFIREDETECTORTYPEXREF]([FIREOCCUPANCYID] ASC);

