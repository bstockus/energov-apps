﻿CREATE TABLE [dbo].[GLOBALENTITYACCOUNTWAIVERLINK] (
    [GLOBALENTITYACCOUNTWAIVERLINKID] CHAR (36) NOT NULL,
    [GLOBALENTITYACCOUNTWAIVERID]     CHAR (36) NOT NULL,
    [FEEWAIVERLINKTYPEID]             INT       NOT NULL,
    [LINKID]                          CHAR (36) NOT NULL,
    CONSTRAINT [PK_GLOBALENTITYACCOUNTWAIVERLINK] PRIMARY KEY NONCLUSTERED ([GLOBALENTITYACCOUNTWAIVERLINKID] ASC),
    CONSTRAINT [FK_GLOBALENTITYACCOUNTWAIVERLINK_ACCOUNTWAIVER] FOREIGN KEY ([GLOBALENTITYACCOUNTWAIVERID]) REFERENCES [dbo].[GLOBALENTITYACCOUNTWAIVER] ([GLOBALENTITYACCOUNTWAIVERID]),
    CONSTRAINT [FK_GLOBALENTITYACCOUNTWAIVERLINK_FEEWAIVERLINKTYPE] FOREIGN KEY ([FEEWAIVERLINKTYPEID]) REFERENCES [dbo].[FEEWAIVERLINKTYPE] ([FEEWAIVERLINKTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_GEAWL_FEEWAIVERLINKTYPEID]
    ON [dbo].[GLOBALENTITYACCOUNTWAIVERLINK]([FEEWAIVERLINKTYPEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GEAWL_GLOBALENTITYACCOUNTWAIVERID]
    ON [dbo].[GLOBALENTITYACCOUNTWAIVERLINK]([GLOBALENTITYACCOUNTWAIVERID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GEAWL_LINKID]
    ON [dbo].[GLOBALENTITYACCOUNTWAIVERLINK]([LINKID] ASC);

