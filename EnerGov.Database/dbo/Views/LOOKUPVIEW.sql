﻿CREATE VIEW [dbo].[LOOKUPVIEW]
AS 
SELECT 
	AMASSETTYPE.AMASSETTYPEID AS UNIQUEID,
	AMASSETTYPE.[NAME] AS STRINGVALUE,
	'AMASSETTYPE' AS TABLENAME
	FROM dbo.AMASSETTYPE
UNION ALL
SELECT
	AMCONTACTTYPE.AMCONTACTTYPEID AS UNIQUEID,
	AMCONTACTTYPE.NAME AS STRINGVALUE,
	'AMCONTACTTYPE' AS TABLENAME
	FROM dbo.AMCONTACTTYPE
UNION ALL
SELECT 
	AMEQUIPMENT.AMEQUIPMENTID AS UNIQUEID,
	AMEQUIPMENT.[NAME] AS STRINGVALUE,
	'AMEQUIPMENT' AS TABLENAME
	FROM dbo.AMEQUIPMENT
UNION ALL
SELECT 
	AMEQUIPMENTSTATUS.AMEQUIPMENTSTATUSID AS UNIQUEID,
	AMEQUIPMENTSTATUS.[NAME] AS STRINGVALUE,
	'AMEQUIPMENTSTATUS' AS TABLENAME
	FROM dbo.AMEQUIPMENTSTATUS
UNION ALL
SELECT 
	AMEQUIPMENTTYPE.AMEQUIPMENTTYPEID AS UNIQUEID,
	AMEQUIPMENTTYPE.[NAME] AS STRINGVALUE,
	'AMEQUIPMENTTYPE' AS TABLENAME
	FROM dbo.AMEQUIPMENTTYPE
UNION ALL
SELECT 
	AMLOCATION.AMLOCATIONID AS UNIQUEID,
	AMLOCATION.[NAME] AS STRINGVALUE,
	'AMLOCATION' AS TABLENAME
	FROM dbo.AMLOCATION
UNION ALL
SELECT 
	AMRESOURCE.AMRESOURCEID AS UNIQUEID,
	COALESCE((CONTACT.LASTNAME + ', ' + CONTACT.FIRSTNAME),COMPANY.COMPANYNAME,UNITOFMEASURE.[NAME]) AS STRINGVALUE,
	'AMRESOURCE' AS TABLENAME
	FROM dbo.AMRESOURCE	
	LEFT OUTER JOIN UNITOFMEASURE ON UNITOFMEASURE.UNITOFMEASUREID = AMRESOURCE.RATEUOM
	LEFT OUTER JOIN CONTACT ON CONTACT.CONTACTID = AMRESOURCE.CONTACTID
	LEFT OUTER JOIN COMPANY ON COMPANY.COMPANYID = AMRESOURCE.COMPANYID
UNION ALL
SELECT 
	AMRESOURCESKILL.AMRESOURCESKILLID AS UNIQUEID,
	AMRESOURCESKILL.[NAME] AS STRINGVALUE,
	'AMRESOURCESKILL' AS TABLENAME
	FROM dbo.AMRESOURCESKILL		
UNION ALL
SELECT 
	AMTASKTYPE.AMTASKTYPEID AS UNIQUEID,
	AMTASKTYPE.[NAME] AS STRINGVALUE,
	'AMTASKTYPE' AS TABLENAME
	FROM dbo.AMTASKTYPE		
UNION ALL
SELECT 
	AMWORKORDER.AMWORKORDERID AS UNIQUEID,
	AMWORKORDER.WORKORDERNO AS STRINGVALUE,
	'AMWORKORDER' AS TABLENAME
	FROM dbo.AMWORKORDER		
UNION ALL
SELECT 
	AMWORKORDERCLASSIFICATIONID AS UNIQUEID,
	NAME AS STRINGVALUE,
	'AMWORKORDERCLASSIFICATION' AS TABLENAME
	FROM dbo.AMWORKORDERCLASSIFICATION
UNION ALL
SELECT 
	AMWORKORDERPRIORITY.AMWORKORDERPRIORITYID AS UNIQUEID,
	AMWORKORDERPRIORITY.[NAME] AS STRINGVALUE,
	'AMWORKORDERPRIORITY' AS TABLENAME
	FROM dbo.AMWORKORDERPRIORITY		
UNION ALL
SELECT 
	AMWORKORDERSTATUS.AMWORKORDERSTATUSID AS UNIQUEID,
	AMWORKORDERSTATUS.[NAME] AS STRINGVALUE,
	'AMWORKORDERSTATUS' AS TABLENAME
	FROM dbo.AMWORKORDERSTATUS		
UNION ALL
SELECT 
	AMWORKORDERTYPE.AMWORKORDERTYPEID AS UNIQUEID,
	AMWORKORDERTYPE.[NAME] AS STRINGVALUE,
	'AMWORKORDERTYPE' AS TABLENAME
	FROM dbo.AMWORKORDERTYPE		
UNION ALL
SELECT 
	CAFEESCHEDULE.CAFEESCHEDULEID AS UNIQUEID,
	CAFEESCHEDULE.[NAME] AS STRINGVALUE,
	'CAFEESCHEDULE' AS TABLENAME
	FROM dbo.CAFEESCHEDULE	
UNION ALL
SELECT 
	CASCHEDULE.CASCHEDULEID AS UNIQUEID,
	CASCHEDULE.[NAME] AS STRINGVALUE,
	'CASCHEDULE' AS TABLENAME
	FROM dbo.CASCHEDULE		
UNION ALL
SELECT 
	CITIZENREQUESTPRIORITY.CITIZENREQUESTPRIORITYID AS UNIQUEID,
	CITIZENREQUESTPRIORITY.[NAME] AS STRINGVALUE,
	'CITIZENREQUESTPRIORITY' AS TABLENAME
	FROM dbo.CITIZENREQUESTPRIORITY		
UNION ALL
SELECT 
	CITIZENREQUESTSTATUS.CITIZENREQUESTSTATUSID AS UNIQUEID,
	CITIZENREQUESTSTATUS.STATUS AS STRINGVALUE,
	'CITIZENREQUESTSTATUS' AS TABLENAME
	FROM dbo.CITIZENREQUESTSTATUS		
UNION ALL
SELECT 
	CITIZENREQUESTTYPE.CITIZENREQUESTTYPEID AS UNIQUEID,
	CITIZENREQUESTTYPE.[NAME] AS STRINGVALUE,
	'CITIZENREQUESTTYPE' AS TABLENAME
	FROM dbo.CITIZENREQUESTTYPE		
UNION ALL
SELECT 
	CMCASETYPE.CMCASETYPEID AS UNIQUEID,
	CMCASETYPE.NAME AS STRINGVALUE,
	'CMCASETYPE' AS TABLENAME
	FROM dbo.CMCASETYPE	
UNION ALL
SELECT 
	CMCITATIONSTATUS.CMCITATIONSTATUSID AS UNIQUEID,
	CMCITATIONSTATUS.NAME AS STRINGVALUE,
	'CMCITATIONSTATUS' AS TABLENAME
	FROM dbo.CMCITATIONSTATUS		
UNION ALL
SELECT 
	CMCITATIONTYPE.CMCITATIONTYPEID AS UNIQUEID,
	CMCITATIONTYPE.NAME AS STRINGVALUE,
	'CMCITATIONTYPE' AS TABLENAME
	FROM dbo.CMCITATIONTYPE
UNION ALL
SELECT 
	CMCODECATEGORY.CMCODECATEGORYID AS UNIQUEID,
	CMCODECATEGORY.NAME AS STRINGVALUE,
	'CMCODECATEGORY' AS TABLENAME
	FROM dbo.CMCODECATEGORY		
UNION ALL
SELECT 
	CMCODECASECONTACTTYPE.CMCODECASECONTACTTYPEID AS UNIQUEID,
	CMCODECASECONTACTTYPE.NAME AS STRINGVALUE,
	'CMCODECASECONTACTTYPE' AS TABLENAME
	FROM dbo.CMCODECASECONTACTTYPE	
UNION ALL
SELECT 
	CMCODECASESTATUS.CMCODECASESTATUSID AS UNIQUEID,
	CMCODECASESTATUS.NAME AS STRINGVALUE,
	'CMCODECASESTATUS' AS TABLENAME
	FROM dbo.CMCODECASESTATUS
	UNION ALL
SELECT 
	CMCOURTSTATUS.CMCOURTSTATUSID AS UNIQUEID,
	CMCOURTSTATUS.NAME AS STRINGVALUE,
	'CMCOURTSTATUS' AS TABLENAME
	FROM dbo.CMCOURTSTATUS
UNION ALL
SELECT 
	CMVERDICT.CMVERDICTID AS UNIQUEID,
	CMVERDICT.NAME AS STRINGVALUE,
	'CMVERDICT' AS TABLENAME
	FROM dbo.CMVERDICT
UNION ALL
SELECT 
	COMPANY.COMPANYID AS UNIQUEID,
	COMPANY.COMPANYNAME AS STRINGVALUE,
	'COMPANY' AS TABLENAME
	FROM dbo.COMPANY	
UNION ALL
SELECT 
	CONTACT.CONTACTID AS UNIQUEID,
	CONTACT.LASTNAME + ', ' + CONTACT.FIRSTNAME AS STRINGVALUE,
	'CONTACT' AS TABLENAME
	FROM dbo.CONTACT	
UNION ALL
SELECT 
	CONTACTTYPE.CONTACTTYPEID AS UNIQUEID,
	CONTACTTYPE.NAME AS STRINGVALUE,
	'CONTACTTYPE' AS TABLENAME
	FROM dbo.CONTACTTYPE	
UNION ALL
SELECT 
	CUSTOMFIELDLAYOUT.GCUSTOMFIELDLAYOUTS AS UNIQUEID,
	CUSTOMFIELDLAYOUT.SNAME AS STRINGVALUE,
	'CUSTOMFIELDLAYOUT' AS TABLENAME
	FROM dbo.CUSTOMFIELDLAYOUT	
UNION ALL
SELECT 
	DEPARTMENT.DEPARTMENTID AS UNIQUEID,
	DEPARTMENT.NAME AS STRINGVALUE,
	'DEPARTMENT' AS TABLENAME
	FROM dbo.DEPARTMENT	
UNION ALL
SELECT 
	DISTRICT.DISTRICTID AS UNIQUEID,
	DISTRICT.NAME AS STRINGVALUE,
	'DISTRICT' AS TABLENAME
	FROM dbo.DISTRICT	
UNION ALL
SELECT 
	ERPROJECTFILECATEGORY.ERPROJECTFILECATEGORYID AS UNIQUEID,
	ERPROJECTFILECATEGORY.NAME AS STRINGVALUE,
	'ERPROJECTFILECATEGORY' AS TABLENAME
	FROM dbo.ERPROJECTFILECATEGORY	
UNION ALL	
SELECT 
	ERPROJECTFILESTATUS.ERPROJECTFILESTATUSID AS UNIQUEID,
	ERPROJECTFILESTATUS.NAME AS STRINGVALUE,
	'ERPROJECTFILESTATUS' AS TABLENAME
	FROM dbo.ERPROJECTFILESTATUS	
UNION ALL
SELECT 
	ERPROJECTSTATUS.ERPROJECTSTATUSID AS UNIQUEID,
	ERPROJECTSTATUS.NAME AS STRINGVALUE,
	'ERPROJECTSTATUS' AS TABLENAME
	FROM dbo.ERPROJECTSTATUS
UNION ALL
SELECT 
	EXAMLOCATION.EXAMLOCATIONID AS UNIQUEID,
	EXAMLOCATION.NAME AS STRINGVALUE,
	'EXAMLOCATION' AS TABLENAME
	FROM dbo.EXAMLOCATION	
UNION ALL
SELECT 
	EXAMSTATUS.EXAMSTATUSID AS UNIQUEID,
	EXAMSTATUS.NAME AS STRINGVALUE,
	'EXAMSTATUS' AS TABLENAME
	FROM dbo.EXAMSTATUS
UNION ALL
SELECT 
	EXAMTIMESLOT.EXAMTIMESLOTID AS UNIQUEID,
	EXAMTIMESLOT.NAME AS STRINGVALUE,
	'EXAMTIMESLOT' AS TABLENAME
	FROM dbo.EXAMTIMESLOT		
UNION ALL
SELECT 
	EXAMTYPE.EXAMTYPEID AS UNIQUEID,
	EXAMTYPE.NAME AS STRINGVALUE,
	'EXAMTYPE' AS TABLENAME
	FROM dbo.EXAMTYPE				
UNION ALL
SELECT 
	EXAMVERSION.EXAMVERSIONID AS UNIQUEID,
	EXAMVERSION.NAME AS STRINGVALUE,
	'EXAMVERSION' AS TABLENAME
	FROM dbo.EXAMVERSION	
UNION ALL
SELECT 
	GEORULE.GEORULEID AS UNIQUEID,
	GEORULE.RULENAME AS STRINGVALUE,
	'GEORULE' AS TABLENAME
	FROM dbo.GEORULE	
UNION ALL
SELECT 
	CAST(GEORULECOMPARER.GEORULECOMPARERID AS CHAR(36)) AS UNIQUEID,
	GEORULECOMPARER.COMPARERNAME AS STRINGVALUE,
	'GEORULECOMPARER' AS TABLENAME
	FROM dbo.GEORULECOMPARER	
UNION ALL
SELECT 
	GEORULEENTITY.GEORULEENTITYID AS UNIQUEID,
	GEORULEENTITY.GEORYLEENTITYFRIENDLYNAME AS STRINGVALUE,
	'GEORULEENTITY' AS TABLENAME
	FROM dbo.GEORULEENTITY	
UNION ALL
SELECT 
	GEORULEPROCESSTYPE.GEORULEPROCESSTYPEID AS UNIQUEID,
	GEORULEPROCESSTYPE.GEORULEPROCESSTYPENAME AS STRINGVALUE,
	'GEORULEPROCESSTYPE' AS TABLENAME
	FROM dbo.GEORULEPROCESSTYPE	
UNION ALL
SELECT 
	GLACCOUNT.GLACCOUNTID AS UNIQUEID,
	GLACCOUNT.NAME AS STRINGVALUE,
	'GLACCOUNT' AS TABLENAME
	FROM dbo.GLACCOUNT	
UNION ALL
SELECT 
	GLOBALENTITYTYPE.GLOBALENTITYTYPEID AS UNIQUEID,
	GLOBALENTITYTYPE.NAME AS STRINGVALUE,
	'GLOBALENTITYTYPE' AS TABLENAME
	FROM dbo.GLOBALENTITYTYPE		
UNION ALL
SELECT 
	GLOBALENTITYACCOUNTTYPE.GLOBALENTITYACCOUNTTYPEID AS UNIQUEID,
	GLOBALENTITYACCOUNTTYPE.TYPENAME AS STRINGVALUE,
	'GLOBALENTITYACCOUNTTYPE' AS TABLENAME
	FROM dbo.GLOBALENTITYACCOUNTTYPE		
UNION ALL
SELECT 
	HEARINGSTATUS.HEARINGSTATUSID AS UNIQUEID,
	HEARINGSTATUS.NAME AS STRINGVALUE,
	'HEARINGSTATUS' AS TABLENAME
	FROM dbo.HEARINGSTATUS			
UNION ALL
SELECT 
	HEARINGTYPE.HEARINGTYPEID AS UNIQUEID,
	HEARINGTYPE.NAME AS STRINGVALUE,
	'HEARINGTYPE' AS TABLENAME
	FROM dbo.HEARINGTYPE		
UNION ALL
SELECT 
	IMINSPECTIONCASETYPE.IMINSPECTIONCASETYPEID AS UNIQUEID,
	IMINSPECTIONCASETYPE.NAME AS STRINGVALUE,
	'IMINSPECTIONCASETYPE' AS TABLENAME
	FROM dbo.IMINSPECTIONCASETYPE
UNION ALL
SELECT 
	IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID AS UNIQUEID,
	IMINSPECTIONSTATUS.STATUSNAME AS STRINGVALUE,
	'IMINSPECTIONSTATUS' AS TABLENAME
	FROM dbo.IMINSPECTIONSTATUS			
UNION ALL
SELECT 
	IMINSPECTIONTYPE.IMINSPECTIONTYPEID AS UNIQUEID,
	IMINSPECTIONTYPE.NAME AS STRINGVALUE,
	'IMINSPECTIONTYPE' AS TABLENAME
	FROM dbo.IMINSPECTIONTYPE	
UNION ALL
SELECT 
	IMINSPECTIONTYPEGROUP.IMINSPECTIONTYPEGROUPID AS UNIQUEID,
	IMINSPECTIONTYPEGROUP.NAME AS STRINGVALUE,
	'IMINSPECTIONTYPEGROUP' AS TABLENAME
	FROM dbo.IMINSPECTIONTYPEGROUP	
UNION ALL
SELECT 
	IMINSPECTORTYPE.IMINSPECTORTYPEID AS UNIQUEID,
	IMINSPECTORTYPE.SNAME AS STRINGVALUE,
	'IMINSPECTORTYPE' AS TABLENAME
	FROM dbo.IMINSPECTORTYPE
UNION ALL
SELECT 
	IMINSPECTIONZONE.IMINSPECTIONZONEID AS UNIQUEID,
	IMINSPECTIONZONE.NAME AS STRINGVALUE,
	'IMINSPECTIONZONE' AS TABLENAME
	FROM dbo.IMINSPECTIONZONE
UNION ALL
SELECT 
	IMSCHEDULEDTIMEGROUP.IMSCHEDULEDTIMEGROUPID AS UNIQUEID,
	IMSCHEDULEDTIMEGROUP.NAME AS STRINGVALUE,
	'IMSCHEDULEDTIMEGROUP' AS TABLENAME
	FROM dbo.IMSCHEDULEDTIMEGROUP
UNION ALL
SELECT 
	INBINTYPE.INBINTYPEID AS UNIQUEID,
	INBINTYPE.NAME AS STRINGVALUE,
	'INBINTYPE' AS TABLENAME
	FROM dbo.INBINTYPE	
UNION ALL
SELECT 
	INSTOREITEMSTATUS.INSTOREITEMSTATUSID AS UNIQUEID,
	INSTOREITEMSTATUS.NAME AS STRINGVALUE,
	'INSTOREITEMSTATUS' AS TABLENAME
	FROM dbo.INSTOREITEMSTATUS		
UNION ALL
SELECT 
	ITEMSTATUS.ITEMSTATUSID AS UNIQUEID,
	ITEMSTATUS.NAME AS STRINGVALUE,
	'ITEMSTATUS' AS TABLENAME
	FROM dbo.ITEMSTATUS		
UNION ALL
SELECT 
	ITEMTYPE.ITEMTYPEID AS UNIQUEID,
	ITEMTYPE.NAME AS STRINGVALUE,
	'ITEMTYPE' AS TABLENAME
	FROM dbo.ITEMTYPE		
UNION ALL
SELECT 
	JURISDICTION.JURISDICTIONID AS UNIQUEID,
	JURISDICTION.[NAME] AS STRINGVALUE,
	'JURISDICTION' AS TABLENAME
	FROM dbo.JURISDICTION	
UNION ALL
SELECT 
	LICENSECYCLERECURRENCESETUP.LICENSECYCLERECURRENCESETUPID AS UNIQUEID,
	LICENSECYCLERECURRENCESETUP.NAME AS STRINGVALUE,
	'LICENSECYCLERECURRENCESETUP' AS TABLENAME
	FROM dbo.LICENSECYCLERECURRENCESETUP		
UNION ALL
SELECT 
	MAILINGADDRESSTYPE.MAILINGADDRESSTYPEID AS UNIQUEID,
	MAILINGADDRESSTYPE.MAILINGADDRESSTYPENAME AS STRINGVALUE,
	'MAILINGADDRESSTYPE' AS TABLENAME
	FROM dbo.MAILINGADDRESSTYPE		
UNION ALL
SELECT 
	MAILINGADDRESSSTREETTYPE.MAILINGADDRESSSTREETTYPEID AS UNIQUEID,
	MAILINGADDRESSSTREETTYPE.NAME AS STRINGVALUE,
	'MAILINGADDRESSSTREETTYPE' AS TABLENAME
	FROM dbo.MAILINGADDRESSSTREETTYPE		
UNION ALL
SELECT 
	MEETINGTYPE.MEETINGTYPEID AS UNIQUEID,
	MEETINGTYPE.NAME AS STRINGVALUE,
	'MEETINGTYPE' AS TABLENAME
	FROM dbo.MEETINGTYPE		
UNION ALL  
SELECT 
	OMOBJECTSTATUS.OMOBJECTSTATUSID AS UNIQUEID,
	OMOBJECTSTATUS.NAME AS STRINGVALUE,
	'OMOBJECTSTATUS' AS TABLENAME
	FROM dbo.OMOBJECTSTATUS
UNION ALL
SELECT 
	OMOBJECTTYPE.OMOBJECTTYPEID AS UNIQUEID,
	OMOBJECTTYPE.NAME AS STRINGVALUE,
	'OMOBJECTTYPE' AS TABLENAME
	FROM dbo.OMOBJECTTYPE
UNION ALL
SELECT 
	OMOBJECTCLASSIFICATION.OMOBJECTCLASSIFICATIONID AS UNIQUEID,
	OMOBJECTCLASSIFICATION.NAME AS STRINGVALUE,
	'OMOBJECTCLASSIFICATION' AS TABLENAME
	FROM dbo.OMOBJECTCLASSIFICATION	
UNION ALL
SELECT 
	PMPERMITSTATUS.PMPERMITSTATUSID AS UNIQUEID,
	PMPERMITSTATUS.NAME AS STRINGVALUE,
	'PMPERMITSTATUS' AS TABLENAME
	FROM dbo.PMPERMITSTATUS
UNION ALL
SELECT 
	PMPERMITTYPE.PMPERMITTYPEID AS UNIQUEID,
	PMPERMITTYPE.NAME AS STRINGVALUE,
	'PMPERMITTYPE' AS TABLENAME
	FROM dbo.PMPERMITTYPE
UNION ALL
SELECT 
	PMPERMITWORKCLASS.PMPERMITWORKCLASSID AS UNIQUEID,
	PMPERMITWORKCLASS.NAME AS STRINGVALUE,
	'PMPERMITWORKCLASS' AS TABLENAME
	FROM dbo.PMPERMITWORKCLASS				
UNION ALL
SELECT 
	PLITEMREVIEWCHECKLISTTYPE.PLITEMREVIEWCHECKLISTTYPEID AS UNIQUEID,
	PLITEMREVIEWCHECKLISTTYPE.NAME AS STRINGVALUE,
	'PLITEMREVIEWCHECKLISTTYPE' AS TABLENAME
	FROM dbo.PLITEMREVIEWCHECKLISTTYPE	
UNION ALL
SELECT 
	PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID AS UNIQUEID,
	PLITEMREVIEWSTATUS.NAME AS STRINGVALUE,
	'PLITEMREVIEWSTATUS' AS TABLENAME
	FROM dbo.PLITEMREVIEWSTATUS		
UNION ALL
SELECT 
	PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID AS UNIQUEID,
	PLITEMREVIEWTYPE.NAME AS STRINGVALUE,
	'PLITEMREVIEWTYPE' AS TABLENAME
	FROM dbo.PLITEMREVIEWTYPE		
UNION ALL
SELECT 
	PLPLANACTIVITYTYPE.PLPLANACTIVITYTYPEID AS UNIQUEID,
	PLPLANACTIVITYTYPE.NAME AS STRINGVALUE,
	'PLPLANACTIVITYTYPE' AS TABLENAME
	FROM dbo.PLPLANACTIVITYTYPE		
UNION ALL
SELECT 
	PLPLANCORRECTIONTYPE.PLPLANCORRECTIONTYPEID AS UNIQUEID,
	PLPLANCORRECTIONTYPE.NAME AS STRINGVALUE,
	'PLPLANCORRECTIONTYPE' AS TABLENAME
	FROM dbo.PLPLANCORRECTIONTYPE		
UNION ALL
SELECT 
	PLPLANSTATUS.PLPLANSTATUSID AS UNIQUEID,
	PLPLANSTATUS.NAME AS STRINGVALUE,
	'PLPLANSTATUS' AS TABLENAME
	FROM dbo.PLPLANSTATUS		
UNION ALL
SELECT 
	PLPLANTYPE.PLPLANTYPEID AS UNIQUEID,
	PLPLANTYPE.PLANNAME AS STRINGVALUE,
	'PLPLANTYPE' AS TABLENAME
	FROM dbo.PLPLANTYPE			
UNION ALL
SELECT 
	PLPLANWORKCLASS.PLPLANWORKCLASSID AS UNIQUEID,
	PLPLANWORKCLASS.NAME AS STRINGVALUE,
	'PLPLANWORKCLASS' AS TABLENAME
	FROM dbo.PLPLANWORKCLASS			
UNION ALL
SELECT 
	PLSUBMITTALSTATUS.PLSUBMITTALSTATUSID AS UNIQUEID,
	PLSUBMITTALSTATUS.NAME AS STRINGVALUE,
	'PLSUBMITTALSTATUS' AS TABLENAME
	FROM dbo.PLSUBMITTALSTATUS		
UNION ALL
SELECT 
	PLSUBMITTALTYPE.PLSUBMITTALTYPEID AS UNIQUEID,
	PLSUBMITTALTYPE.TYPENAME AS STRINGVALUE,
	'PLSUBMITTALTYPE' AS TABLENAME
	FROM dbo.PLSUBMITTALTYPE
UNION ALL
SELECT 
	PRPROJECTSTATUS.PRPROJECTSTATUSID AS UNIQUEID,
	PRPROJECTSTATUS.NAME AS STRINGVALUE,
	'PRPROJECTSTATUS' AS TABLENAME
	FROM dbo.PRPROJECTSTATUS		
UNION ALL
SELECT 
	PRPROJECTTYPE.PRPROJECTTYPEID AS UNIQUEID,
	PRPROJECTTYPE.NAME AS STRINGVALUE,
	'PRPROJECTTYPE' AS TABLENAME
	FROM dbo.PRPROJECTTYPE		
UNION ALL
SELECT 
	PUPAYMENTTERM.PUPAYMENTTERMID AS UNIQUEID,
	PUPAYMENTTERM.NAME AS STRINGVALUE,
	'PUPAYMENTTERM' AS TABLENAME
	FROM dbo.PUPAYMENTTERM	
UNION ALL
SELECT 
	PUPURCHASEORDERLINETYPE.PUPURCHASEORDERLINETYPEID AS UNIQUEID,
	PUPURCHASEORDERLINETYPE.NAME AS STRINGVALUE,
	'PUPURCHASEORDERLINETYPE' AS TABLENAME
	FROM dbo.PUPURCHASEORDERLINETYPE		
UNION ALL
SELECT 
	PUPURCHASEORDERSTATUS.PUPURCHASEORDERSTATUSID AS UNIQUEID,
	PUPURCHASEORDERSTATUS.NAME AS STRINGVALUE,
	'PUPURCHASEORDERSTATUS' AS TABLENAME
	FROM dbo.PUPURCHASEORDERSTATUS		
UNION ALL
SELECT 
	PURECEIPTTYPE.PURECEIPTTYPEID AS UNIQUEID,
	PURECEIPTTYPE.NAME AS STRINGVALUE,
	'PURECEIPTTYPE' AS TABLENAME
	FROM dbo.PURECEIPTTYPE		
UNION ALL
SELECT 
	PUREQUISITIONSTATUS.PUREQUISITIONSTATUSID AS UNIQUEID,
	PUREQUISITIONSTATUS.NAME AS STRINGVALUE,
	'PUREQUISITIONSTATUS' AS TABLENAME
	FROM dbo.PUREQUISITIONSTATUS													
UNION ALL
SELECT 
	ROLES.SROLEGUID AS UNIQUEID,
	ROLES.ID AS STRINGVALUE,
	'ROLES' AS TABLENAME
	FROM dbo.ROLES
UNION ALL
SELECT 
	SALUTATION.SALUTATIONID AS UNIQUEID,
	SALUTATION.NAME AS STRINGVALUE,
	'SALUTATION' AS TABLENAME
	FROM dbo.SALUTATION
UNION ALL
SELECT 
	STATE.STATEID AS UNIQUEID,
	STATE.NAME AS STRINGVALUE,
	'STATE' AS TABLENAME
	FROM dbo.STATE
UNION ALL
SELECT 
	UNITOFMEASURE.UNITOFMEASUREID AS UNIQUEID,
	UNITOFMEASURE.NAME AS STRINGVALUE,
	'UNITOFMEASURE' AS TABLENAME
	FROM dbo.UNITOFMEASURE
UNION ALL
SELECT 
	UNITOFMEASURETYPE.UNITOFMEASURETYPEID AS UNIQUEID,
	UNITOFMEASURETYPE.SYSTEMTYPE AS STRINGVALUE,
	'UNITOFMEASURETYPE' AS TABLENAME
	FROM dbo.UNITOFMEASURETYPE	
UNION ALL
SELECT 
	USERS.SUSERGUID AS UNIQUEID,
	USERS.LNAME + ', ' + USERS.FNAME AS STRINGVALUE,
	'USERS' AS TABLENAME
	FROM dbo.USERS
UNION ALL
SELECT 
	ZONE.ZONEID AS UNIQUEID,
	ZONE.NAME AS STRINGVALUE,
	'ZONE' AS TABLENAME
	FROM dbo.ZONE
UNION ALL
SELECT 
	PLAPPLICATIONTYPE.PLAPPLICATIONTYPEID AS UNIQUEID,
	PLAPPLICATIONTYPE.APPLICATIONTYPENAME AS STRINGVALUE,
	'PLAPPLICATIONTYPE' AS TABLENAME
	FROM dbo.PLAPPLICATIONTYPE	
UNION ALL
SELECT 
	PLAPPLICATIONACTIVITYTYPE.PLAPPLICATIONACTIVITYTYPEID AS UNIQUEID,
	PLAPPLICATIONACTIVITYTYPE.NAME AS STRINGVALUE,
	'PLAPPLICATIONACTIVITYTYPE' AS TABLENAME
	FROM dbo.PLAPPLICATIONACTIVITYTYPE		
UNION ALL
SELECT 
	LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID AS UNIQUEID,
	LANDMANAGEMENTCONTACTTYPE.NAME AS STRINGVALUE,
	'LANDMANAGEMENTCONTACTTYPE' AS TABLENAME
	FROM dbo.LANDMANAGEMENTCONTACTTYPE		
UNION ALL
SELECT 
	AMWORKORDERTEMPLATE.AMWORKORDERTEMPLATEID AS UNIQUEID,
	AMWORKORDERTEMPLATE.NAME AS STRINGVALUE,
	'AMWORKORDERTEMPLATE' AS TABLENAME
	FROM dbo.AMWORKORDERTEMPLATE	
UNION ALL
SELECT 
	RECURRENCE.RECURRENCEID AS UNIQUEID,
	RECURRENCE.NAME AS STRINGVALUE,
	'RECURRENCE' AS TABLENAME
	FROM dbo.RECURRENCE		
UNION ALL
SELECT 
	AMASSETCLASS.AMASSETCLASSID AS UNIQUEID,
	AMASSETCLASS.NAME AS STRINGVALUE,
	'AMASSETCLASS' AS TABLENAME
	FROM dbo.AMASSETCLASS
UNION ALL
SELECT 
	PLAPPLICATION.PLAPPLICATIONID AS UNIQUEID,
	PLAPPLICATION.APPNUMBER AS STRINGVALUE,
	'PLAPPLICATION' AS TABLENAME
	FROM dbo.PLAPPLICATION																	
UNION ALL
SELECT 
	PLAPPLICATIONSTATUS.PLAPPLICATIONSTATUSID AS UNIQUEID,
	PLAPPLICATIONSTATUS.STATUS AS STRINGVALUE,
	'PLAPPLICATIONSTATUS' AS TABLENAME
	FROM dbo.PLAPPLICATIONSTATUS																		
UNION ALL
SELECT 
	ASSETGEOMETRYCOLLECTION.ASSETGEOMETRYCOLLECTIONID AS UNIQUEID,
	ASSETGEOMETRYCOLLECTION.NAME AS STRINGVALUE,
	'ASSETGEOMETRYCOLLECTION' AS TABLENAME
	FROM dbo.ASSETGEOMETRYCOLLECTION
UNION ALL
SELECT 
	CMVIOLATIONSTATUS.CMVIOLATIONSTATUSID AS UNIQUEID,
	CMVIOLATIONSTATUS.NAME AS STRINGVALUE,
	'CMVIOLATIONSTATUS' AS TABLENAME
	FROM dbo.CMVIOLATIONSTATUS
UNION ALL
SELECT 
	CMCODEVIOLATIONPRIORITY.CMCODEVIOLATIONPRIORITYID AS UNIQUEID,
	CMCODEVIOLATIONPRIORITY.NAME AS STRINGVALUE,
	'CMCODEVIOLATIONPRIORITY' AS TABLENAME
	FROM dbo.CMCODEVIOLATIONPRIORITY
UNION ALL
SELECT 
	ITEM.ITEMID AS UNIQUEID,
	ITEM.NAME AS STRINGVALUE,
	'ITEM' AS TABLENAME
	FROM dbo.ITEM
UNION ALL
SELECT 
	INSTOREITEM.INSTOREITEMID AS UNIQUEID,
	ITEM.NAME AS STRINGVALUE,
	'INSTOREITEM' AS TABLENAME
	FROM dbo.INSTOREITEM, dbo.ITEM
	WHERE INSTOREITEM.ITEMID = ITEM.ITEMID			
UNION ALL
SELECT 
	CONDITIONCATEGORY.CONDITIONCATEGORYID AS UNIQUEID,
	CONDITIONCATEGORY.NAME AS STRINGVALUE,
	'CONDITIONCATEGORY' AS TABLENAME
	FROM dbo.CONDITIONCATEGORY		
UNION ALL
SELECT 
	CONDITIONLIBRARY.CONDITIONLIBRARYID AS UNIQUEID,
	CONDITIONLIBRARY.NAME AS STRINGVALUE,
	'CONDITIONLIBRARY' AS TABLENAME
	FROM CONDITIONLIBRARY
UNION ALL
SELECT	
	ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID AS UNIQUEID,
	ERPROJECTFILEVERSION.SAVEFILENAME AS STRINGVALUE,
	'ERPROJECTFILEVERSION' AS TABLENAME
	FROM dbo.ERPROJECTFILEVERSION				
UNION ALL	
SELECT	
	APPLICATIONUSERTYPE.APPLICATIONUSERTYPEID AS UNIQUEID,
	APPLICATIONUSERTYPE.TYPENAME AS STRINGVALUE,
	'APPLICATIONUSERTYPE' AS TABLENAME
	FROM dbo.APPLICATIONUSERTYPE		
UNION ALL	
SELECT	
	PMPERMITVALUATIONTYPE.PMPERMITVALUATIONTYPEID AS UNIQUEID,
	PMPERMITVALUATIONTYPE.NAME AS STRINGVALUE,
	'PMPERMITVALUATIONTYPE' AS TABLENAME
	FROM dbo.PMPERMITVALUATIONTYPE
UNION ALL	
SELECT	
	PMPERMITVALUATIONGROUP.PMPERMITVALUATIONGROUPID AS UNIQUEID,
	PMPERMITVALUATIONGROUP.NAME AS STRINGVALUE,
	'PMPERMITVALUATIONGROUPID' AS TABLENAME
	FROM dbo.PMPERMITVALUATIONGROUP
UNION ALL	
SELECT	
	PMPERMITDIMENSIONCATEGORY.PMPERMITDIMENSIONCATEGORYID AS UNIQUEID,
	PMPERMITDIMENSIONCATEGORY.CATEGORY AS STRINGVALUE,
	'PMPERMITDIMENSIONCATEGORY' AS TABLENAME
	FROM dbo.PMPERMITDIMENSIONCATEGORY
UNION ALL	
SELECT	
	CITIZENREQUESTSOURCE.CITIZENREQUESTSOURCEID AS UNIQUEID,
	CITIZENREQUESTSOURCE.NAME AS STRINGVALUE,
	'CITIZENREQUESTSOURCE' AS TABLENAME
	FROM dbo.CITIZENREQUESTSOURCE
UNION ALL
SELECT
	CAPAYMENTMETHOD.CAPAYMENTMETHODID AS UNIQUEID,
	CAPAYMENTMETHOD.NAME AS STRINGVALUE,
	'CAPAYMENTMETHOD' AS TABLENAME
	FROM dbo.CAPAYMENTMETHOD
UNION ALL
SELECT
	BLEXTSTATUS.BLEXTSTATUSID AS UNIQUEID,
	BLEXTSTATUS.NAME AS STRINGVALUE,
	'BLEXTSTATUS' AS TABLENAME
	FROM dbo.BLEXTSTATUS
UNION ALL
SELECT
	BLEXTBUSINESSCATEGORY.BLEXTBUSINESSCATEGORYID AS UNIQUEID,
	BLEXTBUSINESSCATEGORY.NAME AS STRINGVALUE,
	'BLEXTBUSINESSCATEGORY' AS TABLENAME
	FROM dbo.BLEXTBUSINESSCATEGORY
UNION ALL
SELECT
	BLEXTCOMPANYTYPE.BLEXTCOMPANYTYPEID AS UNIQUEID,
	BLEXTCOMPANYTYPE.NAME AS STRINGVALUE,
	'BLEXTCOMPANYTYPE' AS TABLENAME
	FROM dbo.BLEXTCOMPANYTYPE
UNION ALL
SELECT
	BLEXTLOCATION.BLEXTLOCATIONID AS UNIQUEID,
	BLEXTLOCATION.NAME AS STRINGVALUE,
	'BLEXTLOCATION' AS TABLENAME
	FROM dbo.BLEXTLOCATION
UNION ALL
SELECT
	BLLICENSECLASS.BLLICENSECLASSID AS UNIQUEID,
	BLLICENSECLASS.NAME AS STRINGVALUE,
	'BLLICENSECLASS' AS TABLENAME
	FROM dbo.BLLICENSECLASS
UNION ALL
SELECT
	BLLICENSESTATUS.BLLICENSESTATUSID AS UNIQUEID,
	BLLICENSESTATUS.NAME AS STRINGVALUE,
	'BLLICENSESTATUS' AS TABLENAME
	FROM dbo.BLLICENSESTATUS
UNION ALL
SELECT
	BLLICENSETYPE.BLLICENSETYPEID AS UNIQUEID,
	BLLICENSETYPE.NAME AS STRINGVALUE,
	'BLLICENSETYPE' AS TABLENAME
	FROM dbo.BLLICENSETYPE
UNION ALL
SELECT
	BLCONTACTTYPE.BLCONTACTTYPEID AS UNIQUEID,
	BLCONTACTTYPE.NAME AS STRINGVALUE,
	'BLCONTACTTYPE' AS TABLENAME
	FROM dbo.BLCONTACTTYPE
UNION ALL
SELECT
	RPTREPORT.RPTREPORTID AS UNIQUEID,
	RPTREPORT.REPORTNAME AS STRINGVALUE,
	'RPTREPORT' AS TABLENAME
	FROM dbo.RPTREPORT
UNION ALL
SELECT
	IMINSPECTIONCASESTATUS.IMINSPECTIONCASESTATUSID AS UNIQUEID,
	IMINSPECTIONCASESTATUS.NAME AS STRINGVALUE,
	'IMINSPECTIONCASESTATUS' AS TABLENAME
	FROM dbo.IMINSPECTIONCASESTATUS
UNION ALL
SELECT
	ILLICENSETYPE.ILLICENSETYPEID AS UNIQUEID,
	ILLICENSETYPE.NAME AS STRINGVALUE,
	'ILLICENSETYPE' AS TABLENAME
	FROM dbo.ILLICENSETYPE
UNION ALL
SELECT
	ILLICENSESTATUS.ILLICENSESTATUSID AS UNIQUEID,
	ILLICENSESTATUS.NAME AS STRINGVALUE,
	'ILLICENSESTATUS' AS TABLENAME
	FROM dbo.ILLICENSESTATUS
UNION ALL
SELECT
	ILLICENSECLASSIFICATION.ILLICENSECLASSIFICATIONID AS UNIQUEID,
	ILLICENSECLASSIFICATION.NAME AS STRINGVALUE,
	'ILLICENSECLASSIFICATION' AS TABLENAME
	FROM dbo.ILLICENSECLASSIFICATION
UNION ALL
SELECT
	OFFICE.OFFICEID AS UNIQUEID,
	OFFICE.NAME AS STRINGVALUE,
	'OFFICE' AS TABLENAME
	FROM dbo.OFFICE
UNION ALL
SELECT TXREMITTANCETYPE.TXREMITTANCETYPEID AS UNIQUEID,
		TXREMITTANCETYPE.NAME AS STRINGVALUE,
		'TXREMITTANCETYPE' AS TABLENAME
		FROM dbo.TXREMITTANCETYPE
UNION ALL
SELECT TXREMITSTATUS.TXREMITSTATUSID AS UNIQUEID,
		TXREMITSTATUS.NAME AS STRINGVALUE,
		'TXREMITSTATUS' AS TABLENAME
		FROM dbo.TXREMITSTATUS
UNION ALL
SELECT TXRPTPERIOD.TXRPTPERIODID AS UNIQUEID,
		TXRPTPERIOD.NAME AS STRINGVALUE,
		'TXRPTPERIOD' AS TABLENAME
		FROM dbo.TXRPTPERIOD
UNION ALL
SELECT
	BONDSTATUS.BONDSTATUSID AS UNIQUEID,
	BONDSTATUS.NAME AS STRINGVALUE,
	'BONDSTATUS' AS TABLENAME
	FROM dbo.BONDSTATUS
UNION ALL
SELECT
	TIMETRACKINGTYPE.TIMETRACKINGTYPEID AS UNIQUEID,
	TIMETRACKINGTYPE.NAME AS STRINGVALUE,
	'TIMETRACKINGTYPE' AS TABLENAME
	FROM dbo.TIMETRACKINGTYPE
UNION ALL
SELECT
	BILLINGRATE.BILLINGRATEID AS UNIQUEID,
	BILLINGRATE.NAME AS STRINGVALUE,
	'BILLINGRATE' AS TABLENAME
	FROM dbo.BILLINGRATE
UNION ALL
SELECT
	CAPRORATESCHEDULE.CAPRORATESCHEDULEID AS UNIQUEID,
	CAPRORATESCHEDULE.NAME AS STRINGVALUE,
	'CAPRORATESCHEDULE' AS TABLENAME
	FROM dbo.CAPRORATESCHEDULE
UNION ALL
SELECT
	IPUNITTYPE.IPUNITTYPEID AS UNIQUEID,
	IPUNITTYPE.NAME AS STRINGVALUE,
	'IPUNITTYPE' AS TABLENAME
	FROM dbo.IPUNITTYPE
UNION ALL
SELECT
	COLICENSECERTIFICATIONTYPE.COSIMPLELICCERTTYPEID AS UNIQUEID,
	COLICENSECERTIFICATIONTYPE.NAME AS STRINGVALUE,
	'COLICENSECERTIFICATIONTYPE' AS TABLENAME
	FROM dbo.COLICENSECERTIFICATIONTYPE
UNION ALL
SELECT  
	RPPROPERTYSTATUS.RPPROPERTYSTATUSID AS UNIQUEID, 
    RPPROPERTYSTATUS.NAME AS STRINGVALUE, 
	'RPPROPERTYSTATUS' AS TABLENAME
	FROM dbo.RPPROPERTYSTATUS
UNION ALL
SELECT
    RPCONTACTTYPE.RPCONTACTTYPEID AS UNIQUEID,
	RPCONTACTTYPE.NAME AS STRINGVALUE,
	'RPCONTACTTYPE' AS TABLENAME
	FROM dbo.RPCONTACTTYPE
UNION ALL
SELECT   
    RPLANDLORDLICENSESTATUS.RPLANDLORDLICENSESTATUSID AS UNIQUEID,
	RPLANDLORDLICENSESTATUS.NAME AS STRINGVALUE, 
    'RPLANDLORDLICENSESTATUS' AS TABLENAME
	FROM dbo.RPLANDLORDLICENSESTATUS
UNION ALL
SELECT BONDTYPE.BONDTYPEID AS UNIQUEID,
       BONDTYPE.NAME AS STRINGVALUE,
      'BONDTYPE' AS TABLENAME
  FROM BONDTYPE
UNION ALL
SELECT CACPITYPE.CACPITYPEID AS UNIQUEID,
       CACPITYPE.NAME AS STRINGVALUE,
	   'CACPITYPE' AS TABLENAME
  FROM CACPITYPE
UNION ALL
SELECT CACPIREFERENCEDATE.CACPIREFERENCEDATEID AS UNIQUEID,
       CACPIREFERENCEDATE.DATEOBJECT AS STRINGVALUE,
	   'CACPIREFERENCEDATE' AS TABLENAME
  FROM CACPIREFERENCEDATE
UNION ALL
SELECT
	BLEXTBUSINESSTYPE.BLEXTBUSINESSTYPEID AS UNIQUEID,
	BLEXTBUSINESSTYPE.NAME AS STRINGVALUE,
	'BLEXTBUSINESSTYPE' AS TABLENAME
	FROM dbo.BLEXTBUSINESSTYPE	
UNION ALL
SELECT
	FOBUSINESSSTATUS.FOBUSINESSSTATUSID AS UNIQUEID,
	FOBUSINESSSTATUS.NAME AS STRINGVALUE,
	'FOBUSINESSSTATUS' AS TABLENAME
	FROM dbo.FOBUSINESSSTATUS	
UNION ALL
SELECT
	FOCOMPLEX.FOCOMPLEXID AS UNIQUEID,
	FOCOMPLEX.NAME AS STRINGVALUE,
	'FOCOMPLEX' AS TABLENAME
	FROM dbo.FOCOMPLEX	
UNION ALL
SELECT
	FOCONSTRUCTIONTYPE.FOCONSTRUCTIONTYPEID AS UNIQUEID,
	FOCONSTRUCTIONTYPE.NAME AS STRINGVALUE,
	'FOCONSTRUCTIONTYPE' AS TABLENAME
	FROM dbo.FOCONSTRUCTIONTYPE		
UNION ALL
SELECT
	FOCONTACTTYPE.FOCONTACTTYPEID AS UNIQUEID,
	FOCONTACTTYPE.NAME AS STRINGVALUE,
	'FOCONTACTTYPE' AS TABLENAME
	FROM dbo.FOCONTACTTYPE			
UNION ALL
SELECT
	FOEXTINGUISHERTYPE.FOEXTINGUISHERTYPEID AS UNIQUEID,
	FOEXTINGUISHERTYPE.NAME AS STRINGVALUE,
	'FOEXTINGUISHERTYPE' AS TABLENAME
	FROM dbo.FOEXTINGUISHERTYPE			
UNION ALL
SELECT
	FOFIREALARMTYPE.FOFIREALARMTYPEID AS UNIQUEID,
	FOFIREALARMTYPE.NAME AS STRINGVALUE,
	'FOFIREALARMTYPE' AS TABLENAME
	FROM dbo.FOFIREALARMTYPE		
UNION ALL
SELECT
	FOFIREDETECTORTYPE.FOFIREDETECTORTYPEID AS UNIQUEID,
	FOFIREDETECTORTYPE.NAME AS STRINGVALUE,
	'FOFIREDETECTORTYPE' AS TABLENAME
	FROM dbo.FOFIREDETECTORTYPE		
UNION ALL
SELECT
	FOGENERATORTYPE.FOGENERATORTYPEID AS UNIQUEID,
	FOGENERATORTYPE.NAME AS STRINGVALUE,
	'FOGENERATORTYPE' AS TABLENAME
	FROM dbo.FOGENERATORTYPE		
UNION ALL
SELECT
	FOOCCUPANCYTYPE.FOOCCUPANCYTYPEID AS UNIQUEID,
	FOOCCUPANCYTYPE.NAME AS STRINGVALUE,
	'FOOCCUPANCYTYPE' AS TABLENAME
	FROM dbo.FOOCCUPANCYTYPE		
UNION ALL
SELECT
	FOPERMITSTATUS.FOPERMITSTATUSID AS UNIQUEID,
	FOPERMITSTATUS.NAME AS STRINGVALUE,
	'FOPERMITSTATUS' AS TABLENAME
	FROM dbo.FOPERMITSTATUS		
UNION ALL
SELECT
	FOPERMITTYPE.FOPERMITTYPEID AS UNIQUEID,
	FOPERMITTYPE.NAME AS STRINGVALUE,
	'FOPERMITTYPE' AS TABLENAME
	FROM dbo.FOPERMITTYPE				
UNION ALL
SELECT
	FOPROPERTYUSE.FOPROPERTYUSEID AS UNIQUEID,
	FOPROPERTYUSE.NAME AS STRINGVALUE,
	'FOPROPERTYUSE' AS TABLENAME
	FROM dbo.FOPROPERTYUSE	
UNION ALL
SELECT 
	BUILDINGSTATUS.BUILDINGSTATUSID AS UNIQUEID,
	BUILDINGSTATUS.NAME AS STRINGVALUE,
	'BUILDINGSTATUS' AS TABLENAME
	FROM dbo.BUILDINGSTATUS
UNION ALL
SELECT 
	IPCASESTATUS.IPCASESTATUSID AS UNIQUEID,
	IPCASESTATUS.NAME AS STRINGVALUE,
	'IPCASESTATUS' AS TABLENAME
	FROM dbo.IPCASESTATUS
UNION ALL
SELECT
	IPCONDITIONSTATUS.IPCONDITIONSTATUSID AS UNIQUEID,
	IPCONDITIONSTATUS.NAME AS STRINGVALUE,
	'IPCONDITIONSTATUS' AS TABLENAME
	FROM dbo.IPCONDITIONSTATUS
UNION ALL
SELECT
	IPTARGETEDFUNDTYPE.IPTARGETEDFUNDTYPEID AS UNIQUEID,
	IPTARGETEDFUNDTYPE.NAME AS STRINGVALUE,
	'IPTARGETEDFUNDTYPE' AS TABLENAME
	FROM dbo.IPTARGETEDFUNDTYPE
UNION ALL
SELECT 
	PMPERMITACTIVITYTYPE.PMPERMITACTIVITYTYPEID AS UNIQUEID,
	PMPERMITACTIVITYTYPE.NAME AS STRINGVALUE,
	'PMPERMITACTIVITYTYPE' AS TABLENAME
	FROM dbo.PMPERMITACTIVITYTYPE	
UNION ALL
SELECT 
	BLLICENSEACTIVITYTYPE.BLLICENSEACTIVITYTYPEID AS UNIQUEID,
	BLLICENSEACTIVITYTYPE.NAME AS STRINGVALUE,
	'BLLICENSEACTIVITYTYPE' AS TABLENAME
	FROM dbo.BLLICENSEACTIVITYTYPE
UNION ALL
SELECT 
	ILLICENSEACTIVITYTYPE.ILLICENSEACTIVITYTYPEID AS UNIQUEID,
	ILLICENSEACTIVITYTYPE.NAME AS STRINGVALUE,
	'ILLICENSEACTIVITYTYPE' AS TABLENAME
	FROM dbo.ILLICENSEACTIVITYTYPE	
UNION ALL
SELECT 
	TEAM.TEAMID AS UNIQUEID,
	TEAM.NAME AS STRINGVALUE,
	'TEAM' AS TABLENAME
	FROM dbo.TEAM