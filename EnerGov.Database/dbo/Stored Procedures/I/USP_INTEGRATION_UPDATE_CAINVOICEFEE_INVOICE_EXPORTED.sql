﻿CREATE PROCEDURE [dbo].[USP_INTEGRATION_UPDATE_CAINVOICEFEE_INVOICE_EXPORTED]
	@FinanceBatchId NVARCHAR(50),
	@ChangedBy CHAR(36)
AS
BEGIN

    DECLARE @BatchNumber VARCHAR(50) = (SELECT TOP 1 BATCH_NUMBER FROM CAINTEGRATIONBATCHPROCESS WHERE FINANCEBATCHID = @FinanceBatchId AND CAINTEGRATIONBATCHTYPEID = 4);

	UPDATE CAINVOICEFEE SET CAEXPORTSTATUSID = 3
	FROM CAINVOICEFEE
	JOIN CAEXTERNALINVOICEBATCHFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = CAEXTERNALINVOICEBATCHFEE.CACOMPUTEDFEEID
	WHERE CAEXTERNALINVOICEBATCHFEE.BATCHNUMBER = @BatchNumber
	AND CAINVOICEFEE.CAEXPORTSTATUSID = 2;

	UPDATE CAINVOICE SET ROWVERSION = ROWVERSION + 1 
	FROM CAINVOICE
	JOIN CAINVOICEFEE ON CAINVOICE.CAINVOICEID = CAINVOICEFEE.CAINVOICEID
	JOIN CAEXTERNALINVOICEBATCHFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = CAEXTERNALINVOICEBATCHFEE.CACOMPUTEDFEEID
	WHERE CAEXTERNALINVOICEBATCHFEE.BATCHNUMBER = @BatchNumber
	AND CAINVOICEFEE.CAEXPORTSTATUSID = 3;

	INSERT INTO HISTORYSYSTEMSETUP (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
	SELECT CI.CAINVOICEID, CI.ROWVERSION, GETDATE(), @ChangedBy, 'ExportStatus', 'Pending Export', 'Exported', CF.FEENAME + ': Export Status changed by Windows Service.'
	FROM CAINVOICEFEE NF
	JOIN CAEXTERNALINVOICEBATCHFEE BF ON NF.CACOMPUTEDFEEID = BF.CACOMPUTEDFEEID
	JOIN CACOMPUTEDFEE CF ON NF.CACOMPUTEDFEEID = CF.CACOMPUTEDFEEID
	JOIN CAINVOICE CI ON NF.CAINVOICEID = CI.CAINVOICEID
	WHERE BF.BATCHNUMBER = @BatchNumber
	AND NF.CAEXPORTSTATUSID = 3;


	UPDATE CAINVOICEMISCFEE SET CAEXPORTSTATUSID = 3 
	FROM CAINVOICEMISCFEE
	JOIN CAEXTERNALINVOICEBATCHMISCFEE ON CAINVOICEMISCFEE.CAMISCFEEID = CAEXTERNALINVOICEBATCHMISCFEE.CAMISCFEEID
	WHERE CAEXTERNALINVOICEBATCHMISCFEE.BATCHNUMBER = @BatchNumber
	AND CAINVOICEMISCFEE.CAEXPORTSTATUSID = 2;

    UPDATE CAINVOICE SET ROWVERSION = ROWVERSION + 1 
	FROM CAINVOICE
	JOIN CAINVOICEMISCFEE ON CAINVOICE.CAINVOICEID = CAINVOICEMISCFEE.CAINVOICEID
	JOIN CAEXTERNALINVOICEBATCHMISCFEE ON CAINVOICEMISCFEE.CAMISCFEEID = CAEXTERNALINVOICEBATCHMISCFEE.CAMISCFEEID
	WHERE CAEXTERNALINVOICEBATCHMISCFEE.BATCHNUMBER = @BatchNumber
	AND CAINVOICEMISCFEE.CAEXPORTSTATUSID = 3;

	INSERT INTO HISTORYSYSTEMSETUP (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
	SELECT CI.CAINVOICEID, CI.ROWVERSION, GETDATE(), @ChangedBy, 'ExportStatus', 'Pending Export', 'Exported', CF.FEENAME + ': Export Status changed by Windows Service.'
	FROM CAINVOICEMISCFEE IMF
	JOIN CAEXTERNALINVOICEBATCHMISCFEE BF ON IMF.CAMISCFEEID = BF.CAMISCFEEID
	JOIN CAMISCFEE CF ON IMF.CAMISCFEEID = CF.CAMISCFEEID
	JOIN CAINVOICE CI ON IMF.CAINVOICEID = CI.CAINVOICEID
	WHERE BF.BATCHNUMBER = @BatchNumber
	AND IMF.CAEXPORTSTATUSID = 3;
END