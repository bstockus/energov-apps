


CREATE PROCEDURE [dbo].[rpt_CR_Requests_Deadline_Date_Reports]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT CitizenRequest.RequestNumber, CitizenRequest.Description, CitizenRequest.DateFiled, CitizenRequest.CompDeadline AS DeadlineDate, 
       CitizenRequest.CompComplete AS CompleteDate, CitizenRequest.Emergency, CitizenRequestType.Name AS RequestType, District.Name AS District, 
       CitizenRequestStatus.Status, CitizenRequestSource.Name AS Source, CitizenRequest.CitizenRequestID
FROM CitizenRequest 
INNER JOIN CitizenRequestType ON CitizenRequest.CitizenRequestTypeID = CitizenRequestType.CitizenRequestTypeID 
INNER JOIN CitizenRequestStatus ON CitizenRequest.CitizenRequestStatusID = CitizenRequestStatus.CitizenRequestStatusID 
LEFT OUTER JOIN CitizenRequestSource ON CitizenRequest.CitizenRequestSourceID = CitizenRequestSource.CitizenRequestSourceID 
LEFT OUTER JOIN District ON CitizenRequest.DistrictID = District.DistrictID
WHERE CITIZENREQUEST.DATEFILED BETWEEN @STARTDATE AND @ENDDATE


