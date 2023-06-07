﻿CREATE PROCEDURE [dbo].[USP_PERMITEVENTQUEUE_INSERT] 
(
@PAGESIZE AS INT,
@FROMDATETIME AS DATETIME,
@TODATETIME AS DATETIME,
@PERMITEXPIREDLASTRUN AS NVARCHAR(4000)
)
AS
	DECLARE @TodayStart DATETIME, @TodayEnd DATETIME

	SELECT @TodayStart = Convert(DateTime, DATEDIFF(DAY, 0, GETDATE())) ,
			@TodayEnd = Convert(DateTime, DATEADD("s", -1, DATEDIFF(DAY, -1, GETDATE())))

	IF NOT EXISTS (SELECT 1 FROM sys.indexes I
                INNER JOIN sys.tables T
                    ON I.object_id = T.object_id
                INNER JOIN sys.schemas S
                    ON S.schema_id = T.schema_id
            WHERE I.Name = 'IX_PMPERMIT_EXPIREDATE_EVENTS' -- Index name
                AND T.Name = 'PMPERMIT' -- Table name
                AND S.Name = 'dbo') --Schema Name
	BEGIN
		CREATE NONCLUSTERED INDEX [IX_PMPERMIT_EXPIREDATE_EVENTS]
			ON [dbo].[PMPERMIT]([EXPIREDATE] ASC);
	END

	INSERT INTO
		[dbo].PERMITEVENTQUEUE
		(
		PMPERMITID,
		PERMITEVENTTYPEID,
		EVENTSTATUSID,
		CREATEDDATE,
		PERMITLASTCHANGEDBY
		)
	SELECT TOP (@PAGESIZE)
		[PMPERMIT].PMPERMITID,
		7,
		1,
		GETDATE(),
		[PMPERMIT].LASTCHANGEDBY
	FROM [dbo].[PMPERMIT]
	WHERE [PMPERMIT].EXPIREDATE > @FROMDATETIME
	AND [PMPERMIT].EXPIREDATE <= @TODATETIME
	-- check if the same permitid of 'permit expired' event type does not exist in PERMITEVENTQUEUE table for current date to avoid duplicate entries
	AND NOT EXISTS (SELECT PMPERMITID FROM PERMITEVENTQUEUE WHERE  PMPERMIT.PMPERMITID = PERMITEVENTQUEUE.PMPERMITID
		AND PERMITEVENTTYPEID = 7 
		AND (PROCESSEDDATE IS NULL OR (CREATEDDATE >= @TodayStart AND CREATEDDATE <= @TodayEnd AND PROCESSEDDATE IS NOT NULL)))