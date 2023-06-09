﻿

CREATE PROCEDURE [dbo].[rpt_GIS_SR_Letter_Template]
@LISTID AS VARCHAR(36)
AS

SELECT GISMAILINGRECIPIENTLISTRESULT.NAME1, GISMAILINGRECIPIENTLISTRESULT.NAME2, GISMAILINGRECIPIENTLISTRESULT.ADDRESS1, 
       GISMAILINGRECIPIENTLISTRESULT.ADDRESS2, GISMAILINGRECIPIENTLISTRESULT.ADDRESS3, GISMAILINGRECIPIENTLISTRESULT.ADDRESS4, 
       COALESCE( CMCODECASE.CASENUMBER, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER, CITIZENREQUEST.REQUESTNUMBER, BLLICENSE.LICENSENUMBER ) AS CASENUMBER, 
       GISMAILINGRECIPIENTLISTRESULT.GISMAILINGRECIPIENTLISTRSULTID
FROM GISMAILINGRECIPIENTLISTRESULT 
INNER JOIN GISMAILINGRECIPIENTLIST ON GISMAILINGRECIPIENTLISTRESULT.GISMAILINGRECIPIENTLISTID = GISMAILINGRECIPIENTLIST.GISMAILINGRECIPIENTLISTID 
LEFT OUTER JOIN PLPLAN ON GISMAILINGRECIPIENTLIST.LINKEDCASE = PLPLAN.PLPLANID 
LEFT OUTER JOIN PMPERMIT ON GISMAILINGRECIPIENTLIST.LINKEDCASE = PMPERMIT.PMPERMITID
LEFT OUTER JOIN BLLICENSE ON BLLICENSE.BLLICENSEID = GISMAILINGRECIPIENTLIST.LINKEDCASE 
LEFT OUTER JOIN CMCODECASE ON CMCODECASE.CMCODECASEID = GISMAILINGRECIPIENTLIST.LINKEDCASE 
LEFT OUTER JOIN CITIZENREQUEST ON GISMAILINGRECIPIENTLIST.LINKEDCASE = CITIZENREQUEST.CITIZENREQUESTID 

WHERE GISMAILINGRECIPIENTLISTRESULT.GISMAILINGRECIPIENTLISTID = @LISTID

