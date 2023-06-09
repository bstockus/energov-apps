﻿CREATE PROCEDURE [COMMUNITYDEVELOPMENTSETUP].[USP_PERMITTYPEWORKCLASS_GETBYPARENTID]
(
	@PMPERMITTYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID],
	[dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID],
	[dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITWORKCLASSID],
	[dbo].[PMPERMITTYPEWORKCLASS].[WFTEMPLATEID],
	[dbo].[PMPERMITTYPEWORKCLASS].[CUSTOMFIELDLAYOUTID],
	[dbo].[PMPERMITTYPEWORKCLASS].[CAFEETEMPLATEID],
	[dbo].[PMPERMITTYPEWORKCLASS].[ONLINECUSTOMFIELDLAYOUTID],
	[dbo].[PMPERMITTYPEWORKCLASS].[INTERNETFLAG],
	[dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITCAPAPPLICATIONTYPEID],
	[dbo].[PMPERMITTYPEWORKCLASS].[ISCAPADDRESSREQUIRED],
	[dbo].[PMPERMITTYPEWORKCLASS].[RENEWALFEETEMPLATEID],
	[dbo].[PMPERMITTYPEWORKCLASS].[PLREVIEWITEMCAPVISIBILITYID],
	[dbo].[PMPERMITTYPEWORKCLASS].[FILESETID],
	[dbo].[PMPERMITTYPEWORKCLASS].[REQUIREALLCERTTYPE],
	[dbo].[PMPERMITTYPEWORKCLASS].[DEFAULTCASEASSIGNEDTO], 
	[dbo].[PMPERMITWORKCLASS].[NAME],
	[dbo].[WFTEMPLATE].[NAME], 
	[dbo].[PMPERMITCAPAPPLICATIONTYPE].[NAME],
	[dbo].[CUSTOMFIELDLAYOUT].[SNAME],
	[ONLINECUSTOMFIELDLAYOUT].[SNAME],
	[FEESTEMPLATE].[CAFEETEMPLATENAME],
	[dbo].[PLREVIEWITEMCAPVISIBILITY].[NAME], 
	[RENEWALFEESTEMPLATE].[CAFEETEMPLATENAME],
	[dbo].[FILESET].[NAME],
	[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME], ''),
	[dbo].[PMPERMITTYPEWORKCLASS].[VALIDATECERTIFICATIONSFORALLCONTACTS],
	[dbo].[PMPERMITTYPEWORKCLASS].[VALIDATEPROFLICENSESFORALLCONTACTS]
FROM [dbo].[PMPERMITTYPEWORKCLASS]
INNER JOIN [dbo].[PMPERMITWORKCLASS] 
	ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITWORKCLASSID]
INNER JOIN [dbo].[WFTEMPLATE] 
	ON [WFTEMPLATE].[WFTEMPLATEID] = [dbo].[PMPERMITTYPEWORKCLASS].[WFTEMPLATEID]
INNER JOIN [dbo].[PMPERMITCAPAPPLICATIONTYPE] 
	ON [PMPERMITCAPAPPLICATIONTYPE].[PMPERMITCAPAPPLICATIONTYPEID] = [dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITCAPAPPLICATIONTYPEID]
LEFT JOIN [dbo].[CUSTOMFIELDLAYOUT] 
	ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [dbo].[PMPERMITTYPEWORKCLASS].[CUSTOMFIELDLAYOUTID]
LEFT JOIN [dbo].[CUSTOMFIELDLAYOUT] [ONLINECUSTOMFIELDLAYOUT]
	ON [ONLINECUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [dbo].[PMPERMITTYPEWORKCLASS].[ONLINECUSTOMFIELDLAYOUTID]
INNER JOIN [dbo].[PLREVIEWITEMCAPVISIBILITY] 
	ON [PLREVIEWITEMCAPVISIBILITY].[PLREVIEWITEMCAPVISIBILITYID] = [dbo].[PMPERMITTYPEWORKCLASS].[PLREVIEWITEMCAPVISIBILITYID]
LEFT JOIN [dbo].[CAFEETEMPLATE] [FEESTEMPLATE]
	ON [FEESTEMPLATE].[CAFEETEMPLATEID] = [dbo].[PMPERMITTYPEWORKCLASS].[CAFEETEMPLATEID]
LEFT JOIN [dbo].[CAFEETEMPLATE] [RENEWALFEESTEMPLATE]
	ON [RENEWALFEESTEMPLATE].[CAFEETEMPLATEID] = [dbo].[PMPERMITTYPEWORKCLASS].[RENEWALFEETEMPLATEID]
LEFT JOIN [dbo].[FILESET]
	ON [FILESET].[FILESETID] = [dbo].[PMPERMITTYPEWORKCLASS].[FILESETID]
LEFT JOIN [USERS]
	ON [USERS].[SUSERGUID] = [PMPERMITTYPEWORKCLASS].[DEFAULTCASEASSIGNEDTO]
WHERE
	[dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID] = @PMPERMITTYPEID
ORDER BY [dbo].[PMPERMITWORKCLASS].[NAME]
END