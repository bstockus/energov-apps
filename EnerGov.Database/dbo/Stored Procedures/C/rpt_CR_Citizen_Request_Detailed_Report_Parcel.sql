﻿


CREATE PROCEDURE [dbo].[rpt_CR_Citizen_Request_Detailed_Report_Parcel]
@REQUESTID AS VARCHAR(36)
AS
-- Parcel
SELECT PARCEL.PARCELNUMBER, CITIZENREQUESTPARCEL.MAIN, CITIZENREQUESTPARCEL.CITIZENREQUESTID
FROM CITIZENREQUESTPARCEL 
INNER JOIN PARCEL ON CITIZENREQUESTPARCEL.PARCELID = PARCEL.PARCELID
WHERE CITIZENREQUESTPARCEL.CITIZENREQUESTID = @REQUESTID


