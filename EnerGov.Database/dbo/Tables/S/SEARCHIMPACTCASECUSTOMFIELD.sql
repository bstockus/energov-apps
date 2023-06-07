﻿CREATE TABLE [dbo].[SEARCHIMPACTCASECUSTOMFIELD] (
    [SEARCHIMPACTCASECUSTOMFIELDID] CHAR (36) NOT NULL,
    [SEARCHIMPACTCASEID]            CHAR (36) NOT NULL,
    [SEARCHCUSTOMFIELDID]           CHAR (36) NOT NULL,
    CONSTRAINT [PK_SEARCHIPCASECUSTOMFIELD] PRIMARY KEY CLUSTERED ([SEARCHIMPACTCASECUSTOMFIELDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_SEARCHIPCASE_SEARCHIP] FOREIGN KEY ([SEARCHIMPACTCASEID]) REFERENCES [dbo].[SEARCHIMPACTCASE] ([SEARCHIMPACTCASEID]),
    CONSTRAINT [FK_SEARCHIPCF_SEARCHCF] FOREIGN KEY ([SEARCHCUSTOMFIELDID]) REFERENCES [dbo].[SEARCHCUSTOMFIELD] ([SEARCHCUSTOMFIELDID])
);

