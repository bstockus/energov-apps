﻿CREATE TABLE [dbo].[BLLICENSEACTIVITY] (
    [BLLICENSEACTIVITYID]     CHAR (36)      NOT NULL,
    [BLLICENSEID]             CHAR (36)      NOT NULL,
    [BLLICENSEACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [LICENSEACTIVITYNAME]     NVARCHAR (255) NOT NULL,
    [LICENSEACTIVITYNUMBER]   NVARCHAR (255) NOT NULL,
    [LICENSEACTIVITYCOMMENTS] NVARCHAR (MAX) NOT NULL,
    [SUSERGUID]               CHAR (36)      NOT NULL,
    [BLLICENSEWFACTIONSTEPID] CHAR (36)      NULL,
    [CREATEDON]               DATETIME       NOT NULL,
    CONSTRAINT [PK_BLLicenseActivity] PRIMARY KEY CLUSTERED ([BLLICENSEACTIVITYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLLicAct_BLLic] FOREIGN KEY ([BLLICENSEID]) REFERENCES [dbo].[BLLICENSE] ([BLLICENSEID]),
    CONSTRAINT [FK_BLLicAct_BLLicActType] FOREIGN KEY ([BLLICENSEACTIVITYTYPEID]) REFERENCES [dbo].[BLLICENSEACTIVITYTYPE] ([BLLICENSEACTIVITYTYPEID]),
    CONSTRAINT [FK_BLLicAct_BLLicWFActionStep] FOREIGN KEY ([BLLICENSEWFACTIONSTEPID]) REFERENCES [dbo].[BLLICENSEWFACTIONSTEP] ([BLLICENSEWFACTIONSTEPID]),
    CONSTRAINT [FK_BLLicenseActivity_Users] FOREIGN KEY ([SUSERGUID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[BLLICENSEACTIVITY]([BLLICENSEACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[BLLICENSEACTIVITY]([BLLICENSEID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT3]
    ON [dbo].[BLLICENSEACTIVITY]([BLLICENSEWFACTIONSTEPID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICENSEACTIVITY_BLLICENSEID]
    ON [dbo].[BLLICENSEACTIVITY]([BLLICENSEID] ASC);

