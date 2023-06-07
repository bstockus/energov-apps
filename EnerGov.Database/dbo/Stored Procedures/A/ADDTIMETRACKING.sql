
CREATE PROCEDURE [dbo].[ADDTIMETRACKING]
-- Add the parameters for the stored procedure here
@TimeTrackingID char(36),
@TimeTrackingTypeID char(36),
@PrimaryRecordID char(36),
@SecondaryRecordID char(36),
@SecondaryRecordTypeID int,
@LogDate datetime,
@LogUserID char(36),
@Comments nvarchar(max),
@StartTime datetime,
@EndTime datetime,
@Hours int,
@Minutes int,
@TotalTime decimal(4,2),
@BillableAmount money,
@Billed bit,
@BillingRateID char(36)
AS
BEGIN		
	INSERT INTO TIMETRACKING 	
	(
	TIMETRACKINGID,
	TIMETRACKINGTYPEID,
	PRIMARYRECORDID,
	SECONDARYRECORDID,
	SECONDARYRECORDTYPEID,
	LOGDATE,
	LOGUSERID,
	COMMENTS,
	STARTTIME,
	ENDTIME,
	HOURS,
	MINUTES,
	TOTALTIME,
	BILLABLEAMOUNT,
	BILLED,
	BILLINGRATEID
	)
	VALUES(
	@TimeTrackingID,
	@TimeTrackingTypeID,
	@PrimaryRecordID,
	@SecondaryRecordID,
	@SecondaryRecordTypeID,
	@LogDate,
	@LogUserID,
	@Comments,
	@StartTime,
	@EndTime,
	@Hours,
	@Minutes,
	@TotalTime,
	@BillableAmount,
	@Billed,
	@BillingRateID)		
END
