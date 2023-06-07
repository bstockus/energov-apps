﻿CREATE VIEW [dbo].[INVOICEMODULEFEEVIEW]
AS 

SELECT	
	[dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID],
	[dbo].[CACOMPUTEDFEE].[FEENAME],
	[dbo].[CACOMPUTEDFEE].[FEEDESCRIPTION],
	[dbo].[CACOMPUTEDFEE].[NOTES],
	[dbo].[CACOMPUTEDFEE].[CASTATUSID],
	[dbo].[CASTATUS].[NAME] FEESTATUSNAME,
	[dbo].[CACOMPUTEDFEE].[COMPUTEDAMOUNT],
	[dbo].[CACOMPUTEDFEE].[AMOUNTPAIDTODATE],
	[dbo].[CACOMPUTEDFEE].[BASEAMOUNT],
	[dbo].[CACOMPUTEDFEE].[CPIAMOUNT],
	[dbo].[CACOMPUTEDFEE].[CREDITAMOUNT],
	[dbo].[CACOMPUTEDFEE].[INPUTVALUE],
	[dbo].[CAENTITY].[CAENTITYID],
	[dbo].[CAENTITY].[CAMODULEID],
	[dbo].[CAENTITY].[NAME] ENTITYNAME,
	[dbo].[CAMODULE].[NAME] MODULENAME,
	CASE 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 1 Then [PERMIT].[ENTITYNUMBER]
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 2 Then [CODECASE].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 3 Then [VIOLATION].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 4 Then [APPLICATION].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 5 Then [PLAN].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 6 Then [PROJECT].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 7 Then [BUSINESSLICENSE].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 8 Then [PROFESSIONALLICENSE].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 9 Then [TAXREMITTANCE].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 10 Then [RENTALPROPERTY].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 11 Then [LANDLORDLICENSE].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 12 Then [INSPECTION].[ENTITYNUMBER] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 13 Then [IMPACTCONDITION].[ENTITYNUMBER]
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 14 Then [BUSINESS].[ENTITYNUMBER]
		Else N'' 
	END AS ENTITYNUMBER,
	CASE 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 1 Then [PERMIT].[ENTITYID]
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 2 Then [CODECASE].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 3 Then [VIOLATION].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 4 Then [APPLICATION].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 5 Then [PLAN].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 6 Then [PROJECT].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 7 Then [BUSINESSLICENSE].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 8 Then [PROFESSIONALLICENSE].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 9 Then [TAXREMITTANCE].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 10 Then [RENTALPROPERTY].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 11 Then [LANDLORDLICENSE].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 12 Then [INSPECTION].[ENTITYID] 
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 13 Then [IMPACTCONDITION].[ENTITYID]
		WHEN [dbo].[CAENTITY].[CAENTITYID] = 14 Then [BUSINESS].[ENTITYID]
		Else N'' 
	END AS ENTITYID
FROM [dbo].[CACOMPUTEDFEE] WITH (NOLOCK)
INNER JOIN [dbo].[CAFEETEMPLATEFEE] WITH (NOLOCK) ON [dbo].[CACOMPUTEDFEE].[CAFEETEMPLATEFEEID] = [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID]
INNER JOIN [dbo].[CAFEETEMPLATE] WITH (NOLOCK) ON [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEID] = [dbo].[CAFEETEMPLATE].[CAFEETEMPLATEID]
INNER JOIN [dbo].[CAENTITY] WITH (NOLOCK) ON [dbo].[CAFEETEMPLATE].[CAENTITYID] = [dbo].[CAENTITY].[CAENTITYID]
INNER JOIN [dbo].[CAMODULE] WITH (NOLOCK) ON [dbo].[CAENTITY].[CAMODULEID] = [dbo].[CAMODULE].[CAMODULEID]
INNER JOIN [dbo].[CASTATUS] WITH (NOLOCK) ON [dbo].[CACOMPUTEDFEE].[CASTATUSID] = [dbo].[CASTATUS].[CASTATUSID]
LEFT JOIN ( SELECT [dbo].[PMPERMIT].[PERMITNUMBER] AS ENTITYNUMBER, [dbo].[PMPERMIT].[PMPERMITID] ENTITYID, [dbo].[PMPERMITFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[PMPERMIT] WITH (NOLOCK)
		    INNER JOIN [dbo].[PMPERMITFEE] WITH (NOLOCK) ON [dbo].[PMPERMIT].[PMPERMITID] = [dbo].[PMPERMITFEE].[PMPERMITID]
          ) [PERMIT] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [PERMIT].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[CMCODECASE].[CASENUMBER] AS ENTITYNUMBER, [dbo].[CMCODECASE].[CMCODECASEID] ENTITYID, [dbo].[CMCODECASEFEE].[CACOMPUTEDFEEID]
            FROM [dbo].[CMCODECASE] WITH (NOLOCK)
            INNER JOIN [dbo].[CMCODECASEFEE] WITH (NOLOCK) ON [dbo].[CMCODECASE].[CMCODECASEID] = [dbo].[CMCODECASEFEE].[CMCODECASEID]
          ) [CODECASE] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [CODECASE].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[CMCODECASE].[CASENUMBER] AS ENTITYNUMBER, [dbo].[CMCODECASE].[CMCODECASEID] ENTITYID, [dbo].[CMVIOLATIONFEE].[CACOMPUTEDFEEID]
            FROM [dbo].[CMVIOLATION] WITH (NOLOCK)
            INNER JOIN [dbo].[CMCODEWFSTEP] WITH (NOLOCK) ON [dbo].[CMVIOLATION].[CMCODEWFSTEPID] = [dbo].[CMCODEWFSTEP].[CMCODEWFSTEPID]
            INNER JOIN [dbo].[CMCODECASE] WITH (NOLOCK) ON [dbo].[CMCODEWFSTEP].[CMCODECASEID] = [dbo].[CMCODECASE].[CMCODECASEID]
            INNER JOIN [dbo].[CMVIOLATIONFEE] WITH (NOLOCK) ON [dbo].[CMVIOLATION].[CMVIOLATIONID] = [dbo].[CMVIOLATIONFEE].[CMVIOLATIONID]
		  ) [VIOLATION] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [VIOLATION].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[PLAPPLICATION].[APPNUMBER] AS ENTITYNUMBER, [dbo].[PLAPPLICATION].[PLAPPLICATIONID] ENTITYID, [dbo].[PLAPPLICATIONFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[PLAPPLICATION] WITH (NOLOCK)
		    INNER JOIN [dbo].[PLAPPLICATIONFEE] WITH (NOLOCK) ON [dbo].[PLAPPLICATION].[PLAPPLICATIONID] = [dbo].[PLAPPLICATIONFEE].[PLAPPLICATIONID]
          ) [APPLICATION] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [APPLICATION].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[PLPLAN].[PLANNUMBER] AS ENTITYNUMBER, [dbo].[PLPLAN].[PLPLANID] ENTITYID, [dbo].[PLPLANFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[PLPLAN] WITH (NOLOCK)
		    INNER JOIN [dbo].[PLPLANFEE] WITH (NOLOCK) ON [dbo].[PLPLAN].[PLPLANID] = [dbo].[PLPLANFEE].[PLPLANID]
          ) [PLAN] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [PLAN].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[PRPROJECT].[PROJECTNUMBER] AS ENTITYNUMBER, [dbo].[PRPROJECT].[PRPROJECTID] ENTITYID, [dbo].[PRPROJECTFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[PRPROJECT] WITH (NOLOCK)
		    INNER JOIN [dbo].[PRPROJECTFEE] WITH (NOLOCK) ON [dbo].[PRPROJECT].[PRPROJECTID] = [dbo].[PRPROJECTFEE].[PRPROJECTID]
          ) [PROJECT] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [PROJECT].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[BLLICENSE].[LICENSENUMBER] AS ENTITYNUMBER, [dbo].[BLLICENSE].[BLLICENSEID] ENTITYID, [dbo].[BLLICENSEFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[BLLICENSE] WITH (NOLOCK)
		    INNER JOIN [dbo].[BLLICENSEFEE] WITH (NOLOCK) ON [dbo].[BLLICENSE].[BLLICENSEID] = [dbo].[BLLICENSEFEE].[BLLICENSEID]
          ) [BUSINESSLICENSE] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [BUSINESSLICENSE].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[BLGLOBALENTITYEXTENSION].[REGISTRATIONID] AS ENTITYNUMBER, [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] ENTITYID, [dbo].[BLGLOBALENTITYEXTENSIONFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[BLGLOBALENTITYEXTENSION] WITH (NOLOCK)
		    INNER JOIN [dbo].[BLGLOBALENTITYEXTENSIONFEE] WITH (NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] = [dbo].[BLGLOBALENTITYEXTENSIONFEE].[BLGLOBALENTITYEXTENSIONID]
          ) [BUSINESS] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [BUSINESS].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[ILLICENSE].[LICENSENUMBER] AS ENTITYNUMBER, [dbo].[ILLICENSE].[ILLICENSEID] ENTITYID, [dbo].[ILLICENSEFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[ILLICENSE] WITH (NOLOCK)
		    INNER JOIN [dbo].[ILLICENSEFEE] WITH (NOLOCK) ON [dbo].[ILLICENSE].[ILLICENSEID] = [dbo].[ILLICENSEFEE].[ILLICENSEID]
          ) [PROFESSIONALLICENSE] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [PROFESSIONALLICENSE].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[TXREMITTANCEACCOUNT].[ACCOUNTNUMBER] AS ENTITYNUMBER, [dbo].[TXREMITTANCEACCOUNT].[TXREMITTANCEACCOUNTID] ENTITYID, [dbo].[TXREMITTANCEFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[TXREMITTANCE] WITH (NOLOCK)
			INNER JOIN [dbo].[TXREMITTANCEACCOUNT] WITH (NOLOCK) ON [dbo].[TXREMITTANCE].[TXREMITTANCEACCOUNTID] = [dbo].[TXREMITTANCEACCOUNT].[TXREMITTANCEACCOUNTID]
		    INNER JOIN [dbo].[TXREMITTANCEFEE] WITH (NOLOCK) ON [dbo].[TXREMITTANCE].[TXREMITTANCEID] = [dbo].[TXREMITTANCEFEE].[TXREMITTANCEID]
          ) [TAXREMITTANCE] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [TAXREMITTANCE].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[GLOBALENTITY].[CONTACTID] AS ENTITYNUMBER, [dbo].[GLOBALENTITY].[GLOBALENTITYID] ENTITYID, [dbo].[RPPROPERTYFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[RPPROPERTY] WITH (NOLOCK)
			INNER JOIN [dbo].[RPLANDLORDLICENSE] WITH (NOLOCK) ON [RPPROPERTY].[RPLANDLORDLICENSEID] = [RPLANDLORDLICENSE].[RPLANDLORDLICENSEID]
			INNER JOIN [dbo].[GLOBALENTITY] WITH (NOLOCK) ON [dbo].[RPLANDLORDLICENSE].[GLOBALENTITYID] = [dbo].[GLOBALENTITY].[GLOBALENTITYID]
		    INNER JOIN [dbo].[RPPROPERTYFEE] WITH (NOLOCK) ON [dbo].[RPPROPERTY].[RPPROPERTYID] = [dbo].[RPPROPERTYFEE].[RPPROPERTYID]
          ) [RENTALPROPERTY] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [RENTALPROPERTY].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[GLOBALENTITY].[CONTACTID] AS ENTITYNUMBER, [dbo].[GLOBALENTITY].[GLOBALENTITYID] ENTITYID, [dbo].[RPLANDLORDLICENSEFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[RPLANDLORDLICENSE] WITH (NOLOCK)
			INNER JOIN [dbo].[GLOBALENTITY] WITH (NOLOCK) ON [dbo].[RPLANDLORDLICENSE].[GLOBALENTITYID] = [dbo].[GLOBALENTITY].[GLOBALENTITYID]
		    INNER JOIN [dbo].[RPLANDLORDLICENSEFEE] WITH (NOLOCK) ON [dbo].[RPLANDLORDLICENSE].[RPLANDLORDLICENSEID] = [dbo].[RPLANDLORDLICENSEFEE].[RPLANDLORDLICENSEID]
          ) [LANDLORDLICENSE] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [LANDLORDLICENSE].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[IMINSPECTION].[INSPECTIONNUMBER] AS ENTITYNUMBER, [dbo].[IMINSPECTION].[IMINSPECTIONID] ENTITYID, [dbo].[IMINSPECTIONFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[IMINSPECTION] WITH (NOLOCK)
		    INNER JOIN [dbo].[IMINSPECTIONFEE] WITH (NOLOCK) ON [dbo].[IMINSPECTION].[IMINSPECTIONID] = [dbo].[IMINSPECTIONFEE].[IMINSPECTIONID]
          ) [INSPECTION] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [INSPECTION].[CACOMPUTEDFEEID]
LEFT JOIN ( SELECT [dbo].[IPCONDITION].[CONDITIONNUMBER] AS ENTITYNUMBER, [dbo].[IPCONDITION].[IPCONDITIONID] ENTITYID, [dbo].[IPCONDITIONFEE].[CACOMPUTEDFEEID]
		    FROM [dbo].[IPCONDITION] WITH (NOLOCK)
		    INNER JOIN [dbo].[IPCONDITIONFEE] WITH (NOLOCK) ON [dbo].[IPCONDITION].[IPCONDITIONID] = [dbo].[IPCONDITIONFEE].[IPCONDITIONID]
          ) [IMPACTCONDITION] ON [dbo].[CACOMPUTEDFEE].[CACOMPUTEDFEEID] = [IMPACTCONDITION].[CACOMPUTEDFEEID]