﻿CREATE TABLE [dbo].[ILLICENSEACTIVITY] (
    [ILLICENSEACTIVITYID]     CHAR (36)      NOT NULL,
    [ILLICENSEID]             CHAR (36)      NOT NULL,
    [ILLICENSEACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [ACTIVITYNAME]            NVARCHAR (255) NOT NULL,
    [ACTIVITYNUMBER]          NVARCHAR (255) NOT NULL,
    [ACTIVITYCOMMENTS]        VARCHAR (MAX)  NULL,
    [SUSERID]                 CHAR (36)      NOT NULL,
    [ILLICENSEWFACTIONSTEPID] CHAR (36)      NULL,
    [CREATEDON]               DATETIME       NOT NULL,
    CONSTRAINT [PK_ILLICENSEACTIVITY] PRIMARY KEY CLUSTERED ([ILLICENSEACTIVITYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ILLICACT_ILLICACTTYPE] FOREIGN KEY ([ILLICENSEACTIVITYTYPEID]) REFERENCES [dbo].[ILLICENSEACTIVITYTYPE] ([ILLICENSEACTIVITYTYPEID]),
    CONSTRAINT [FK_ILLICACT_ILLICWFACTSTEP] FOREIGN KEY ([ILLICENSEWFACTIONSTEPID]) REFERENCES [dbo].[ILLICENSEWFACTIONSTEP] ([ILLICENSEWFACTIONSTEPID]),
    CONSTRAINT [FK_ILLICENSEACTIVITY_ILLICENSE] FOREIGN KEY ([ILLICENSEID]) REFERENCES [dbo].[ILLICENSE] ([ILLICENSEID]),
    CONSTRAINT [FK_ILLICENSEACTIVITY_USERS] FOREIGN KEY ([SUSERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[ILLICENSEACTIVITY]([ILLICENSEACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[ILLICENSEACTIVITY]([ILLICENSEID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IMPORT3]
    ON [dbo].[ILLICENSEACTIVITY]([ILLICENSEWFACTIONSTEPID] ASC) WITH (FILLFACTOR = 90);
