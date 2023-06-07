﻿CREATE PROCEDURE [managebusiness].[USP_BLGLOBALENTITYEXTENSION_GETBYIDS]
(
    @GLOBALENTITYEXTENSIONIDLIST RecordIDs READONLY,
    @USERID AS CHAR(36) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID],
           [BLGLOBALENTITYEXTENSION].[REGISTRATIONID],
           [BLGLOBALENTITYEXTENSION].[EINNUMBER],
           [DISTRICT].[NAME],
           [BLGLOBALENTITYEXTENSION].[COMPANYNAME],
           [BLGLOBALENTITYEXTENSION].[BUSINESSPHONE],
           [BLGLOBALENTITYEXTENSION].[EMAIL],
           [BLEXTLOCATION].[NAME],
           [BLGLOBALENTITYEXTENSION].[OPENDATE],
           [BLGLOBALENTITYEXTENSION].[BLEXTCOMPANYTYPEID],
           [BLEXTCOMPANYTYPE].[NAME],
           [BLGLOBALENTITYEXTENSION].[DBA],
           [BLEXTSTATUS].[NAME],
           [BLGLOBALENTITYEXTENSION].[DESCRIPTION],
           [RECENTHISTORYBUSINESS].[RECENTHISTORYBUSINESSID],
           [RECENTHISTORYBUSINESS].[LOGGEDDATETIME],
           [RECENTHISTORYBUSINESS].[USERID],
           [USERS].[FNAME],
           [USERS].[LNAME],
           [BLGLOBALENTITYEXTENSION].[ISSUEDDATE]
    FROM [dbo].[BLGLOBALENTITYEXTENSION]
        INNER JOIN [dbo].[DISTRICT]
            ON [DISTRICT].[DISTRICTID] = [BLGLOBALENTITYEXTENSION].[DISTRICTID]
        INNER JOIN [dbo].[BLEXTLOCATION]
            ON [BLEXTLOCATION].[BLEXTLOCATIONID] = [BLGLOBALENTITYEXTENSION].[BLEXTLOCATIONID]
        INNER JOIN [dbo].[BLEXTCOMPANYTYPE]
            ON [BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [BLGLOBALENTITYEXTENSION].[BLEXTCOMPANYTYPEID]
        INNER JOIN [dbo].[BLEXTSTATUS]
            ON [BLEXTSTATUS].[BLEXTSTATUSID] = [BLGLOBALENTITYEXTENSION].[BLEXTSTATUSID]
        INNER JOIN @GLOBALENTITYEXTENSIONIDLIST GLOBALENTITYEXTENSIONIDLIST
            ON [BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] = [GLOBALENTITYEXTENSIONIDLIST].[RECORDID]
        LEFT OUTER JOIN [dbo].[RECENTHISTORYBUSINESS]
            ON [RECENTHISTORYBUSINESS].[BLGLOBALENTITYEXTENSIONID] = [BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID]
               AND RECENTHISTORYBUSINESS.USERID = @USERID
        LEFT OUTER JOIN [dbo].[USERS]
            ON [RECENTHISTORYBUSINESS].[USERID] = [USERS].[SUSERGUID]
               AND [RECENTHISTORYBUSINESS].[USERID] = @USERID
    ORDER BY [RECENTHISTORYBUSINESS].[LOGGEDDATETIME] DESC;
END;