﻿CREATE PROCEDURE [globalsetup].[USP_IMINSPECTIONTYPE_GETBYID]
(
	@IMINSPECTIONTYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID],
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEGROUPID],
	[dbo].[IMINSPECTIONTYPE].[DEPARTMENTID],
	[dbo].[IMINSPECTIONTYPE].[NAME],
	[dbo].[IMINSPECTIONTYPE].[DESCRIPTION],
	[dbo].[IMINSPECTIONTYPE].[IVRNUMBER],
	[dbo].[IMINSPECTIONTYPE].[ESTIMATEDMINUTES],
	[dbo].[IMINSPECTIONTYPE].[PRIORITYNUMBER],
	[dbo].[IMINSPECTIONTYPE].[GCUSTOMFIELDLAYOUTS],
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONSTATUSID],
	[dbo].[IMINSPECTIONTYPE].[PREFIX],
	[dbo].[IMINSPECTIONTYPE].[MOBILEGOVDEFAULTRPTID],
	[dbo].[IMINSPECTIONTYPE].[GISZONEMAPPINGID],
	[dbo].[IMINSPECTIONTYPE].[EXTEND_DATE],
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONSCHEDULETYPEID],
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONGISASSIGNMENTID],
	[dbo].[IMINSPECTIONTYPE].[GONLINECUSTOMFIELDLAYOUTS],
	[dbo].[IMINSPECTIONTYPE].[CAFEETEMPLATEID],
	[dbo].[IMINSPECTIONTYPE].[COPYCHECKLISTINFO],
	[dbo].[IMINSPECTIONTYPE].[ISLIMITEXEMPT],
	[dbo].[IMINSPECTIONTYPE].[REINSPECTWAITTIME],
	[dbo].[IMINSPECTIONTYPE].[ENTITYPROPERTY],
	[dbo].[IMINSPECTIONTYPE].[PROPERTYFRIENDLYNAME],
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONLINKID],
	[dbo].[IMINSPECTIONTYPE].[ISNONCOMPLIANCETRACKED],
	[dbo].[IMINSPECTIONTYPE].[ALLOWCAPNONCOMPLANCESUBMISSION],
	[dbo].[IMINSPECTIONTYPE].[DESCRIPTION_SPANISH],
	[dbo].[IMINSPECTIONTYPE].[ALLOWPUBLICREQUESTS],
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONCALENDARID],
	[dbo].[IMINSPECTIONTYPE].[ISALLOWCODECASEFROMMOBILE],
	[dbo].[IMINSPECTIONTYPE].[RECURRENCEID],
	[dbo].[IMINSPECTIONTYPE].[LASTCHANGEDBY],
	[dbo].[IMINSPECTIONTYPE].[LASTCHANGEDON],
	[dbo].[IMINSPECTIONTYPE].[ROWVERSION],
	[dbo].[RECURRENCE].[NAME] AS [RECURRENCENAME]

FROM [dbo].[IMINSPECTIONTYPE]
LEFT JOIN [dbo].[RECURRENCE] ON [dbo].[IMINSPECTIONTYPE].[RECURRENCEID] = [dbo].[RECURRENCE].[RECURRENCEID]
WHERE
	[IMINSPECTIONTYPEID] = @IMINSPECTIONTYPEID  

	EXEC [globalsetup].[USP_IMINSPECTIONTYPECHKLSTXREF_GETBYPARENTID] @IMINSPECTIONTYPEID
END