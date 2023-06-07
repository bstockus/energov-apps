

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Requests]
@GLOBALENTITYID as varchar(36)
AS
SELECT     CitizenRequestCallerXRef.CitizenRequestID, CitizenRequest.RequestNumber, CitizenRequestType.Name AS RequestType, 
                      CitizenRequestStatus.Status AS RequestStatus, CitizenRequest.DateFiled, CitizenRequest.CompDeadline, CitizenRequest.CompComplete
FROM         CitizenRequest INNER JOIN
                      CitizenRequestType ON CitizenRequest.CitizenRequestTypeID = CitizenRequestType.CitizenRequestTypeID INNER JOIN
                      CitizenRequestStatus ON CitizenRequest.CitizenRequestStatusID = CitizenRequestStatus.CitizenRequestStatusID INNER JOIN
                      CitizenRequestCallerXRef ON CitizenRequest.CitizenRequestID = CitizenRequestCallerXRef.CitizenRequestID
WHERE CitizenRequestCallerXRef.GlobalEntityID = @GLOBALENTITYID

