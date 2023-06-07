﻿
/****** Object:  StoredProcedure [dbo].[rpt_IP_SR_Impact_Case_Detail_Report_Parcel]    Script Date: 01/08/2014 15:58:53 ******/
CREATE PROCEDURE [dbo].[rpt_IP_SR_Impact_Case_Detail_Report_Parcel]
@IPCASEID AS VARCHAR(36)
AS

SELECT	PARCEL.PARCELNUMBER, IPCASEPARCEL.MAIN, IPCASEPARCEL.PARCELID

FROM	IPCASEPARCEL 
		INNER JOIN PARCEL ON IPCASEPARCEL.PARCELID = PARCEL.PARCELID

WHERE IPCASEPARCEL.IPCASEID = @IPCASEID
