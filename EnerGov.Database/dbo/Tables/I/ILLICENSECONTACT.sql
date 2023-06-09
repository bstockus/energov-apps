﻿CREATE TABLE [dbo].[ILLICENSECONTACT] (
    [ILLICENSECONTACTID] CHAR (36) NOT NULL,
    [ILLICENSEID]        CHAR (36) NOT NULL,
    [GLOBALENTITYID]     CHAR (36) NOT NULL,
    [BLCONTACTTYPEID]    CHAR (36) NOT NULL,
    [ISBILLING]          BIT       NOT NULL,
    CONSTRAINT [PK_ILLICENSECONTACT] PRIMARY KEY CLUSTERED ([ILLICENSECONTACTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ILLICCONTACT_BLCONTYPE] FOREIGN KEY ([BLCONTACTTYPEID]) REFERENCES [dbo].[BLCONTACTTYPE] ([BLCONTACTTYPEID]),
    CONSTRAINT [FK_ILLICCONTACT_GLOBALENT] FOREIGN KEY ([GLOBALENTITYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID]),
    CONSTRAINT [FK_ILLICCONTACT_ILLIC] FOREIGN KEY ([ILLICENSEID]) REFERENCES [dbo].[ILLICENSE] ([ILLICENSEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ILLICENSECONTACT_LIC]
    ON [dbo].[ILLICENSECONTACT]([ILLICENSEID] ASC, [GLOBALENTITYID] ASC, [BLCONTACTTYPEID] ASC, [ISBILLING] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [NCIDX_ILLICENSECONTACT_GLOBALENTITYID]
    ON [dbo].[ILLICENSECONTACT]([GLOBALENTITYID] ASC) WITH (FILLFACTOR = 90, PAD_INDEX = ON);

