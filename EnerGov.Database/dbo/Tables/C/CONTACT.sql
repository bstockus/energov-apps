﻿CREATE TABLE [dbo].[CONTACT] (
    [CONTACTID]     CHAR (36)       NOT NULL,
    [FIRSTNAME]     NVARCHAR (50)   NOT NULL,
    [LASTNAME]      NVARCHAR (50)   NOT NULL,
    [BUSINESSPHONE] NVARCHAR (50)   NULL,
    [EMAIL]         NVARCHAR (80)   NULL,
    [CONTACTTYPEID] CHAR (36)       NULL,
    [PHOTO]         VARBINARY (MAX) NULL,
    [TITLE]         NVARCHAR (50)   NULL,
    [SALUTATIONID]  CHAR (36)       NULL,
    [MIDDLENAME]    NVARCHAR (50)   NULL,
    [MOBILEPHONE]   NVARCHAR (50)   NULL,
    [HOMEPHONE]     NVARCHAR (50)   NULL,
    [FAX]           NVARCHAR (50)   NULL,
    [LASTCHANGEDBY] CHAR (36)       NULL,
    [LASTCHANGEDON] DATETIME        NULL,
    [ROWVERSION]    INT             CONSTRAINT [DF_Contact_RowVersion] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED ([CONTACTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contact_ContactType] FOREIGN KEY ([CONTACTTYPEID]) REFERENCES [dbo].[CONTACTTYPE] ([CONTACTTYPEID]),
    CONSTRAINT [FK_Contact_Salutation] FOREIGN KEY ([SALUTATIONID]) REFERENCES [dbo].[SALUTATION] ([SALUTATIONID]),
    CONSTRAINT [FK_Contact_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

