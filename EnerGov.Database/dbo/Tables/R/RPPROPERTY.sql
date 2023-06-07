﻿CREATE TABLE [dbo].[RPPROPERTY] (
    [RPPROPERTYID]        CHAR (36)      NOT NULL,
    [RPLANDLORDLICENSEID] CHAR (36)      NOT NULL,
    [APPLICATIONDATE]     DATETIME       NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [EXPIRATIONDATE]      DATETIME       NULL,
    [ISSUEDATE]           DATETIME       NULL,
    [LASTINSPECTIONDATE]  DATETIME       NULL,
    [NUMBEROFUNITS]       INT            NULL,
    [RPPROPERTYTYPEID]    CHAR (36)      NOT NULL,
    [RPPROPERTYSTATUSID]  CHAR (36)      NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [ROWVERSION]          INT            NOT NULL,
    [LASTCHANGEDON]       DATETIME       NULL,
    [DISTRICTID]          CHAR (36)      NULL,
    [PROPERTYNUMBER]      NVARCHAR (50)  NULL,
    CONSTRAINT [PK_RPPROPERTY] PRIMARY KEY NONCLUSTERED ([RPPROPERTYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PROPERTY_DISTRICT] FOREIGN KEY ([DISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_RPPROPERTY_RPLLLIC] FOREIGN KEY ([RPLANDLORDLICENSEID]) REFERENCES [dbo].[RPLANDLORDLICENSE] ([RPLANDLORDLICENSEID]),
    CONSTRAINT [FK_RPPROPERTY_STATUS] FOREIGN KEY ([RPPROPERTYSTATUSID]) REFERENCES [dbo].[RPPROPERTYSTATUS] ([RPPROPERTYSTATUSID]),
    CONSTRAINT [FK_RPPROPERTY_TYPE] FOREIGN KEY ([RPPROPERTYTYPEID]) REFERENCES [dbo].[RPPROPERTYTYPE] ([RPPROPERTYTYPEID]),
    CONSTRAINT [FK_RPPROPERTY_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

