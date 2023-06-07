﻿CREATE TABLE [dbo].[RPLANDLORDLICENSEACTIVITY] (
    [RPLANDLORDLICENSEACTIVITYID] CHAR (36)      NOT NULL,
    [RPLANDLORDLICENSEID]         CHAR (36)      NOT NULL,
    [RPPROPERTYACTIVITYTYPEID]    CHAR (36)      NOT NULL,
    [ACTIVITYNAME]                NVARCHAR (255) NOT NULL,
    [ACTIVITYNUMBER]              NVARCHAR (255) NOT NULL,
    [ACTIVITYCOMMENTS]            NVARCHAR (MAX) NULL,
    [USERID]                      CHAR (36)      NOT NULL,
    [CREATEDON]                   DATETIME       NOT NULL,
    CONSTRAINT [PK_RPLANDLORDLICENSEACTIVITY] PRIMARY KEY NONCLUSTERED ([RPLANDLORDLICENSEACTIVITYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPLLACT_RPPROPACTTYPE] FOREIGN KEY ([RPPROPERTYACTIVITYTYPEID]) REFERENCES [dbo].[RPPROPERTYACTIVITYTYPE] ([RPPROPERTYACTIVITYTYPEID]),
    CONSTRAINT [FK_RPLLLICACT_USERS] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_RPLLLICACTIVITY_LLLICENSE] FOREIGN KEY ([RPLANDLORDLICENSEID]) REFERENCES [dbo].[RPLANDLORDLICENSE] ([RPLANDLORDLICENSEID])
);

