﻿CREATE PROCEDURE [common].[USP_RECURRENCE_GETBYIDS]
(
	@RECURRENCEIDS RecordIDs READONLY
)
AS
BEGIN
	SELECT 
	RECURRENCEID,
	NAME,
	DAILY,
	WEEKLY,
	MONTHLY,
	YEARLY,
	DAILYRECURSEVERYNODAYS,
	DAILYRECURSEVERYWEEKDAY,
	WEEKLYRECURSEVERYNOWEEKS,
	WEEKLYRECURSONMONDAY,
	WEEKLYRECURSONTUESDAY,
	WEEKLYRECURSONWEDNESDAY,
	WEEKLYRECURSONTHURSDAY,
	WEEKLYRECURSONFRIDAY,
	WEEKLYRECURSONSATURDAY,
	WEEKLYRECURSONSUNDAY,
	MONTHLYTHERECURPATTERN,
	MONTHLYEVERYDAYDAY,
	MONTHLYEVERYNOOFMONTHS,
	MONTHLYWEEKNUMBER,
	MONTHLYWEEKDAY,
	MONTHLYTHENOOFMONTHS,
	YEARLYTHERECURPATTERN,
	YEARLYEVERYMONTH,
	YEARLYEVERYDAY,
	YEARLYTHEWEEK,
	YEARLYTHEDAYOFWEEK,
	YEARLYTHEMONTHOFYEAR,
	STARTDATE,
	RECURSUNTILDATE,
	ALLDAYEVENT,
	MAXOCCURENCES,
	EVERYXDAYS,
	EVERYXWEEKS,
	DAYOFXMONTH,
	DAYOFXYEAR,
	DUEON,
	DAILYRECURSFROM,
	DAILYRECURSEXCLUDEWEEKENDS,
	WEEKLYRECURSEVRYNOWEEKSFROM,
	WEEKLYRECURSEVRYNOWEEKS2,
	WEEKLYRECURSEVRYNOWEEKSFROM2,
	WEEKLYEXPIRESEVERYWEEK,
	WEEKLYEXPIRESEVERYWEEKFROMDATE,
	MONTHLYEVERYFROM,
	MONTHLYWEEKFROM,
	YEARLYFROMISSUEDATE,
	YEARLYEXPIRESEVERYNOYEARS,
	DUEONMONTH,
	DUEONDAYS,
	DUEONYEAR,
	DUEONTHEWEEK,
	DUEONTHEDAYOFWEEK,
	DUEONTHEMONTHOFYEAR,
	DUEONTHEYEAR,
	LICENSECYCLETYPEID,
	DUEONON,
	DUEONONTHE,
	LASTCHANGEDBY,
	LASTCHANGEDON,
	ROWVERSION
	FROM [RECURRENCE]
	INNER JOIN @RECURRENCEIDS RECURRENCEIDS 
	ON RECURRENCEIDS.RECORDID = [RECURRENCE].RECURRENCEID

END