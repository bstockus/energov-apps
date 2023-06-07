﻿CREATE PROCEDURE [dbo].[USP_WFACTION_UPDATE]
(
	@WFACTIONID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@WFACTIONTYPEID INT,
	@PASSDESCRIPTION NVARCHAR(30),
	@FAILDESCRIPTION NVARCHAR(30),
	@ALLOWREDO BIT,
	@REDODESCRIPTION NVARCHAR(30),
	@ICON VARBINARY(MAX),
	@DAYSTOCOMPLETE INT,
	@PLSUBMITTALTYPEID CHAR(36),
	@MEETINGTYPEID CHAR(36),
	@HEARINGTYPEID CHAR(36),
	@WORKFLOWCOMPLETETYPEID INT,
	@IMINSPECTIONTYPEID CHAR(36),
	@PLPLANTYPEID CHAR(36),
	@PLPLANWORKCLASSID CHAR(36),
	@PMPERMITTYPEID CHAR(36),
	@PMPERMITWORKCLASSID CHAR(36),
	@PLPLANACTIVITYTYPEID CHAR(36),
	@PMPERMITACTIVITYTYPEID CHAR(36),
	@CMCODEACTIVITYTYPEID CHAR(36),
	@RPTREPORTID CHAR(36),
	@RPTFRMTOBUSOBJMAPID CHAR(36),
	@BLLICENSETYPEID CHAR(36),
	@BLLICENSECLASSID CHAR(36),
	@BLLICENSEACTIVITYTYPEID CHAR(36),
	@TASKTYPEID CHAR(36),
	@CMCODEID CHAR(36),
	@IMINSPECTIONCASETYPEID CHAR(36),
	@ILLICENSEACTIVITYTYPEID CHAR(36),
	@EXAMTYPEID CHAR(36),
	@CAFEETEMPLATEID CHAR(36),
	@ISAUTOINVOICE BIT,
	@ISREQUIREDFULLPAYMNENT BIT,
	@OMOBJECTTYPEID CHAR(36),
	@OMOBJECTCLASSIFICATIONID CHAR(36),
	@COMPUTEFEEACTIONTYPEID INT,
	@ISUSEACTIONDATEASFEEDATE BIT,
	@ISCOMPUTEMAINFEETEMPLATE BIT,
	@CMCASETYPEID CHAR(36),
	@WKOTYPEID INT,
	@WKOTYPENAME VARCHAR(255),
	@WKOCLASSID INT,
	@WKOCLASSNAME VARCHAR(255),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[WFACTION] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[WFACTIONTYPEID] = @WFACTIONTYPEID,
	[PASSDESCRIPTION] = @PASSDESCRIPTION,
	[FAILDESCRIPTION] = @FAILDESCRIPTION,
	[ALLOWREDO] = @ALLOWREDO,
	[REDODESCRIPTION] = @REDODESCRIPTION,
	[ICON] = @ICON,
	[DAYSTOCOMPLETE] = @DAYSTOCOMPLETE,
	[PLSUBMITTALTYPEID] = @PLSUBMITTALTYPEID,
	[MEETINGTYPEID] = @MEETINGTYPEID,
	[HEARINGTYPEID] = @HEARINGTYPEID,
	[WORKFLOWCOMPLETETYPEID] = @WORKFLOWCOMPLETETYPEID,
	[IMINSPECTIONTYPEID] = @IMINSPECTIONTYPEID,
	[PLPLANTYPEID] = @PLPLANTYPEID,
	[PLPLANWORKCLASSID] = @PLPLANWORKCLASSID,
	[PMPERMITTYPEID] = @PMPERMITTYPEID,
	[PMPERMITWORKCLASSID] = @PMPERMITWORKCLASSID,
	[PLPLANACTIVITYTYPEID] = @PLPLANACTIVITYTYPEID,
	[PMPERMITACTIVITYTYPEID] = @PMPERMITACTIVITYTYPEID,
	[CMCODEACTIVITYTYPEID] = @CMCODEACTIVITYTYPEID,
	[RPTREPORTID] = @RPTREPORTID,
	[RPTFRMTOBUSOBJMAPID] = @RPTFRMTOBUSOBJMAPID,
	[BLLICENSETYPEID] = @BLLICENSETYPEID,
	[BLLICENSECLASSID] = @BLLICENSECLASSID,
	[BLLICENSEACTIVITYTYPEID] = @BLLICENSEACTIVITYTYPEID,
	[TASKTYPEID] = @TASKTYPEID,
	[CMCODEID] = @CMCODEID,
	[IMINSPECTIONCASETYPEID] = @IMINSPECTIONCASETYPEID,
	[ILLICENSEACTIVITYTYPEID] = @ILLICENSEACTIVITYTYPEID,
	[EXAMTYPEID] = @EXAMTYPEID,
	[CAFEETEMPLATEID] = @CAFEETEMPLATEID,
	[ISAUTOINVOICE] = @ISAUTOINVOICE,
	[ISREQUIREDFULLPAYMNENT] = @ISREQUIREDFULLPAYMNENT,
	[OMOBJECTTYPEID] = @OMOBJECTTYPEID,
	[OMOBJECTCLASSIFICATIONID] = @OMOBJECTCLASSIFICATIONID,
	[COMPUTEFEEACTIONTYPEID] = @COMPUTEFEEACTIONTYPEID,
	[ISUSEACTIONDATEASFEEDATE] = @ISUSEACTIONDATEASFEEDATE,
	[ISCOMPUTEMAINFEETEMPLATE] = @ISCOMPUTEMAINFEETEMPLATE,
	[CMCASETYPEID] = @CMCASETYPEID,
	[WKOTYPEID] = @WKOTYPEID,
	[WKOTYPENAME] = @WKOTYPENAME,
	[WKOCLASSID] = @WKOCLASSID,
	[WKOCLASSNAME] = @WKOCLASSNAME,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[WFACTIONID] = @WFACTIONID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE