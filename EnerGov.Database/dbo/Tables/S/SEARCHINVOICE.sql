﻿CREATE TABLE [dbo].[SEARCHINVOICE] (
    [SEARCHINVOICEID]             CHAR (36)      NOT NULL,
    [CRITERIAUSERID]              CHAR (36)      NOT NULL,
    [CRITERIANAME]                NVARCHAR (255) NULL,
    [ISSHARED]                    BIT            NULL,
    [BILLINGCONTACTFIRSTNAME]     VARCHAR (50)   NULL,
    [BILLINGCONTACTMIDDLENAME]    VARCHAR (50)   NULL,
    [BILLINGCONTACTLASTNAME]      VARCHAR (50)   NULL,
    [BILLINGCONTACTCOMPANYNAME]   VARCHAR (100)  NULL,
    [BILLINGINVOICEFIRSTNAME]     VARCHAR (50)   NULL,
    [BILLINGINVOICEMIDDLENAME]    VARCHAR (50)   NULL,
    [BILLINGINVOICELASTNAME]      VARCHAR (50)   NULL,
    [BILLINGINVOICECOMPANYNAME]   VARCHAR (100)  NULL,
    [TOTALDUEAMOUNTFROM]          MONEY          NULL,
    [TOTALDUEAMOUNTTO]            MONEY          NULL,
    [CHANGEBACKFROM]              MONEY          NULL,
    [CHANGEBACKTO]                MONEY          NULL,
    [FEEAMOUNTDUEFROM]            MONEY          NULL,
    [FEEAMOUNTDUETO]              MONEY          NULL,
    [PAYMENTAMOUNTFROM]           MONEY          NULL,
    [PAYMENTAMOUNTTO]             MONEY          NULL,
    [PAYMENTDATEFROM]             DATETIME       NULL,
    [PAYMENTDATETO]               DATETIME       NULL,
    [TRANSACTIONDATEFROM]         DATETIME       NULL,
    [TRANSACTIONDATETO]           DATETIME       NULL,
    [FEECREATEDONDATESTART]       DATETIME       NULL,
    [FEECREATEDONDATETO]          DATETIME       NULL,
    [PAYMENTTYPEID]               INT            NULL,
    [PAYMENTSTATUSID]             INT            NULL,
    [CAPAYMENTMETHODID]           CHAR (36)      NULL,
    [PAYMENTNOTE]                 NVARCHAR (MAX) NULL,
    [TRANSACTIONNOTE]             NVARCHAR (MAX) NULL,
    [CATRANSACTIONTYPEID]         INT            NULL,
    [OFFICE]                      CHAR (36)      NULL,
    [CHECKNUMBER]                 NVARCHAR (50)  NULL,
    [MONEYORDERNUMBER]            NVARCHAR (50)  NULL,
    [CREDITCARDNUMBER]            NVARCHAR (50)  NULL,
    [TRANSACTIONGROUPNUMBER]      NVARCHAR (50)  NULL,
    [ISONLINE]                    BIT            NULL,
    [ISNOTONLINE]                 BIT            NULL,
    [RECEIPTNUMBER]               NVARCHAR (50)  NULL,
    [ENTITYACCOUNTNUMBER]         NVARCHAR (100) NULL,
    [CREATEDBYUSER]               CHAR (36)      NULL,
    [FEENAME]                     VARCHAR (50)   NULL,
    [FEENOTES]                    VARCHAR (500)  NULL,
    [FEEDESCRIPTION]              VARCHAR (500)  NULL,
    [INVOICENUMBER]               VARCHAR (500)  NULL,
    [INVOICEDESCRIPTION]          VARCHAR (500)  NULL,
    [FEEAMOUNTPAIDFROM]           MONEY          NULL,
    [FEEAMOUNTPAIDTO]             MONEY          NULL,
    [FEEREFUNDAMOUNTFROM]         MONEY          NULL,
    [FEEREFUNDAMOUNTTO]           MONEY          NULL,
    [FEEARDEBITGL]                NVARCHAR (100) NULL,
    [FEEARCREDITGL]               NVARCHAR (100) NULL,
    [INVOICEAMOUNTFROM]           MONEY          NULL,
    [INVOICEAMOUNTTO]             MONEY          NULL,
    [INVOICECREATEDDATEFROM]      DATETIME       NULL,
    [INVOICECREATEDDATETO]        DATETIME       NULL,
    [INVOICEDUEDATEFROM]          DATETIME       NULL,
    [INVOICEDUEDATETO]            DATETIME       NULL,
    [INVOICECREATEDBYUSER]        CHAR (36)      NULL,
    [CAFEETYPEID]                 INT            NULL,
    [INVOICESTATUSID]             INT            NULL,
    [LINKID]                      CHAR (36)      NULL,
    [LINKNUMBER]                  VARCHAR (200)  NULL,
    [LANDMANAGEMENTCONTACTTYPEID] CHAR (36)      NULL,
    [CONTACTFIRSTNAME]            CHAR (50)      NULL,
    [CONTACTLASTNAME]             CHAR (50)      NULL,
    [CONTACTMIDDLENAME]           CHAR (50)      NULL,
    [CONTACTCOMPANYNAME]          CHAR (100)     NULL,
    [CONTACTEMAIL]                CHAR (100)     NULL,
    [CONTACTWEBSITE]              CHAR (100)     NULL,
    [CONTACTPHONENUMBER]          CHAR (100)     NULL,
    [CASHIERLINKID]               INT            NULL,
    CONSTRAINT [PK_SEARCHINVOICE] PRIMARY KEY CLUSTERED ([SEARCHINVOICEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_LMCONTACTTYPE_LMCOTYPE] FOREIGN KEY ([LANDMANAGEMENTCONTACTTYPEID]) REFERENCES [dbo].[LANDMANAGEMENTCONTACTTYPE] ([LANDMANAGEMENTCONTACTTYPEID]),
    CONSTRAINT [FK_SRCHINV_CAENTITYID] FOREIGN KEY ([CASHIERLINKID]) REFERENCES [dbo].[CAENTITY] ([CAENTITYID]),
    CONSTRAINT [FK_SRCHINV_CAINVOICESTATUSID] FOREIGN KEY ([INVOICESTATUSID]) REFERENCES [dbo].[CASTATUS] ([CASTATUSID]),
    CONSTRAINT [FK_SRCHINV_CAPAYTYPEID] FOREIGN KEY ([PAYMENTTYPEID]) REFERENCES [dbo].[CAPAYMENTTYPE] ([CAPAYMENTTYPEID]),
    CONSTRAINT [FK_SRCHINV_CAPTRANSTYPEID] FOREIGN KEY ([CATRANSACTIONTYPEID]) REFERENCES [dbo].[CATRANSACTIONTYPE] ([CATRANSACTIONTYPEID]),
    CONSTRAINT [FK_SRCHINV_CATRANSTATUSID] FOREIGN KEY ([PAYMENTSTATUSID]) REFERENCES [dbo].[CATRANSACTIONSTATUS] ([CATRANSACTIONSTATUSID]),
    CONSTRAINT [FK_SRCHINV_CREATEDBYUSERID] FOREIGN KEY ([CREATEDBYUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SRCHINV_CRITERIAUSERID] FOREIGN KEY ([CRITERIAUSERID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SRCHINV_FEETYPEID] FOREIGN KEY ([CAFEETYPEID]) REFERENCES [dbo].[CAFEETYPE] ([CAFEETYPEID]),
    CONSTRAINT [FK_SRCHINV_INVCREATEDBYUSERID] FOREIGN KEY ([INVOICECREATEDBYUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SRCHINV_OFFICEID] FOREIGN KEY ([OFFICE]) REFERENCES [dbo].[OFFICE] ([OFFICEID])
);

