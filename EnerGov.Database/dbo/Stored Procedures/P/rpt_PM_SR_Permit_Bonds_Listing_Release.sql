﻿

CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Bonds_Listing_Release]
@BONDID AS VARCHAR(36)
AS
BEGIN
SELECT USERS.FNAME, USERS.LNAME, BONDRELEASE.CREATEDDATE, BONDRELEASE.DESCRIPTION, BONDRELEASE.AMOUNT, BONDRELEASE.BONDRELEASEID
FROM BONDRELEASE 
INNER JOIN USERS ON BONDRELEASE.CREATEDBY = USERS.SUSERGUID
WHERE BONDRELEASE.BONDID = @BONDID
END