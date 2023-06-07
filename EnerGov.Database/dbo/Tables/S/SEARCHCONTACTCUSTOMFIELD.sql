﻿CREATE TABLE [dbo].[SEARCHCONTACTCUSTOMFIELD] (
    [SEARCHCONTACTCUSTOMFIELDID] CHAR (36) NOT NULL,
    [SEARCHCONTACTID]            CHAR (36) NOT NULL,
    [SEARCHCUSTOMFIELDID]        CHAR (36) NOT NULL,
    CONSTRAINT [PK_SEARCHCONTACTCUSTOMFIELD] PRIMARY KEY CLUSTERED ([SEARCHCONTACTCUSTOMFIELDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_SRCH_CNTCUSTFLD] FOREIGN KEY ([SEARCHCONTACTID]) REFERENCES [dbo].[SEARCHCONTACT] ([SEARCHCONTACTID]),
    CONSTRAINT [FK_SRCH_SRCHCUSTFLD] FOREIGN KEY ([SEARCHCUSTOMFIELDID]) REFERENCES [dbo].[SEARCHCUSTOMFIELD] ([SEARCHCUSTOMFIELDID])
);
