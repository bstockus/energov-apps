﻿CREATE TABLE [dbo].[SEARCHPERMIT] (
    [SEARCHPERMITID]              CHAR (36)       NOT NULL,
    [CRITERIANAME]                NVARCHAR (255)  NULL,
    [ISSHARED]                    BIT             NULL,
    [USERID]                      CHAR (36)       NOT NULL,
    [PERMITNUMBER]                NVARCHAR (255)  NULL,
    [PMPERMITID]                  CHAR (36)       NULL,
    [PRPROJECTID]                 CHAR (36)       NULL,
    [PMPERMITTYPEID]              CHAR (36)       NULL,
    [PMPERMITWORKCLASSID]         CHAR (36)       NULL,
    [DISTRICTID]                  CHAR (36)       NULL,
    [PMPERMITSTATUSID]            CHAR (36)       NULL,
    [STREETNUMBER]                NVARCHAR (255)  NULL,
    [PREDIRECTION]                NVARCHAR (50)   NULL,
    [STREETNAME]                  NVARCHAR (255)  NULL,
    [MAILINGADDRESSSTREETTYPEID]  CHAR (36)       NULL,
    [POSTDIRECTION]               NVARCHAR (50)   NULL,
    [APARTMENT]                   NVARCHAR (255)  NULL,
    [CITY]                        NVARCHAR (255)  NULL,
    [ZONEID]                      CHAR (36)       NULL,
    [STATE]                       NVARCHAR (50)   NULL,
    [ZIP]                         NVARCHAR (50)   NULL,
    [PARCELNUMBER]                NVARCHAR (255)  NULL,
    [HEARINGDATEFROM]             DATETIME        NULL,
    [HEARINGDATETO]               DATETIME        NULL,
    [HEARINGTYPEID]               CHAR (36)       NULL,
    [HEARINGSTATUSID]             CHAR (36)       NULL,
    [MEETINGDATEFROM]             DATETIME        NULL,
    [MEETINGDATETO]               DATETIME        NULL,
    [MEETINGTYPEID]               CHAR (36)       NULL,
    [MEETINGCOMMENTS]             NVARCHAR (MAX)  NULL,
    [STARTAPPLICATIONDATE]        DATETIME        NULL,
    [ENDAPPLICATIONDATE]          DATETIME        NULL,
    [STARTEXPIRATIONDATE]         DATETIME        NULL,
    [ENDEXPIRATIONDATE]           DATETIME        NULL,
    [STARTISSUEDATE]              DATETIME        NULL,
    [ENDISSUEDATE]                DATETIME        NULL,
    [STARTFINALEDDATE]            DATETIME        NULL,
    [ENDFINALEDDATE]              DATETIME        NULL,
    [STARTLASTINSPECTIONDATE]     DATETIME        NULL,
    [ENDLASTINSPECTIONDATE]       DATETIME        NULL,
    [LANDMANAGEMENTCONTACTTYPEID] CHAR (36)       NULL,
    [MAINPERMITNUMBER]            NVARCHAR (50)   NULL,
    [PROJECTNAME]                 NVARCHAR (100)  NULL,
    [SQUAREFEETFROM]              DECIMAL (15, 2) NULL,
    [SQUAREFEETTO]                DECIMAL (15, 2) NULL,
    [VALUATIONVALUEFROM]          MONEY           NULL,
    [VALUATIONVALUETO]            MONEY           NULL,
    [ADDRESSTYPE]                 NVARCHAR (50)   NULL,
    [MAINADDRESS]                 BIT             DEFAULT ((1)) NOT NULL,
    [MAINPARCEL]                  BIT             DEFAULT ((1)) NOT NULL,
    [MAINZONE]                    BIT             DEFAULT ((1)) NOT NULL,
    [HEARINGCOMMENTS]             NVARCHAR (MAX)  NULL,
    [CONTACTFIRSTNAME]            NVARCHAR (50)   NULL,
    [CONTACTMIDDLENAME]           NVARCHAR (50)   NULL,
    [CONTACTLASTNAME]             NVARCHAR (50)   NULL,
    [CONTACTCOMPANYNAME]          NVARCHAR (100)  NULL,
    [CONTACTEMAIL]                NVARCHAR (250)  NULL,
    [CONTACTPHONENUMBER]          NVARCHAR (50)   NULL,
    [CONTACTWEBSITE]              NVARCHAR (250)  NULL,
    [UNITORSUITE]                 NVARCHAR (20)   NULL,
    [PROVINCE]                    NVARCHAR (50)   NULL,
    [RURALROUTE]                  NVARCHAR (50)   NULL,
    [STATION]                     NVARCHAR (50)   NULL,
    [COMPSITE]                    NVARCHAR (50)   NULL,
    [POBOX]                       NVARCHAR (50)   NULL,
    [ATTN]                        NVARCHAR (50)   NULL,
    [MAILINGADDRESSCOUNTRYTYPEID] INT             DEFAULT ((0)) NOT NULL,
    [OBJECTNUMBER]                NVARCHAR (50)   NULL,
    [DESCRIPTION]                 NVARCHAR (MAX)  NULL,
    [OBJECTTYPEID]                CHAR (36)       NULL,
    [OBJECTCLASSIFICATIONID]      CHAR (36)       NULL,
    [CREATEDDATEFROM]             DATETIME        NULL,
    [CREATEDDATETO]               DATETIME        NULL,
    [INSTALLDATEFROM]             DATETIME        NULL,
    [INSTALLDATETO]               DATETIME        NULL,
    [OPERATIONSTARTDATEFROM]      DATETIME        NULL,
    [OPERATIONSTARTDATETO]        DATETIME        NULL,
    [OPERATIONENDDATEFROM]        DATETIME        NULL,
    [OPERATIONENDDATETO]          DATETIME        NULL,
    [BALANCEDUEFROM]              MONEY           NULL,
    [BALANCEDUETO]                MONEY           NULL,
    [PERMITDESCRIPTION]           VARCHAR (MAX)   NULL,
    [CONTACTTYPEID]               BIT             NULL,
    [SUBMITTALCOMPLETED]          NVARCHAR (10)   NULL,
    [SUBMITTALNEEDSRESUBMIT]      NVARCHAR (10)   NULL,
    [SUBMITTALRECEIVEFROMDATE]    DATETIME        NULL,
    [SUBMITTALRECEIVETODATE]      DATETIME        NULL,
    [SUBMITTALDUEFROMDATE]        DATETIME        NULL,
    [SUBMITTALDUETODATE]          DATETIME        NULL,
    [SUBMITTALTYPEID]             CHAR (36)       NULL,
    [SUBMITTALSTATUSID]           CHAR (36)       NULL,
    [ASSIGNEDTOID]                CHAR (36)       NULL,
    [ITEMREVIEWHASCORRECTIONS]    NVARCHAR (10)   NULL,
    [ITEMREVIEWAPPROVED]          NVARCHAR (10)   NULL,
    [ITEMREVIEWTYPEID]            CHAR (36)       NULL,
    [ITEMREVIEWSTATUSID]          CHAR (36)       NULL,
    [ITEMREVIEWASSIGNEDTOID]      CHAR (36)       NULL,
    [ITEMREVIEWASSIGNEDFROMDATE]  DATETIME        NULL,
    [ITEMREVIEWASSIGNEDTODATE]    DATETIME        NULL,
    [ITEMREVIEWREVIEWEDFROMDATE]  DATETIME        NULL,
    [ITEMREVIEWREVIEWEDTODATE]    DATETIME        NULL,
    [ITEMREVIEWDUEFROMDATE]       DATETIME        NULL,
    [ITEMREVIEWDUETODATE]         DATETIME        NULL,
    [IVRNUMBER]                   INT             NULL,
    CONSTRAINT [PK_SearchPermit] PRIMARY KEY CLUSTERED ([SEARCHPERMITID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ContactTypeID_ContactType] FOREIGN KEY ([LANDMANAGEMENTCONTACTTYPEID]) REFERENCES [dbo].[LANDMANAGEMENTCONTACTTYPE] ([LANDMANAGEMENTCONTACTTYPEID]),
    CONSTRAINT [FK_SearchPermit_District] FOREIGN KEY ([DISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_SearchPermit_HearingStatus] FOREIGN KEY ([HEARINGSTATUSID]) REFERENCES [dbo].[HEARINGSTATUS] ([HEARINGSTATUSID]),
    CONSTRAINT [FK_SearchPermit_HearingType] FOREIGN KEY ([HEARINGTYPEID]) REFERENCES [dbo].[HEARINGTYPE] ([HEARINGTYPEID]),
    CONSTRAINT [FK_SearchPermit_MeetingType] FOREIGN KEY ([MEETINGTYPEID]) REFERENCES [dbo].[MEETINGTYPE] ([MEETINGTYPEID]),
    CONSTRAINT [FK_SEARCHPERMIT_OMOBJECTCLASS] FOREIGN KEY ([OBJECTCLASSIFICATIONID]) REFERENCES [dbo].[OMOBJECTCLASSIFICATION] ([OMOBJECTCLASSIFICATIONID]),
    CONSTRAINT [FK_SEARCHPERMIT_OMOBJECTTYPE] FOREIGN KEY ([OBJECTTYPEID]) REFERENCES [dbo].[OMOBJECTTYPE] ([OMOBJECTTYPEID]),
    CONSTRAINT [FK_SearchPermit_PMPermit] FOREIGN KEY ([PMPERMITID]) REFERENCES [dbo].[PMPERMIT] ([PMPERMITID]),
    CONSTRAINT [FK_SearchPermit_PMPermitStatus] FOREIGN KEY ([PMPERMITSTATUSID]) REFERENCES [dbo].[PMPERMITSTATUS] ([PMPERMITSTATUSID]),
    CONSTRAINT [FK_SearchPermit_PMPermitType] FOREIGN KEY ([PMPERMITTYPEID]) REFERENCES [dbo].[PMPERMITTYPE] ([PMPERMITTYPEID]),
    CONSTRAINT [FK_SearchPermit_PMPermitWorkClass] FOREIGN KEY ([PMPERMITWORKCLASSID]) REFERENCES [dbo].[PMPERMITWORKCLASS] ([PMPERMITWORKCLASSID]),
    CONSTRAINT [FK_SearchPermit_PRProject] FOREIGN KEY ([PRPROJECTID]) REFERENCES [dbo].[PRPROJECT] ([PRPROJECTID]),
    CONSTRAINT [FK_SearchPermit_Users] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SRCHPERMIT_MLNGADDCNTTPE] FOREIGN KEY ([MAILINGADDRESSCOUNTRYTYPEID]) REFERENCES [dbo].[MAILINGADDRESSCOUNTRYTYPE] ([MAILINGADDRESSCOUNTRYTYPEID])
);

