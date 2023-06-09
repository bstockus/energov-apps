﻿CREATE FUNCTION [reviewcoordinator].[UFN_HAS_ACTIVE_STOP_HOLDS]
(
	@ENTITYID CHAR(36),
	@ALLOWHOLDOVERRIDE BIT
)
RETURNS BIT
AS
BEGIN
	DECLARE @hasStopHolds BIT
	set @hasStopHolds = 0
	if (EXISTS 
		(SELECT PMPERMITHOLD.PMPERMITHOLDID ID
			FROM PMPERMITHOLD
			LEFT OUTER JOIN HOLDTYPESETUPS ON HOLDTYPESETUPS.HOLDSETUPID = PMPERMITHOLD.HOLDSETUPID
			WHERE PMPERMITHOLD.PMPERMITID = @ENTITYID AND PMPERMITHOLD.ACTIVE = 1 AND
			HOLDTYPESETUPS.HOLDTYPEID = 2 AND
			ISNULL(HOLDTYPESETUPS.PERMITWFSUBREVIEW, 0) = 1 AND  
			NOT (@ALLOWHOLDOVERRIDE = 1 AND ISNULL(HOLDTYPESETUPS.ALLOWHOLDOVERRIDES, 0) = 1)
			UNION ALL			
			SELECT PLPLANHOLD.PLPLANHOLDID ID
			FROM PLPLANHOLD
			LEFT OUTER JOIN HOLDTYPESETUPS ON HOLDTYPESETUPS.HOLDSETUPID = PLPLANHOLD.HOLDSETUPID
			WHERE PLPLANHOLD.PLPLANID = @ENTITYID AND PLPLANHOLD.ACTIVE = 1 AND
			HOLDTYPESETUPS.HOLDTYPEID = 2 AND 
			ISNULL(HOLDTYPESETUPS.PLANWFSUBREVIVIEW, 0) = 1 AND 
			NOT (@ALLOWHOLDOVERRIDE = 1 AND ISNULL(HOLDTYPESETUPS.ALLOWHOLDOVERRIDES, 0) = 1)))
		BEGIN
			set @hasStopHolds = 1
		END
	return @hasStopHolds
END