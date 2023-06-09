﻿CREATE PROCEDURE [dbo].[GETCASECONTACTLIST]
-- Add the parameters for the stored procedure here
@CaseID char(36),
@ModuleID int
AS
BEGIN
	IF @ModuleID = 1
	BEGIN	
		SELECT	DISTINCT PLPLANCONTACT.PLPLANCONTACTID AS CASECONTACTID,
				GLOBALENTITY.FIRSTNAME,	
				GLOBALENTITY.LASTNAME,	
				GLOBALENTITY.LASTNAME,	
				GLOBALENTITY.GLOBALENTITYNAME AS COMPANY,
				GLOBALENTITY.BUSINESSPHONE,
				GLOBALENTITY.EMAIL,
				LANDMANAGEMENTCONTACTTYPE.NAME AS CONTACTTYPE
		FROM	PLPLANCONTACT
		INNER JOIN GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = PLPLANCONTACT.GLOBALENTITYID
		INNER JOIN LANDMANAGEMENTCONTACTTYPE ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = PLPLANCONTACT.LANDMANAGEMENTCONTACTTYPEID
		WHERE PLPLANCONTACT.PLPLANID = @CaseID				
	END
	ELSE IF @ModuleID = 2
	BEGIN
		SELECT	DISTINCT PMPERMITCONTACT.PMPERMITCONTACTID AS CASECONTACTID,
				GLOBALENTITY.FIRSTNAME,	
				GLOBALENTITY.LASTNAME,	
				GLOBALENTITY.LASTNAME,	
				GLOBALENTITY.GLOBALENTITYNAME AS COMPANY,
				GLOBALENTITY.BUSINESSPHONE,
				GLOBALENTITY.EMAIL,
				LANDMANAGEMENTCONTACTTYPE.NAME AS CONTACTTYPE
		FROM	PMPERMITCONTACT
		INNER JOIN GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = PMPERMITCONTACT.GLOBALENTITYID
		INNER JOIN LANDMANAGEMENTCONTACTTYPE ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = PMPERMITCONTACT.LANDMANAGEMENTCONTACTTYPEID
		WHERE PMPERMITCONTACT.PMPERMITID = @CaseID
	END	
END