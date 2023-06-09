﻿CREATE TABLE [dbo].[AMASSETRECURRENCESETUPXREF] (
    [AMASSETRECURRENCESETUPXREFID] CHAR (36) NOT NULL,
    [AMASSETTYPEID]                CHAR (36) NOT NULL,
    [AMASSETRECURRENCESETUPID]     CHAR (36) NOT NULL,
    CONSTRAINT [PK_AMAssetRecurrenceSetUpXRef] PRIMARY KEY CLUSTERED ([AMASSETRECURRENCESETUPXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMAstRcrStUpXRf_AMAstRcrSUp] FOREIGN KEY ([AMASSETRECURRENCESETUPID]) REFERENCES [dbo].[AMASSETRECURRENCESETUP] ([AMASSETRECURRENCESETUPID]),
    CONSTRAINT [FK_AMAstRcrStUpXRf_AMAstTy] FOREIGN KEY ([AMASSETTYPEID]) REFERENCES [dbo].[AMASSETTYPE] ([AMASSETTYPEID])
);

