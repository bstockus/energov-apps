﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_FEES_W_PENDING_GL]
@GLNAME varchar(500)
AS
SELECT  CAFEE.NAME AS FEE_NAME, DEBIT_GL.GLACCOUNTID AS DEBIT_GL_ID, DEBIT_GL.NAME AS DEBIT_GL_NAME
		, CREDIT_GL.GLACCOUNTID AS CREDIT_GL_ID, CREDIT_GL.NAME AS CREDIT_GL_NAME
FROM CAFEEGLACCOUNTXREF 
INNER JOIN GLACCOUNT AS CREDIT_GL ON CAFEEGLACCOUNTXREF.CREDITGLACCOUNTID = CREDIT_GL.GLACCOUNTID 
INNER JOIN GLACCOUNT AS DEBIT_GL ON CAFEEGLACCOUNTXREF.DEBITGLACCOUNTID = DEBIT_GL.GLACCOUNTID 
INNER JOIN CAFEE ON CAFEEGLACCOUNTXREF.CAFEEID = CAFEE.CAFEEID
WHERE DEBIT_GL.NAME like '%'+@GLNAME+'%' or CREDIT_GL.NAME like '%'+@GLNAME+'%' 

