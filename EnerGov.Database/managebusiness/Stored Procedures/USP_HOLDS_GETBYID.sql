﻿CREATE PROCEDURE [managebusiness].[USP_HOLDS_GETBYID]
(@GLOBALENTITYEXTENSIONID CHAR(36))
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [BLEXTHOLD].[BLGLOBALENTITYEXTENSIONID],
           [BLEXTHOLD].[HOLDSETUPID],
           [BLEXTHOLD].[BLEXTHOLDID],
           [BLEXTHOLD].[ACTIVE],
           [USERS].[FNAME],
           [USERS].[LNAME],
           [BLEXTHOLD].[CREATEDDATE]
    FROM [dbo].[BLEXTHOLD]
        INNER JOIN [dbo].[USERS]
            ON [BLEXTHOLD].[SUSERGUID] = [USERS].[SUSERGUID]
    WHERE [BLEXTHOLD].[BLGLOBALENTITYEXTENSIONID] = @GLOBALENTITYEXTENSIONID;

	EXEC [managebusiness].[USP_HOLDSETUP_GETBYID] @GLOBALENTITYEXTENSIONID
END;