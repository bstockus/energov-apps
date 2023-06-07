
-- =============================================
-- Author:  Chris Therrien
-- Create date: 6/4/2015
-- Description: Updates Late Fee Percentage Custom field with % late
-- Mod 6/25/2015 Tom Stradling
--				Add Development naming standards and error catching. Add increment of rowversion to main object.
--              Note I had to comment out parts that require certain customfields to be there as they
--				won't in non PMO databases (meaning upgrade the script wouldn't run in)
--				these should be uncommented in PMO databases.	
--
-- =============================================
CREATE PROCEDURE PMO_PROC_BL_LATE_FEE_PERCENT
AS
BEGIN
    BEGIN TRY
			  SET NOCOUNT ON;
      
		DECLARE @VALUE nvarchar(5)
		DECLARE @BLLICENSEID char(36)
		DECLARE @EXPIRATIONDATE datetime
		DECLARE @DAYSOVER NVARCHAR(10)


		DECLARE CSR_UP_NUMLATE CURSOR FAST_FORWARD
		FOR
		select BLLICENSEID,EXPIRATIONDATE,(DATEDIFF(DD,GETDATE(),EXPIRATIONDATE)*-1)as DAYSOVER from BLLICENSE
		where Convert(date,EXPIRATIONDATE) < GETDATE() and 
		BLLICENSE.BLLICENSESTATUSID in ('cc2f0bdd-cbd9-4973-8a65-09810f646ffa','ef041cd6-5629-46b0-9e4e-73d60aa626fd')
		and BLLICENSECLASSID='412c1345-9828-4cc5-b01f-f1f173ccc7bb'


		OPEN UP_NUMLATE
		FETCH NEXT FROM CSR_UP_NUMLATE INTO @BLLICENSEID,@EXPIRATIONDATE,@DAYSOVER

		WHILE(@@FETCH_STATUS = 0)


		begin
		--Value Ranges
					IF @DAYSOVER BETWEEN 0 AND 30
					SET @VALUE = 0
            
					IF @DAYSOVER BETWEEN 31 AND 60
					SET @VALUE = .1
            
					IF @DAYSOVER BETWEEN 61 AND 90
					SET @VALUE = .2
            
					IF @DAYSOVER BETWEEN 91 AND 180
					SET @VALUE = .3
            
					IF @DAYSOVER BETWEEN 181 AND 210
					SET @VALUE = .4
            
					IF @DAYSOVER BETWEEN 211 AND 240 
					SET @VALUE = .5
            
					IF @DAYSOVER BETWEEN 241 AND 270 
					SET @VALUE = .6
            
					IF @DAYSOVER BETWEEN 271 AND 300 
					SET @VALUE = .7
            
					IF @DAYSOVER BETWEEN 301 AND 330 
					SET @VALUE = .8
            
					IF @DAYSOVER BETWEEN 331 AND 360
					SET @VALUE = .9
            
					IF @DAYSOVER >= 361 
					SET @VALUE = 1.0

					--Field Mapping 
					--UPDATE CUSTOMSAVERLICENSEMANAGEMENT
					--SET LateFeePercentage = @VALUE
					--WHERE ID = @BLLICENSEID
					
					-- Main business object rowversion must be updated. 
					UPDATE BLLICENSE
					SET ROWVERSION = ROWVERSION + 1
					WHERE BLLICENSEID = @BLLICENSEID

					FETCH NEXT FROM UP_NUMLATE INTO @BLLICENSEID,@EXPIRATIONDATE,@DAYSOVER

					END
					CLOSE CSR_UP_NUMLATE
					DEALLOCATE  CSR_UP_NUMLATE

		   END TRY
	  BEGIN CATCH
		 --
		 --
		INSERT into GLOBALERRORDATABASE VALUES (newid(),'PMO_PROC_BL_LATE_FEE_PERCENT', getdate(), @@ERROR, null)
		 --	
		 --
		CLOSE CSR_UP_NUMLATE
		DEALLOCATE  CSR_UP_NUMLATE
		 --
		 --
	  END CATCH

END
