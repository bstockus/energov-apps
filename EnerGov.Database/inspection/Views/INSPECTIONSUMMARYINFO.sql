﻿CREATE VIEW [inspection].[INSPECTIONSUMMARYINFO]
AS 

SELECT        
	IMINSPECTION.IMINSPECTIONID AS InspectionId, 
	IMINSPECTION.INSPECTIONNUMBER AS InspectionNumber, 
	IMINSPECTION.REQUESTEDDATE AS RequestedDate, 
	IMINSPECTION.SCHEDULEDSTARTDATE AS ScheduleDate, 
	IMINSPECTIONSTATUS.STATUSNAME AS Status, 
	IMINSPECTIONTYPE.NAME AS Type, 
	PRIMARYINSPECTOR.FirstName AS AssignedInspectorFirstName, 
	PRIMARYINSPECTOR.LastName AS AssignedInspectorLastName, 
	ISNULL(PARENTRECORDINFO.CaseNumber,IMINSPECTION.LINKNUMBER) AS ParentCaseNumber, 
	PARENTRECORDINFO.LastInspectionDate, 
	PARENTRECORDINFO.ProjectName AS ParentProject, 
	PARENTRECORDINFO.CaseStatus AS ParentStatus, 
	IMINSPECTION.IMINSPECTIONLINKID AS LinkType,
	IMINSPECTION.PARENTINSPECTIONNUMBER AS ParentInspectionNumber, 
	PARENTRECORDINFO.Description AS ParentDescription, 
	CONTACTUSER.FIRSTNAME AS ContactFirstName, 
	CONTACTUSER.LASTNAME AS ContactLastName, 
	CONTACTUSER.MIDDLENAME AS ContactMiddleName, 
	PARCEL.PARCELNUMBER AS MainParcelNumber, 
	IMINSPECTIONLINK.NAME AS LinkTypeName, 
	MAILINGADDRESS.ADDRESSLINE1 AS AddressLine1, 
	MAILINGADDRESS.ADDRESSLINE2 AS AddressLine2, 
	MAILINGADDRESS.ADDRESSLINE3 AS AddressLine3, 
	MAILINGADDRESS.CITY AS City, 
	MAILINGADDRESS.STATE AS State, 
	MAILINGADDRESS.COUNTY AS County, 
	MAILINGADDRESS.COUNTRY AS Country, 
	MAILINGADDRESS.COUNTRYTYPE AS CountryTypeId, 
	MAILINGADDRESS.PREDIRECTION AS PreDirection, 
	MAILINGADDRESS.POSTDIRECTION AS PostDirection, 
	MAILINGADDRESS.UNITORSUITE AS UnitOrSuite, 
	MAILINGADDRESS.STREETTYPE AS StreetType, 
	MAILINGADDRESS.POSTALCODE AS PostalCode, 
	MAILINGADDRESS.COMPSITE AS CompSite, 
	MAILINGADDRESS.POBOX AS PoBox, 
	MAILINGADDRESS.RURALROUTE AS RuralRoute, 
	MAILINGADDRESS.STATION AS Station, 
	MAILINGADDRESS.PROVINCE as Province, 
	PARENTRECORDINFO.SpatialCollection AS ParentSpatialCollection, 
	CONTACTUSER.BUSINESSPHONE AS ContactBusinesPhone, 
	CONTACTUSER.HOMEPHONE AS ContactPhoneHome, 
	CONTACTUSER.MOBILEPHONE AS ContactMobilePhone, 
	CONTACTUSER.OTHERPHONE AS ContactOtherPhone,
	CONTACTUSER.PREFCOMM as PreferredCommunicationId
	FROM dbo.IMINSPECTION 
	LEFT OUTER JOIN inspection.PARENTRECORDINFO ON PARENTRECORDINFO.RecordId = IMINSPECTION.LINKID AND PARENTRECORDINFO.LinkType = IMINSPECTION.IMINSPECTIONLINKID 
	LEFT OUTER JOIN dbo.IMINSPECTIONSTATUS ON IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID = IMINSPECTION.IMINSPECTIONSTATUSID 
	LEFT OUTER JOIN dbo.IMINSPECTIONTYPE ON IMINSPECTIONTYPE.IMINSPECTIONTYPEID = IMINSPECTION.IMINSPECTIONTYPEID 
	LEFT OUTER JOIN dbo.IMINSPECTIONPARCEL ON IMINSPECTIONPARCEL.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID AND IMINSPECTIONPARCEL.MAIN = 1 
	LEFT OUTER JOIN dbo.IMINSPECTIONLINK ON IMINSPECTIONLINK.IMINSPECTIONLINKID = IMINSPECTION.IMINSPECTIONLINKID 
	LEFT OUTER JOIN dbo.PARCEL ON PARCEL.PARCELID = IMINSPECTIONPARCEL.PARCELID 
	LEFT OUTER JOIN dbo.IMINSPECTIONADDRESS ON IMINSPECTIONADDRESS.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID AND IMINSPECTIONADDRESS.MAIN = 1 
	LEFT OUTER JOIN dbo.MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = IMINSPECTIONADDRESS.MAILINGADDRESSID
	OUTER APPLY (
		SELECT TOP 1 
			USERS.FNAME AS FirstName, 
			USERS.LNAME AS LastName
		FROM dbo.IMINSPECTORREF
		LEFT OUTER JOIN dbo.USERS ON USERS.SUSERGUID = IMINSPECTORREF.USERID
		WHERE IMINSPECTORREF.INSPECTIONID = IMINSPECTION.IMINSPECTIONID AND IMINSPECTORREF.BPRIMARY = 1 
		ORDER BY USERS.FNAME, USERS.LNAME
	) AS PRIMARYINSPECTOR
	OUTER APPLY
		(SELECT TOP (1) 
			IMINSPECTIONCONTACTID, 
			IMINSPECTIONID, 
			GLOBALENTITYID, 
			CONTACTTYPEID, 
			ISBILLING
			FROM  dbo.IMINSPECTIONCONTACT 
			WHERE IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID) AS INSPECTIONCONTACT 
			LEFT OUTER JOIN dbo.GLOBALENTITY AS CONTACTUSER ON CONTACTUSER.GLOBALENTITYID = INSPECTIONCONTACT.GLOBALENTITYID