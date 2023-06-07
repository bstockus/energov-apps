﻿

CREATE PROCEDURE [dbo].[rpt_PR_Project_Detail_Report_Parcel]
@PROJECTID AS VARCHAR(36)
AS
SELECT     PARCEL.PARCELNUMBER, PRPROJECTPARCEL.MAIN
FROM         PRPROJECTPARCEL INNER JOIN
                      PARCEL ON PRPROJECTPARCEL.PARCELID = PARCEL.PARCELID
WHERE PRPROJECTPARCEL.PRPROJECTID = @PROJECTID
