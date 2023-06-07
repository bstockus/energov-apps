
/****************************************************************
*******************  BEGIN STORED PROCEDURE 2  ******************
****************************************************************/
/****************************************
Report Name	:	Avery_5160_Business_License_Company_Labels
Server		:	DULDPDATASVCS
Database	:	USE [EnerGov_PocomokeCity]
Work Log   	:	Sep 7, 2017 - MLB - Initial development
Description	:	Added as a parameter list to the report.
****************************************/

CREATE PROCEDURE [rpt_BL_SR_Avery_5160_Business_License_Company_Labels_Types]

AS
BEGIN

SELECT DISTINCT
	BLLICENSETYPEID
	, NAME LICENSETYPE
FROM BLLICENSETYPE

END
