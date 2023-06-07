﻿CREATE TABLE [dbo].[FOINSPECTIONTYPEXREF] (
    [FOINSPECTIONTYPEXREFID] CHAR (36) NOT NULL,
    [FIREOCCUPANCYID]        CHAR (36) NOT NULL,
    [IMINSPECTIONTYPEID]     CHAR (36) NOT NULL,
    [STARTDATE]              DATETIME  NOT NULL,
    [LASTCHANGEDON]          DATETIME  NOT NULL,
    [LASTCHANGEDBY]          CHAR (36) NOT NULL,
    CONSTRAINT [PK_FOINSPECTIONTYPEXREF] PRIMARY KEY CLUSTERED ([FOINSPECTIONTYPEXREFID] ASC),
    CONSTRAINT [FK_FOINSPECTIONTYPEXREF_FIREOCCUPANCY] FOREIGN KEY ([FIREOCCUPANCYID]) REFERENCES [dbo].[FIREOCCUPANCY] ([ID]),
    CONSTRAINT [FK_FOINSPECTIONTYPEXREF_IMINSPECTIONTYPE] FOREIGN KEY ([IMINSPECTIONTYPEID]) REFERENCES [dbo].[IMINSPECTIONTYPE] ([IMINSPECTIONTYPEID]),
    CONSTRAINT [FK_FOINSPECTIONTYPEXREF_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FOINSPECTIONTYPEXREF_IMINSPECTIONTYPEID]
    ON [dbo].[FOINSPECTIONTYPEXREF]([IMINSPECTIONTYPEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FOINSPECTIONTYPEXREF_FIREOCCUPANCYID]
    ON [dbo].[FOINSPECTIONTYPEXREF]([FIREOCCUPANCYID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FOINSPECTIONTYPEXREF_LASTCHANGEDBY]
    ON [dbo].[FOINSPECTIONTYPEXREF]([LASTCHANGEDBY] ASC);

