CREATE VIEW [dbo].[InspectionSummaryInfo]
AS
SELECT        ins.IMINSPECTIONID AS InspectionId, ins.INSPECTIONNUMBER AS InspectionNumber, ins.REQUESTEDDATE AS RequestedDate, ins.SCHEDULEDSTARTDATE AS ScheduleDate, insstatus.STATUSNAME AS Status, 
                         instype.NAME AS Type, u.FNAME AS AssignedInspectorFirstName, u.LNAME AS AssignedInspectorLastName, pr.CaseNumber AS ParentCaseNumber, pr.LastInspectionDate, pr.ProjectName AS ParentProject, 
                         pr.CaseStatus AS ParentStatus, ins.PARENTINSPECTIONNUMBER AS ParentInspectionNumber, pr.Description AS ParentDescription, contactuser.FIRSTNAME AS ContactFirstName, contactuser.LASTNAME AS ContactLastName, 
                         contactuser.MIDDLENAME AS ContactMiddleName, parcel.PARCELNUMBER AS MainParcelNumber, inslink.NAME AS LinkTypeName, address.ADDRESSLINE1 AS AddressLine1, address.ADDRESSLINE2 AS AddressLine2, 
                         address.ADDRESSLINE3 AS AddressLine3, address.CITY AS City, address.STATE AS State, address.COUNTY AS County, address.COUNTRY AS Country, address.COUNTRYTYPE AS CountryTypeId, 
                         address.PREDIRECTION AS PreDirection, address.POSTDIRECTION AS PostDirection, address.UNITORSUITE AS UnitOrSuite, address.STREETTYPE AS StreetType, address.POSTALCODE AS PostalCode, 
                         address.COMPSITE AS CompSite, address.POBOX AS PoBox, address.RURALROUTE AS RuralRoute, address.STATION AS Station, address.PROVINCE as Province, pr.SpatialCollection AS ParentSpatialCollection, 
                         contactuser.BUSINESSPHONE AS ContactBusinesPhone, contactuser.HOMEPHONE AS ContactPhoneHome, contactuser.MOBILEPHONE AS ContactMobilePhone, contactuser.OTHERPHONE AS ContactOtherPhone,
						 contactuser.PREFCOMM as PreferredCommunicationId
FROM            dbo.IMINSPECTION AS ins LEFT OUTER JOIN
                         dbo.ParentRecordInfo AS pr ON pr.RecordId = ins.LINKID AND pr.LinkType = ins.IMINSPECTIONLINKID LEFT OUTER JOIN
                         dbo.IMINSPECTIONSTATUS AS insstatus ON insstatus.IMINSPECTIONSTATUSID = ins.IMINSPECTIONSTATUSID LEFT OUTER JOIN
                         dbo.IMINSPECTIONTYPE AS instype ON instype.IMINSPECTIONTYPEID = ins.IMINSPECTIONTYPEID LEFT OUTER JOIN
                         dbo.IMINSPECTORREF AS insinspref ON insinspref.INSPECTIONID = ins.IMINSPECTIONID AND insinspref.BPRIMARY = 1 LEFT OUTER JOIN
                         dbo.USERS AS u ON u.SUSERGUID = insinspref.USERID LEFT OUTER JOIN
                         dbo.IMINSPECTIONPARCEL AS insparcel ON insparcel.IMINSPECTIONID = ins.IMINSPECTIONID AND insparcel.MAIN = 1 LEFT OUTER JOIN
                         dbo.IMINSPECTIONLINK AS inslink ON inslink.IMINSPECTIONLINKID = ins.IMINSPECTIONLINKID LEFT OUTER JOIN
                         dbo.PARCEL AS parcel ON parcel.PARCELID = insparcel.PARCELID LEFT OUTER JOIN
                         dbo.IMINSPECTIONADDRESS AS insaddress ON insaddress.IMINSPECTIONID = ins.IMINSPECTIONID AND insaddress.MAIN = 1 LEFT OUTER JOIN
                         dbo.MAILINGADDRESS AS address ON address.MAILINGADDRESSID = insaddress.MAILINGADDRESSID outer apply
                             (SELECT        TOP (1) IMINSPECTIONCONTACTID, IMINSPECTIONID, GLOBALENTITYID, CONTACTTYPEID, ISBILLING
                               FROM            dbo.IMINSPECTIONCONTACT where iminspectionid = ins.iminspectionid) AS inscont LEFT OUTER JOIN
                         dbo.GLOBALENTITY AS contactuser ON contactuser.GLOBALENTITYID = inscont.GLOBALENTITYID