﻿CREATE PROCEDURE [events].[USP_INVOICEEVENTQUEUE_SELECT_LOOKUP]
(
	@BATCHSIZE AS INT = 1000
)
AS


DECLARE @RESULT_DATA AS TABLE 
(
	[INVOICEEVENTQUEUEID] BIGINT, 
	[INVOICEEVENTTYPEID] INT,
	[CREATEDDATE] DATETIME,
	[CAINVOICEID] CHAR(36),
	[INVOICENUMBER] NVARCHAR(500),
	[INVOICEDATE] DATETIME,
	[INVOICEDUEDATE] DATETIME,
	[INVOICESTATUS] NVARCHAR(50),
	[INVOICEDESCRIPTION] NVARCHAR(80),
	[INVOICETOTAL] MONEY,
	[LASTCHANGEDON] DATETIME,
	[FIRSTNAME] NVARCHAR(60),
	[LASTNAME] NVARCHAR(60)
);

WITH RAW_DATA AS (
	SELECT TOP(@BATCHSIZE)
		[dbo].[INVOICEEVENTQUEUE].[INVOICEEVENTQUEUEID],
		[dbo].[INVOICEEVENTQUEUE].[INVOICEEVENTTYPEID],
		[dbo].[INVOICEEVENTQUEUE].[CREATEDDATE],
		[dbo].[CAINVOICE].[CAINVOICEID] CAINVOICEID,
		[dbo].[CAINVOICE].[INVOICENUMBER],
		[dbo].[CAINVOICE].[INVOICEDATE],
		[dbo].[CAINVOICE].[INVOICEDUEDATE],
		[dbo].[CASTATUS].[NAME] INVOICESTATUS,
		SUBSTRING([dbo].[CAINVOICE].[INVOICEDESCRIPTION], 1, 80) AS [INVOICEDESCRIPTION],
		[dbo].[CAINVOICE].[INVOICETOTAL],
		[dbo].[CAINVOICE].[LASTCHANGEDON],
		[dbo].[USERS].[FNAME] FIRSTNAME,
		[dbo].[USERS].[LNAME] LASTNAME

	FROM [dbo].[INVOICEEVENTQUEUE] WITH (NOLOCK)
	INNER JOIN [dbo].[CAINVOICE] WITH (NOLOCK) ON [dbo].[INVOICEEVENTQUEUE].[CAINVOICEID] = [dbo].[CAINVOICE].[CAINVOICEID]
	INNER JOIN [dbo].[CASTATUS] WITH (NOLOCK) ON [dbo].[CAINVOICE].[CASTATUSID] = [dbo].[CASTATUS].[CASTATUSID]
	INNER JOIN [dbo].[USERS] WITH (NOLOCK) ON [dbo].[CAINVOICE].[LASTCHANGEDBY] = [dbo].[USERS].[SUSERGUID]
	WHERE [dbo].[INVOICEEVENTQUEUE].[PROCESSEDDATE] IS NULL
	ORDER BY [dbo].[INVOICEEVENTQUEUE].[CREATEDDATE]
)
INSERT INTO @RESULT_DATA
SELECT * 
FROM RAW_DATA


-- Invoice Data
SELECT * FROM @RESULT_DATA


-- Invoice Billing Contacts
SELECT 
	[dbo].[CAINVOICECONTACT].[CAINVOICEID],
	[dbo].[GLOBALENTITY].[GLOBALENTITYID],
	[dbo].[GLOBALENTITY].[FIRSTNAME],
	[dbo].[GLOBALENTITY].[LASTNAME],
	[dbo].[GLOBALENTITY].[MIDDLENAME],
	[dbo].[GLOBALENTITY].[GLOBALENTITYNAME]
FROM @RESULT_DATA [RESULTDATA]
INNER JOIN [dbo].[CAINVOICECONTACT] WITH (NOLOCK) ON [RESULTDATA].[CAINVOICEID] = [dbo].[CAINVOICECONTACT].[CAINVOICEID]
INNER JOIN [dbo].[GLOBALENTITY] WITH (NOLOCK) ON [dbo].[CAINVOICECONTACT].[GLOBALENTITYID] = [dbo].[GLOBALENTITY].[GLOBALENTITYID]
WHERE [dbo].[CAINVOICECONTACT].[ISACTIVE] = 1


-- Invoice Notes
SELECT 
	[dbo].[CAINVOICENOTE].[CAINVOICEID],
	[dbo].[CAINVOICENOTE].[TEXT],
	[dbo].[CAINVOICENOTE].[CREATEDDATE],
    CASE WHEN COALESCE([dbo].[USERS].[FNAME], '') = ''
		 THEN CASE WHEN COALESCE([dbo].[USERS].[LNAME], '') = '' 
		           THEN ''
				   ELSE [dbo].[USERS].[LNAME] END
		 ELSE CASE WHEN COALESCE([dbo].[USERS].[LNAME], '') = ''
					THEN [dbo].[USERS].[FNAME]
				    ELSE [dbo].[USERS].[LNAME] + ', ' + [dbo].[USERS].[FNAME]
			  END
	END CREATEDBYNAME
FROM @RESULT_DATA [RESULTDATA]
INNER JOIN [dbo].[CAINVOICENOTE] WITH (NOLOCK) ON [RESULTDATA].[CAINVOICEID] = [dbo].[CAINVOICENOTE].[CAINVOICEID]
INNER JOIN [dbo].[USERS] WITH (NOLOCK) ON [dbo].[CAINVOICENOTE].[CREATEDBY] = [dbo].[USERS].[SUSERGUID]


-- Invoice Misc Fees
SELECT 
	[dbo].[CAINVOICEMISCFEE].[CAINVOICEID],
	[dbo].[CAMISCFEE].[FEENAME],
	[dbo].[CAMISCFEE].[AMOUNT] FEETOTAL,
	[dbo].[CAMISCFEE].[AMOUNT] - [CAMISCFEE].[PAIDAMOUNT] AMOUNTDUE
FROM @RESULT_DATA [RESULTDATA]
INNER JOIN [dbo].[CAINVOICEMISCFEE] WITH (NOLOCK) ON [RESULTDATA].[CAINVOICEID] = [dbo].[CAINVOICEMISCFEE].[CAINVOICEID]
INNER JOIN [dbo].[CAMISCFEE] WITH (NOLOCK) ON [dbo].[CAINVOICEMISCFEE].[CAMISCFEEID] = [dbo].[CAMISCFEE].[CAMISCFEEID]


-- Invoice Fees
SELECT 
	[dbo].[CAINVOICEFEE].[CAINVOICEID],
	[dbo].[INVOICEMODULEFEEVIEW].[FEENAME],
	[dbo].[INVOICEMODULEFEEVIEW].[COMPUTEDAMOUNT] FEETOTAL,
	[dbo].[INVOICEMODULEFEEVIEW].[COMPUTEDAMOUNT] - [CAINVOICEFEE].[PAIDAMOUNT] AMOUNTDUE,
	[dbo].[INVOICEMODULEFEEVIEW].[NOTES],
	[dbo].[INVOICEMODULEFEEVIEW].[ENTITYNUMBER],
	[dbo].[INVOICEMODULEFEEVIEW].[ENTITYNAME]
FROM @RESULT_DATA [RESULTDATA]
INNER JOIN [dbo].[CAINVOICEFEE] WITH (NOLOCK) ON [RESULTDATA].[CAINVOICEID] = [dbo].[CAINVOICEFEE].[CAINVOICEID]
INNER JOIN [dbo].[INVOICEMODULEFEEVIEW] WITH (NOLOCK) ON [dbo].[CAINVOICEFEE].[CACOMPUTEDFEEID] = [dbo].[INVOICEMODULEFEEVIEW].[CACOMPUTEDFEEID]