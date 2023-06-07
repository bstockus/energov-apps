﻿
CREATE PROCEDURE rpt_BL_SR_Batch_Renewal_Summary
	@BLBATCHRENEWALID AS VARCHAR(36)

AS

BEGIN

CREATE INDEX TEMP1 ON BLBATCHRENEWALBLLICENSE(BLLICENSEID)
CREATE INDEX TEMP1 ON BLBATCHRENEWALBLINVOICE(BLLICENSEID)
CREATE INDEX TEMP2 ON BLBATCHRENEWALBLINVOICE(CAINVOICEID)
CREATE INDEX TEMP1 ON BLBATCHRENEWALLOG(BLLICENSEID)

SELECT BR.BLBATCHRENEWALID, BRL.BLLICENSEID
		, COALESCE(BRL.SUCCESS,-1) LIC_SUCCESS
		, CASE WHEN BR.AUTOGENERATEINVOICE = 0 THEN 1 ELSE COALESCE(BRI.SUCCESS,-1) END INV_SUCCESS
INTO #BATCH_ITEM_STATE
FROM BLBATCHRENEWAL BR
	INNER JOIN BLBATCHRENEWALBLLICENSE BRL ON BR.BLBATCHRENEWALID = BRL.BLBATCHRENEWALID
	INNER JOIN BLBATCHRENEWALBLINVOICE BRI ON BRL.BLBATCHRENEWALID = BRI.BLBATCHRENEWALID 
                                AND BRL.BLLICENSEID = BRI.BLLICENSEID
WHERE BR.BLBATCHRENEWALID = @BLBATCHRENEWALID

CREATE INDEX TEMP1 ON #BATCH_ITEM_STATE(BLBATCHRENEWALID);

SELECT BISC.BLBATCHRENEWALID, BISC.BLLICENSEID
	, CASE WHEN BISC.LIC_SUCCESS = 1 AND BISC.INV_SUCCESS = 1 THEN 1
		WHEN BISC.LIC_SUCCESS = -1 OR BISC.INV_SUCCESS = -1 THEN -1
		WHEN BISC.LIC_SUCCESS = 0 OR BISC.INV_SUCCESS = 0 THEN 0
		END LICENSE_RENEWAL_STATUS
INTO #BATCH_RENEWAL_STATE
FROM #BATCH_ITEM_STATE BISC


SELECT BISC.BLBATCHRENEWALID
	, NULLIF(CASE WHEN MIN(BISC.LIC_SUCCESS) = -1 THEN 0 WHEN MIN(BISC.INV_SUCCESS) = -1 THEN 0
		ELSE 1 END,0) BATCH_COMPLETE
INTO #BATCH_STATE
FROM #BATCH_ITEM_STATE BISC
GROUP BY BISC.BLBATCHRENEWALID


SELECT BR.BLBATCHRENEWALID
	, MAX(BRL.PROCESSEDDATE) COMPLETE_DATE
INTO #BATCH_PROCESSED_FINAL_DATE
FROM BLBATCHRENEWAL BR
INNER JOIN BLBATCHRENEWALLOG BRL ON BR.BLBATCHRENEWALID = BRL.BLBATCHRENEWALID
WHERE BR.BLBATCHRENEWALID = @BLBATCHRENEWALID
GROUP BY BR.BLBATCHRENEWALID


SELECT BRSC.BLBATCHRENEWALID, BRSC.BLLICENSEID
	, MAX(CASE WHEN BRSC.LICENSE_RENEWAL_STATUS <> -1 THEN BRL.PROCESSEDDATE
		END) LICENSE_COMPLETE_DATE
INTO #LICENSE_PROCESSED_FINAL_DATE
FROM #BATCH_RENEWAL_STATE BRSC
INNER JOIN BLBATCHRENEWALLOG BRL ON BRSC.BLBATCHRENEWALID = BRL.BLBATCHRENEWALID
								AND BRSC.BLLICENSEID = BRL.BLLICENSEID
GROUP BY BRSC.BLBATCHRENEWALID, BRSC.BLLICENSEID

CREATE INDEX TEMP1 ON  #BATCH_RENEWAL_STATE(BLBATCHRENEWALID)
CREATE INDEX TEMP1 ON  #BATCH_STATE(BLBATCHRENEWALID)
CREATE INDEX TEMP1 ON  #BATCH_PROCESSED_FINAL_DATE(BLBATCHRENEWALID)
CREATE INDEX TEMP1 ON  #LICENSE_PROCESSED_FINAL_DATE(BLBATCHRENEWALID)

SELECT DISTINCT BR.BLBATCHRENEWALID, BR.BATCHRENEWALNUMBER, BR.CREATEDATE
	, L_ORIG.LICENSENUMBER ORIG_LICENSE_NUMBER, L_ORIG.BLLICENSEID
	, L_RENEWED.LICENSENUMBER RENEWED_LICENSE_NUMBER
	, I.INVOICENUMBER
	, LPFDC.LICENSE_COMPLETE_DATE
	, CASE WHEN BSC.BATCH_COMPLETE = 1 THEN BPFDC.COMPLETE_DATE
		END COMPLETE_DATE
	, CASE WHEN BRSC.LICENSE_RENEWAL_STATUS = 1 THEN 'Success'
		WHEN BRSC.LICENSE_RENEWAL_STATUS = 0 THEN 'Fail'
		WHEN BRSC.LICENSE_RENEWAL_STATUS = -1 THEN 'Pending'
		END RENEWAL_STATUS
	, CASE WHEN BRSC.LICENSE_RENEWAL_STATUS = 1 THEN 1
		WHEN BRSC.LICENSE_RENEWAL_STATUS = 0 THEN 2
		WHEN BRSC.LICENSE_RENEWAL_STATUS = -1 THEN 3
		END SORT_ORDER
	, CASE WHEN BRSC.LICENSE_RENEWAL_STATUS = 0 THEN BRLOG.REMARKS END FAILURE_REMARKS
	, CASE WHEN BRSC.LICENSE_RENEWAL_STATUS = 0 THEN BRLOG.PROCESSEDDATE END LOG_PROCESSED_DATE
	--,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
	,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM BLBATCHRENEWAL BR
INNER JOIN BLBATCHRENEWALBLLICENSE BRL ON BR.BLBATCHRENEWALID = BRL.BLBATCHRENEWALID
INNER JOIN BLBATCHRENEWALBLINVOICE BRI ON BRL.BLBATCHRENEWALID = BRI.BLBATCHRENEWALID 
                                AND BRL.BLLICENSEID = BRI.BLLICENSEID
INNER JOIN BLBATCHRENEWALLOG BRLOG ON BRL.BLBATCHRENEWALID = BRLOG.BLBATCHRENEWALID 
								AND BRL.BLLICENSEID = BRLOG.BLLICENSEID
INNER JOIN BLLICENSE L_ORIG ON BRL.BLLICENSEID = L_ORIG.BLLICENSEID
INNER JOIN #BATCH_RENEWAL_STATE BRSC ON BRL.BLBATCHRENEWALID = BRSC.BLBATCHRENEWALID
								AND BRL.BLLICENSEID = BRSC.BLLICENSEID
INNER JOIN #BATCH_STATE BSC ON BRL.BLBATCHRENEWALID = BSC.BLBATCHRENEWALID
INNER JOIN #BATCH_PROCESSED_FINAL_DATE BPFDC ON BR.BLBATCHRENEWALID = BPFDC.BLBATCHRENEWALID
INNER JOIN #LICENSE_PROCESSED_FINAL_DATE LPFDC ON BRL.BLBATCHRENEWALID = LPFDC.BLBATCHRENEWALID
								AND BRL.BLLICENSEID = LPFDC.BLLICENSEID
LEFT JOIN BLLICENSE L_RENEWED ON BRL.RENEWEDBLLICENSEID = L_RENEWED.BLLICENSEID
LEFT JOIN CAINVOICE I ON BRI.CAINVOICEID = I.CAINVOICEID
ORDER BY BR.BATCHRENEWALNUMBER, L_ORIG.LICENSENUMBER

OPTION (RECOMPILE)

DROP TABLE #BATCH_RENEWAL_STATE;
DROP TABLE #BATCH_STATE;
DROP TABLE #BATCH_PROCESSED_FINAL_DATE;
DROP TABLE #LICENSE_PROCESSED_FINAL_DATE;
DROP INDEX TEMP1 ON BLBATCHRENEWALBLLICENSE;
DROP INDEX TEMP1 ON BLBATCHRENEWALBLINVOICE;
DROP INDEX TEMP2 ON BLBATCHRENEWALBLINVOICE;
DROP INDEX TEMP1 ON BLBATCHRENEWALLOG;

END
