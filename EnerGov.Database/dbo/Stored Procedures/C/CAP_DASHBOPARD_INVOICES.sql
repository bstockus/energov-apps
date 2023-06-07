﻿
CREATE PROCEDURE [dbo].[CAP_DASHBOPARD_INVOICES]
(
	@GLOBAL_ENTITY_ID CHAR(36),
	@TODAY_DATE DATETIME
)
AS
BEGIN
	SELECT 
		CASE 
			WHEN (CAINVOICE.CASTATUSID IN (1,3,6) AND CAINVOICE.INVOICEDUEDATE < @TODAY_DATE) OR CAINVOICE.CASTATUSID in (2,7,8) THEN 1 
			ELSE 0 
		END [IS_PAST_DUE],
		SUM([dbo].[INVOICE_DUE_AMOUNT](CAINVOICE.CAINVOICEID, CAINVOICE.CASTATUSID, CAINVOICE.INVOICETOTAL)) AS INVOICE_TOTAL
	FROM CAINVOICE 
	WHERE CAINVOICE.GLOBALENTITYID = @GLOBAL_ENTITY_ID  AND CAINVOICE.CASTATUSID NOT IN (4,5,9,10)
	GROUP BY 
		CASE 
			WHEN (CAINVOICE.CASTATUSID in (1,3,6) AND CAINVOICE.INVOICEDUEDATE < @TODAY_DATE) OR CAINVOICE.CASTATUSID in (2,7,8) THEN 1 
			ELSE 0 
		END

END