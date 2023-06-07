CREATE FUNCTION [laxanalytics].[ReleventBuildingOTCs]
(
	@StartDate DATETIME,
	@EndDate DATETIME
)
RETURNS @ReleventOTCs TABLE
(
  OTCType varchar(100),
  OTCCategory varchar(100),
  IsRental bit,
  StartDate datetime,
  EndDate datetime,
  DaysToResolve int,
  Age int,
  IsStarting bit,
  IsEnding bit,
  IsOpened bit,
  IsClosed bit,
  IsCompliant bit,
  OTCNumber varchar(50)
)
AS
BEGIN
	DECLARE @ModifiedStartDate AS DATETIME;
	DECLARE @ModifiedEndDate AS DATETIME;
	
	SET @ModifiedStartDate = CONVERT(DATETIME2, @StartDate);
	SET @ModifiedEndDate = DATEADD(second, -1, DATEADD(day, 1, CONVERT(DATETIME2, @EndDate)));

	INSERT INTO @ReleventOTCs
	SELECT
	  c.DESCRIPTION AS "OTCType",
	  ccat.NAME AS "OTCCategory",
	  CASE ISNULL(cscm.RentalProperty, 'efcca56d-724e-4f07-95e5-cf613c612adf') WHEN 'efcca56d-724e-4f07-95e5-cf613c612adf' THEN 1 ELSE 0 END AS "IsRental",
	  viol.CITATIONISSUEDATE AS "StartDate",
	  viol.RESOLVEDDATE AS "EndDate",
	  DATEDIFF(day, viol.CITATIONISSUEDATE, viol.RESOLVEDDATE) AS "DaysToResolve",
	  DATEDIFF(day, viol.CITATIONISSUEDATE, ISNULL(viol.RESOLVEDDATE, @ModifiedEndDate)) AS "Age",
	  CASE WHEN viol.CITATIONISSUEDATE < @ModifiedStartDate THEN 1 ELSE 0 END AS "IsStarting",
	  CASE WHEN (viol.RESOLVEDDATE IS NULL OR viol.RESOLVEDDATE > @ModifiedEndDate) THEN 1 ELSE 0 END AS "IsEnding",
	  CASE WHEN viol.CITATIONISSUEDATE BETWEEN @ModifiedStartDate AND @ModifiedEndDate THEN 1 ELSE 0 END AS "IsOpened",
	  CASE WHEN viol.RESOLVEDDATE BETWEEN @ModifiedStartDate AND @ModifiedEndDate THEN 1 ELSE 0 END AS "IsClosed",
	  CASE WHEN (viol.RESOLVEDDATE IS NULL OR viol.RESOLVEDDATE > @ModifiedEndDate) THEN 0 ELSE 1 END AS "IsCompliant",
	  cc.CASENUMBER AS "OTCNumber"
	FROM [$(EnerGovDatabase)].[dbo].CMCODECASE cc
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMCODEWFSTEP cwfs ON cc.CMCODECASEID = cwfs.CMCODECASEID
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMCODECASESTATUS ccs ON cc.CMCODECASESTATUSID = ccs.CMCODECASESTATUSID
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMCASETYPE ct ON cc.CMCASETYPEID = ct.CMCASETYPEID
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMCODEWFACTIONSTEP cwfas ON cwfs.CMCODEWFSTEPID = cwfas.CMCODEWFSTEPID AND cwfas.VERSIONNUMBER = 1
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMVIOLATION viol ON cwfas.CMCODEWFACTIONSTEPID = viol.CMCODEWFACTIONID
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMCODEREVISION cr ON viol.CMCODEREVISIONID = cr.CMCODEREVISIONID AND cr.[CURRENTREVISION] = 1
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMCODE c ON cr.CMCODEID = c.CMCODEID
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMVIOLATIONSTATUS violstat ON viol.CMVIOLATIONSTATUSID = violstat.CMVIOLATIONSTATUSID
	INNER JOIN [$(EnerGovDatabase)].[dbo].CMCODECATEGORY ccat ON c.CMCODECATEGORYID = ccat.CMCODECATEGORYID
	LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].CUSTOMSAVERCODEMANAGEMENT cscm ON cc.CMCODECASEID = cscm.ID
	WHERE
	  (viol.CITATIONISSUEDATE >= @ModifiedStartDate AND viol.CITATIONISSUEDATE <= @ModifiedEndDate OR
	  viol.RESOLVEDDATE >= @ModifiedStartDate AND viol.RESOLVEDDATE <= @ModifiedEndDate OR
		(viol.CITATIONISSUEDATE < @ModifiedStartDate AND (viol.RESOLVEDDATE IS NULL OR viol.RESOLVEDDATE > @ModifiedEndDate))) AND
	  cc.CASENUMBER NOT LIKE 'CONV-%';
	RETURN
END
