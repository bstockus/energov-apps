﻿CREATE TABLE [dbo].[BLLICENSERAPIDRENEWAL] (
    [BLLICENSERAPIDRENEWALID] CHAR (36) NOT NULL,
    [BATCHNUMBER]             INT       NOT NULL,
    [SEQUENCENUMBER]          INT       NOT NULL,
    [BLLICENSEID]             CHAR (36) NOT NULL,
    [RENEWEDBY]               CHAR (36) NOT NULL,
    [RENEWALDATE]             DATETIME  NOT NULL,
    [RENEWALAMOUNT]           MONEY     DEFAULT ((0.00)) NOT NULL,
    [INUSE]                   BIT       DEFAULT ((0)) NOT NULL,
    [BLLICENSETYPEMODULEID]   INT       NULL,
    CONSTRAINT [PK_BLLICENSERAPIDRENEWAL] PRIMARY KEY CLUSTERED ([BLLICENSERAPIDRENEWALID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLLICENSERAPIDRENEWAL_BLLICENSETYPEMODULE] FOREIGN KEY ([BLLICENSETYPEMODULEID]) REFERENCES [dbo].[BLLICENSETYPEMODULE] ([BLLICENSETYPEMODULEID]),
    CONSTRAINT [FK_BLLICENSERAPRENEW_BLLICENSE] FOREIGN KEY ([BLLICENSEID]) REFERENCES [dbo].[BLLICENSE] ([BLLICENSEID]),
    CONSTRAINT [FK_BLLICENSERAPRENEW_USERS] FOREIGN KEY ([RENEWEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [NCIDX_BLLICENSERAPIDRENEWAL_BATCHNUMBER_RENEWALDATE_BLLICENSETYPEMODULEID]
    ON [dbo].[BLLICENSERAPIDRENEWAL]([BATCHNUMBER] ASC, [RENEWALDATE] ASC, [BLLICENSETYPEMODULEID] ASC);
