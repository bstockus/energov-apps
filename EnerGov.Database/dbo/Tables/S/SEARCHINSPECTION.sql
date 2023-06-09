﻿CREATE TABLE [dbo].[SEARCHINSPECTION] (
    [SEARCHINSPECTIONID]          CHAR (36)      NOT NULL,
    [INSPECTIONTYPE]              CHAR (36)      NULL,
    [INSPECTIONSTATUS]            CHAR (36)      NULL,
    [INSPECTIONNUMBER]            NVARCHAR (50)  NULL,
    [SCHEDULEDDATE]               DATETIME       NULL,
    [PRIMARYINSPECTOR]            CHAR (36)      NULL,
    [ISCOMPLETED]                 BIT            NULL,
    [ISSHARED]                    BIT            NOT NULL,
    [USERID]                      CHAR (36)      NOT NULL,
    [CRITERIANAME]                NVARCHAR (50)  NOT NULL,
    [SEARCHCOLUMNSLIST]           VARCHAR (MAX)  NULL,
    [STREETNUMBER]                NVARCHAR (100) NULL,
    [PREDIRECTION]                NVARCHAR (30)  NULL,
    [STREETNAME]                  NVARCHAR (100) NULL,
    [POSTDIRECTION]               NVARCHAR (30)  NULL,
    [APARTMENT]                   NVARCHAR (100) NULL,
    [CITY]                        NVARCHAR (50)  NULL,
    [ZONEID]                      CHAR (36)      NULL,
    [STATE]                       NVARCHAR (50)  NULL,
    [ZIP]                         NVARCHAR (50)  NULL,
    [PARCELNUMBER]                NVARCHAR (50)  NULL,
    [REQUESTTIMEFROM]             DATETIME       NULL,
    [REQUESTTIMETO]               DATETIME       NULL,
    [SCHEDULEDTIMEFROM]           DATETIME       NULL,
    [SCHEDULEDTIMETO]             DATETIME       NULL,
    [ACTUALTIMEFROM]              DATETIME       NULL,
    [ACTUALTIMETO]                DATETIME       NULL,
    [ISPRIMARYINSPECTOR]          BIT            DEFAULT ((1)) NOT NULL,
    [MAINADDRESS]                 BIT            DEFAULT ((1)) NOT NULL,
    [MAINPARCEL]                  BIT            DEFAULT ((1)) NOT NULL,
    [ADDRESSTYPE]                 NVARCHAR (50)  NULL,
    [INSPECTIONLINKID]            INT            NULL,
    [LINKNUMBER]                  NVARCHAR (255) NULL,
    [SCHEDULEDDATEFROMFILED]      DATETIME       NULL,
    [SCHEDULEDDATETOFILED]        DATETIME       NULL,
    [REQUESTDATEFROMFILED]        DATETIME       NULL,
    [REQUESTDATETOFILED]          DATETIME       NULL,
    [ACTUALDATEFROMFILED]         DATETIME       NULL,
    [ACTUALDATETOFILED]           DATETIME       NULL,
    [LINKID]                      CHAR (36)      NULL,
    [STREETTYPE]                  NVARCHAR (50)  NULL,
    [UNITORSUITE]                 NVARCHAR (20)  NULL,
    [PROVINCE]                    NVARCHAR (50)  NULL,
    [RURALROUTE]                  NVARCHAR (50)  NULL,
    [STATION]                     NVARCHAR (50)  NULL,
    [COMPSITE]                    NVARCHAR (50)  NULL,
    [POBOX]                       NVARCHAR (50)  NULL,
    [ATTN]                        NVARCHAR (50)  NULL,
    [MAILINGADDRESSCOUNTRYTYPEID] INT            DEFAULT ((0)) NOT NULL,
    [BALANCEDUEFROM]              MONEY          NULL,
    [BALANCEDUETO]                MONEY          NULL,
    [CONTACTFIRSTNAME]            NVARCHAR (100) NULL,
    [CONTACTMIDDLENAME]           NVARCHAR (100) NULL,
    [CONTACTLASTNAME]             NVARCHAR (100) NULL,
    [CONTACTCOMPANYNAME]          NVARCHAR (200) NULL,
    [CONTACTEMAIL]                NVARCHAR (500) NULL,
    [CONTACTPHONENUMBER]          NVARCHAR (100) NULL,
    [CONTACTWEBSITE]              NVARCHAR (500) NULL,
    [CONTACTTYPEID]               NVARCHAR (100) NULL,
    [ENTEREDDATEFROM]             DATETIME       NULL,
    [ENTEREDDATEFTO]              DATETIME       NULL,
    CONSTRAINT [PK_SearchInspection] PRIMARY KEY CLUSTERED ([SEARCHINSPECTIONID] ASC),
    CONSTRAINT [FK_SearchInsp_InspLinkID] FOREIGN KEY ([INSPECTIONLINKID]) REFERENCES [dbo].[IMINSPECTIONLINK] ([IMINSPECTIONLINKID]),
    CONSTRAINT [FK_SearchInspection_Inspector] FOREIGN KEY ([PRIMARYINSPECTOR]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SearchInspection_Status] FOREIGN KEY ([INSPECTIONSTATUS]) REFERENCES [dbo].[IMINSPECTIONSTATUS] ([IMINSPECTIONSTATUSID]),
    CONSTRAINT [FK_SearchInspection_Type] FOREIGN KEY ([INSPECTIONTYPE]) REFERENCES [dbo].[IMINSPECTIONTYPE] ([IMINSPECTIONTYPEID]),
    CONSTRAINT [FK_SearchInspection_Zn] FOREIGN KEY ([ZONEID]) REFERENCES [dbo].[ZONE] ([ZONEID]),
    CONSTRAINT [FK_SRCHINSP_MLNGADDCNTTPE] FOREIGN KEY ([MAILINGADDRESSCOUNTRYTYPEID]) REFERENCES [dbo].[MAILINGADDRESSCOUNTRYTYPE] ([MAILINGADDRESSCOUNTRYTYPEID])
);

