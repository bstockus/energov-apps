

CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_FEES_WO_PAYMENT_METHODS]
AS

DECLARE @CAFEEID VARCHAR(36)
CREATE TABLE #TEMP (FEENAME char(50), PAYMENTMETHOD char(50))

       DECLARE GL_Cursor CURSOR FAST_FORWARD
       FOR 
              /*Establish GL_Cursor Input*/
              SELECT DISTINCT CAFEEID
			  FROM CAFEE

              /*Start GL_Cursor*/
              OPEn GL_Cursor
                     FETCH NEXT FROM GL_Cursor
                     INTO @CAFEEID
                     WHILE (@@FETCH_STATUS = 0)
                     BEGIN

                     INSERT INTO #TEMP 
SELECT  CAFEE.NAME,CAPAYMENTMETHOD.NAME FROM CAFEE
                                                CROSS JOIN CAPAYMENTMETHOD
                                                WHERE CAFEEID = @CAFEEID
                                                AND NOT EXISTS (SELECT * FROM CAFEEGLACCOUNTXREF   
                                                                     WHERE CAFEEGLACCOUNTXREF.CAPAYMENTMETHODID =CAPAYMENTMETHOD.CAPAYMENTMETHODID AND CAFEEID = @CAFEEID)
                                                                     AND CAPAYMENTMETHOD.ISACTIVE = 1 
                                                
                           FETCH NEXT FROM GL_Cursor
                           INTO @CAFEEID
                     END 
              CLOSE GL_Cursor
       DEALLOCATE GL_Cursor

select * from #TEMP
order by 1,2
drop table #TEMP


