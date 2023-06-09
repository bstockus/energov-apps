﻿CREATE TABLE [dbo].[SEARCHRENTALPROP] (
    [SEARCHRENTALPROPID]           CHAR (36)      NOT NULL,
    [CRITERIANAME]                 NVARCHAR (100) NOT NULL,
    [CRITERIAUSERID]               CHAR (36)      NOT NULL,
    [SHARED]                       BIT            DEFAULT ((0)) NOT NULL,
    [LICENSEHOLDERNAME]            NVARCHAR (100) NULL,
    [LANDLORDDISTRICTID]           CHAR (36)      NULL,
    [RPLANDLORDLICENSETYPEID]      CHAR (36)      NULL,
    [RPLANDLORDLICENSESTATUSID]    CHAR (36)      NULL,
    [TIN]                          NVARCHAR (50)  NULL,
    [TAXID]                        NVARCHAR (50)  NULL,
    [LANDLORDAPPLICATIONDATEFROM]  DATETIME       NULL,
    [LANDLORDAPPLICATIONDATETO]    DATETIME       NULL,
    [LANDLORDISSUEDATEFROM]        DATETIME       NULL,
    [LANDLORDISSUEDATETO]          DATETIME       NULL,
    [RENTALDISTRICTID]             CHAR (36)      NULL,
    [RPPROPERTYTYPEID]             CHAR (36)      NULL,
    [RPPROPERTYSTATUSID]           CHAR (36)      NULL,
    [RENTALAPPLICATIONDATEFROM]    DATETIME       NULL,
    [RENTALAPPLICATIONDATETO]      DATETIME       NULL,
    [RENTALISSUEDATEFROM]          DATETIME       NULL,
    [RENTALISSUEDATETO]            DATETIME       NULL,
    [RENTALEXPIRATIONDATEFROM]     DATETIME       NULL,
    [RENTALEXPIRATIONDATETO]       DATETIME       NULL,
    [RENTALLASTINSPECTIONDATEFROM] DATETIME       NULL,
    [RENTALLASTINSPECTIONDATETO]   DATETIME       NULL,
    [RENTALNUMBEROFUNITS]          INT            NULL,
    [PREDIRECTION]                 NVARCHAR (30)  NULL,
    [STREETNUMBER]                 NVARCHAR (100) NULL,
    [POSTDIRECTION]                NVARCHAR (30)  NULL,
    [STREETNAME]                   NVARCHAR (100) NULL,
    [APARTMENT]                    NVARCHAR (100) NULL,
    [STREETTYPE]                   NVARCHAR (50)  NULL,
    [CITY]                         NVARCHAR (50)  NULL,
    [STATE]                        NVARCHAR (50)  NULL,
    [ZIP]                          NVARCHAR (50)  NULL,
    [UNITORSUITE]                  NVARCHAR (20)  NULL,
    [PROVINCE]                     NVARCHAR (50)  NULL,
    [RURALROUTE]                   NVARCHAR (50)  NULL,
    [STATION]                      NVARCHAR (50)  NULL,
    [COMPSITE]                     NVARCHAR (50)  NULL,
    [POBOX]                        NVARCHAR (50)  NULL,
    [ATTN]                         NVARCHAR (50)  NULL,
    [MAILINGADDRESSCOUNTRYTYPEID]  INT            NOT NULL,
    [ADDRESSTYPE]                  NVARCHAR (50)  NULL,
    [PARCELNUMBER]                 NVARCHAR (50)  NULL,
    [MAINADDRESS]                  BIT            DEFAULT ((0)) NOT NULL,
    [MAINPARCEL]                   BIT            DEFAULT ((0)) NOT NULL,
    [LANDLORDADDRESS]              BIT            DEFAULT ((1)) NOT NULL,
    [RENTALADDRESS]                BIT            DEFAULT ((0)) NOT NULL,
    [LANDLORDCONTACT]              BIT            DEFAULT ((1)) NOT NULL,
    [RENTALCONTACT]                BIT            DEFAULT ((0)) NOT NULL,
    [LANDLORDCUSTOMFIELD]          BIT            DEFAULT ((1)) NOT NULL,
    [RENTALCUSTOMFIELD]            BIT            DEFAULT ((0)) NOT NULL,
    [MAINRENTALTYPE]               BIT            DEFAULT ((0)) NOT NULL,
    [MAINLANDLORDTYPE]             BIT            DEFAULT ((0)) NOT NULL,
    [CONTACTFIRSTNAME]             NVARCHAR (50)  NULL,
    [CONTACTMIDDLENAME]            NVARCHAR (50)  NULL,
    [CONTACTLASTNAME]              NVARCHAR (50)  NULL,
    [CONTACTCOMPANYNAME]           NVARCHAR (100) NULL,
    [CONTACTEMAIL]                 NVARCHAR (250) NULL,
    [CONTACTPHONENUMBER]           NVARCHAR (50)  NULL,
    [CONTACTWEBSITE]               NVARCHAR (250) NULL,
    [RPCONTACTTYPEID]              CHAR (36)      NULL,
    [LANDLORDNUMBER]               NVARCHAR (50)  NULL,
    [PROPERTYNUMBER]               NVARCHAR (50)  NULL,
    [LANDLORDBALANCEDUEFROM]       MONEY          NULL,
    [LANDLORDBALANCEDUETO]         MONEY          NULL,
    [RENTALBALANCEDUEFROM]         MONEY          NULL,
    [RENTALBALANCEDUETO]           MONEY          NULL,
    [LANDLORDDESCRIPTION]          NVARCHAR (MAX) NULL,
    [RENTALDESCRIPTION]            NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_SEARCHRENTALPROP] PRIMARY KEY CLUSTERED ([SEARCHRENTALPROPID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPS_LDistrict] FOREIGN KEY ([LANDLORDDISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_RPS_LSTATUS] FOREIGN KEY ([RPLANDLORDLICENSESTATUSID]) REFERENCES [dbo].[RPLANDLORDLICENSESTATUS] ([RPLANDLORDLICENSESTATUSID]),
    CONSTRAINT [FK_RPS_LTYPE] FOREIGN KEY ([RPLANDLORDLICENSETYPEID]) REFERENCES [dbo].[RPLANDLORDLICENSETYPE] ([RPLANDLORDLICENSETYPEID]),
    CONSTRAINT [FK_RPS_MAILADDRCOUNTRYTYPE] FOREIGN KEY ([MAILINGADDRESSCOUNTRYTYPEID]) REFERENCES [dbo].[MAILINGADDRESSCOUNTRYTYPE] ([MAILINGADDRESSCOUNTRYTYPEID]),
    CONSTRAINT [FK_RPS_PDistrict] FOREIGN KEY ([RENTALDISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_RPS_PSTATUS] FOREIGN KEY ([RPPROPERTYSTATUSID]) REFERENCES [dbo].[RPPROPERTYSTATUS] ([RPPROPERTYSTATUSID]),
    CONSTRAINT [FK_RPS_PType] FOREIGN KEY ([RPPROPERTYTYPEID]) REFERENCES [dbo].[RPPROPERTYTYPE] ([RPPROPERTYTYPEID]),
    CONSTRAINT [FK_RPS_RPCONTACTTYPE] FOREIGN KEY ([RPCONTACTTYPEID]) REFERENCES [dbo].[RPCONTACTTYPE] ([RPCONTACTTYPEID])
);

