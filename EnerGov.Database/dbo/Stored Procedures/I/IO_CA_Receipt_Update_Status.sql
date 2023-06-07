CREATE PROCEDURE dbo.IO_CA_Receipt_Update_Status
@TRANSACTIONID AS CHAR(36)

AS
--This store procedure updates the status of the Business and Professional licenses when a payment is made.

SET NOCOUNT ON;

DECLARE
@TRANSACTIONDATE AS DATETIME,
@CAINVOICEID AS CHAR(36),
@ISSUEDATE DATETIME,
@EXPIRATIONYEAR INT,
@EXPIRATIONMONTH INT,
@EXPIRATIONDAY INT,
@EXPIRATIONDATE DATETIME,
@RENEWAL INT,
@BLLICENSEID AS CHAR(36),
@BLLICENSECLASSNAME AS NVARCHAR(50),
@ILLICENSEID AS CHAR(36),
@ILLICENSETYPENAME AS NVARCHAR(50)

--Business License Status Update
DECLARE TABLE_CURSOR CURSOR FAST_FORWARD
FOR

       SELECT DISTINCT A.BLLICENSEID, BLLICENSECLASS.NAME
       FROM BLLICENSE AS A INNER JOIN
              BLLICENSETYPE ON A.BLLICENSETYPEID = BLLICENSETYPE.BLLICENSETYPEID INNER JOIN
              BLLICENSESTATUS ON A.BLLICENSESTATUSID = BLLICENSESTATUS.BLLICENSESTATUSID INNER JOIN
              BLLICENSECLASS ON A.BLLICENSECLASSID = BLLICENSECLASS.BLLICENSECLASSID INNER JOIN
              BLLICENSEFEE ON A.BLLICENSEID = BLLICENSEFEE.BLLICENSEID INNER JOIN
              CACOMPUTEDFEE ON BLLICENSEFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID INNER JOIN
              CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID INNER JOIN
              CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID
       WHERE CATRANSACTION.CATRANSACTIONID = @TRANSACTIONID

       OPEN TABLE_CURSOR
       FETCH NEXT FROM TABLE_CURSOR INTO @BLLICENSEID, @BLLICENSECLASSNAME

       WHILE @@FETCH_STATUS = 0
       BEGIN
              --Get the Issue Date
              SET @ISSUEDATE = GETDATE()
              
              --Determine if this is a Renewal or Non-Renewal
              SET @RENEWAL = (SELECT CASE WHEN BLLICENSE.BLLICENSEPARENTID IS NOT NULL THEN 1
                                                ELSE 0 END
                                         FROM BLLICENSE 
                                         WHERE BLLICENSE.BLLICENSEID = @BLLICENSEID)
              
              --IF THIS IS A RENEWAL THEN RUN BELOW                                
              
              IF @RENEWAL = 1
              BEGIN 

                           SET @EXPIRATIONDATE = (SELECT DATEADD(MONTH, 3, BLLICENSEOLD.EXPIRATIONDATE) FROM BLLICENSE AS BLLICENSERENEWAL INNER JOIN
                                                                           BLLICENSE AS BLLICENSEOLD ON BLLICENSERENEWAL.BLLICENSEPARENTID = BLLICENSEOLD.BLLICENSEID
                                                                           WHERE BLLICENSERENEWAL.BLLICENSEID = @BLLICENSEID)
 
              END
                                  
              IF @RENEWAL = 0
              BEGIN
       

                     
                     --Set the Expiration Month Integer
                     SET @EXPIRATIONMONTH = (SELECT CASE DATEPART(MM, @ISSUEDATE)
                                                                     WHEN '1' THEN '4'
                                                                     WHEN '2' THEN '4'
                                                                     WHEN '3' THEN '4'
                                                                     WHEN '4' THEN '7'
                                                                     WHEN '5' THEN '7'
                                                                     WHEN '6' THEN '7'
                                                                     WHEN '7' THEN '10'
                                                                     WHEN '8' THEN '10'
                                                                     WHEN '9' THEN '10'
                                                                     WHEN '10' THEN '1'
                                                                     WHEN '11' THEN '1'
                                                                     WHEN '12' THEN '1' END AS 'ExpirationMonth')
                                                                           
                     --SET THE EXPIRATION YEAR INTEGER
                    
                           --Get the Expiration Year Integer
                           SET @EXPIRATIONYEAR = DATEPART(YYYY, @ISSUEDATE)+1
                                         
                           --If the Expiration Month = October, November or December Then Set year to +1
                           SET @EXPIRATIONYEAR = (SELECT CASE DATEPART(MM, @ISSUEDATE)
                                                                           WHEN '10' THEN @EXPIRATIONYEAR + 1
                                                                           WHEN '11' THEN @EXPIRATIONYEAR + 1
                                                                           WHEN '12' THEN @EXPIRATIONYEAR + 1
                                                                           ELSE @EXPIRATIONYEAR END AS 'ExpirationYear')

                                                                            
                     --Set the Expiration Date as DateTime
                     SET @EXPIRATIONDATE = (CAST((CAST(@EXPIRATIONYEAR AS VARCHAR(4)) + '-' + CAST(@EXPIRATIONMONTH AS VARCHAR(2)) + '-' + CAST(DATEPART(DD,@ISSUEDATE) AS VARCHAR(2)) + ' 00:00:00.000') AS DATETIME))

                     --Set the Expiration Date to the last day of the month
                     SET @EXPIRATIONDATE = DATEADD(DAY, -(DAY(DATEADD(MONTH, 1, @EXPIRATIONDATE))), DATEADD(MONTH, 1, @EXPIRATIONDATE))

              END
                     
              --RUN THE UPDATE STATEMENT AGAINST THE BLLICENSE TABLE
              UPDATE BLLICENSE 
              SET BLLICENSE.BLLICENSESTATUSID = '8bec0f51-b270-49b5-ae8e-cdc552af1a6f' , --This is the Active StatusID
              BLLICENSE.ISSUEDDATE = @ISSUEDATE,
              BLLICENSE.EXPIRATIONDATE = @EXPIRATIONDATE,
              BLLICENSE.ISSUEDBY = (SELECT CATRANSACTION.CREATEDBY
                                                       FROM CATRANSACTION
                                                       WHERE CATRANSACTION.CATRANSACTIONID = @TRANSACTIONID)
              WHERE BLLICENSE.BLLICENSEID = @BLLICENSEID

       
       FETCH NEXT FROM TABLE_CURSOR INTO @BLLICENSEID, @BLLICENSECLASSNAME
       END
       CLOSE TABLE_CURSOR
       DEALLOCATE TABLE_CURSOR