﻿CREATE TABLE [dbo].[MERGECONTACTARCHIVE] (
    [GLOBALENTITYID]       CHAR (36)       NOT NULL,
    [PARENTGLOBALENTITYID] CHAR (36)       NULL,
    [GLOBALENTITYNAME]     NVARCHAR (100)  NOT NULL,
    [ISCOMPANY]            BIT             NOT NULL,
    [ISCONTACT]            BIT             NOT NULL,
    [MANUFACTURER]         BIT             NOT NULL,
    [VENDOR]               BIT             NOT NULL,
    [SHIPPER]              BIT             NOT NULL,
    [EMAIL]                NVARCHAR (250)  NULL,
    [WEBSITE]              NVARCHAR (100)  NULL,
    [BUSINESSPHONE]        NVARCHAR (50)   NULL,
    [HOMEPHONE]            NVARCHAR (50)   NULL,
    [MOBILEPHONE]          NVARCHAR (50)   NULL,
    [OTHERPHONE]           NVARCHAR (50)   NULL,
    [FAX]                  NVARCHAR (50)   NULL,
    [IMAGE]                VARBINARY (MAX) NULL,
    [FIRSTNAME]            NVARCHAR (50)   NOT NULL,
    [LASTNAME]             NVARCHAR (50)   NOT NULL,
    [MIDDLENAME]           NVARCHAR (50)   NULL,
    [TITLE]                NVARCHAR (50)   NULL,
    [LASTCHANGEDON]        DATETIME        NULL,
    [LASTCHANGEDBY]        CHAR (36)       NULL,
    [ROWVERSION]           INT             NOT NULL,
    [IMPNAMEKEY]           NVARCHAR (300)  NULL,
    [IMPADDKEY]            NVARCHAR (300)  NULL,
    [NAME1]                NVARCHAR (150)  NULL,
    [NAME2]                NVARCHAR (150)  NULL,
    [CONTACTID]            NVARCHAR (50)   NULL,
    [PREFCOMM]             INT             NULL,
    [ISACTIVE]             BIT             DEFAULT ((1)) NOT NULL,
    [OTHEREMAIL]           NVARCHAR (250)  NULL
);

