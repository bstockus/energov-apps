

CREATE PROCEDURE [dbo].[rpt_Time_Tracking_Permit]
@PERMITID as varchar(36)
AS
SELECT     PMPermit.PermitNumber, TimeTrackingType.Name AS TimeTrackingType, TimeTracking.LogDate, TimeTracking.Comments, TimeTracking.StartTime, 
                      TimeTracking.EndTime, TimeTracking.Hours, TimeTracking.Minutes, TimeTracking.TotalTime, TimeTracking.BillableAmount, Users.FName, Users.LName, Users.ID, 
                      TimeTracking.TimeTrackingID, TimeTracking.Billed
FROM         TimeTrackingType INNER JOIN
                      TimeTracking ON TimeTrackingType.TimeTrackingTypeID = TimeTracking.TimeTrackingTypeID INNER JOIN
                      PMPermit ON TimeTracking.PrimaryRecordID = PMPermit.PMPermitID INNER JOIN
                      Users ON TimeTracking.LogUserID = Users.sUserGUID
WHERE PMPermit.PMPermitID = @PERMITID

