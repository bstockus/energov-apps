﻿CREATE PROCEDURE GETMOBILEPROJECTCONTACTLIST
@projectId char(36)
AS
BEGIN
SELECT	DISTINCT PRPROJECTCONTACT.PRPROJECTCONTACTID,
				GLOBALENTITY.GLOBALENTITYID,
				GLOBALENTITY.FIRSTNAME,	
				GLOBALENTITY.LASTNAME,		
				GLOBALENTITY.GLOBALENTITYNAME AS COMPANY,
				GLOBALENTITY.BUSINESSPHONE,
				GLOBALENTITY.HOMEPHONE,
				GLOBALENTITY.MOBILEPHONE,
				GLOBALENTITY.EMAIL
		FROM	PRPROJECTCONTACT
		INNER JOIN GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = PRPROJECTCONTACT.GLOBALENTITYID
		WHERE PRPROJECTCONTACT.PRPROJECTID = @projectId	ORDER BY GLOBALENTITY.FIRSTNAME		
END
