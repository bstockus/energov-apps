CREATE FUNCTION [laxanalytics].[OTCPerformanceByTypeForPeriod]
(
	@StartDate datetime,
	@EndDate datetime
)
RETURNS @returntable TABLE
(
	OTCType varchar(100),
	OTCCategory varchar(100),
	TotalCount int,
	RentalCount int,
	Starting int,
	Ending int,
	Opened int,
	Closed int,
	RentalStarting int,
	RentalEnding int,
	RentalOpened int,
	RentalClosed int,
	Compliant int,
	RentalCompliant int,
	AverageDaysToResolve int,
	RentalAverageDaysToResolve int,
	AverageAgeOfOpen int,
	RentalAverageAgeOfOpen int,
	ComparisonTotalCount int,
	ComparisonRentalCount int,
	ComparisonStarting int,
	ComparisonEnding int,
	ComparisonOpened int,
	ComparisonClosed int,
	ComparisonRentalStarting int,
	ComparisonRentalEnding int,
	ComparisonRentalOpened int,
	ComparisonRentalClosed int,
	ComparisonCompliant int,
	ComparisonRentalCompliant int,
	ComparisonAverageDaysToResolve int,
	ComparisonRentalAverageDaysToResolve int,
	ComparisonAverageAgeOfOpen int,
	ComparisonRentalAverageAgeOfOpen int
)
AS
BEGIN

	DECLARE @ComparisonStartDate AS datetime;

	SET @ComparisonStartDate = CAST(CAST(YEAR(@StartDate) AS varchar) + '-01-01' AS datetime);

	DECLARE @ReleventComparisonOTCs TABLE
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
		IsCompliant bit
	);

	INSERT INTO @ReleventComparisonOTCs
	SELECT
	  c.DESCRIPTION AS "OTCType",
	  '' AS "OTCCategory",
	  CASE ISNULL(cscm.RentalProperty, 'efcca56d-724e-4f07-95e5-cf613c612adf') WHEN 'efcca56d-724e-4f07-95e5-cf613c612adf' THEN 1 ELSE 0 END AS "IsRental",
	  cc.OPENEDDATE AS "StartDate",
	  ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) AS "EndDate",
	  DATEDIFF(day, cc.OPENEDDATE, ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE)) AS "DaysToResolve",
	  DATEDIFF(day, cc.OPENEDDATE, ISNULL(ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE), @EndDate)) AS "Age",
	  CASE WHEN cc.OPENEDDATE < @ComparisonStartDate THEN 1 ELSE 0 END AS "IsStarting",
	  CASE WHEN (ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) IS NULL OR ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) > @EndDate) THEN 1 ELSE 0 END AS "IsEnding",
	  CASE WHEN cc.OPENEDDATE BETWEEN @ComparisonStartDate AND @EndDate THEN 1 ELSE 0 END AS "IsOpened",
	  CASE WHEN ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) BETWEEN @ComparisonStartDate AND @EndDate THEN 1 ELSE 0 END AS "IsClosed",
	  CASE WHEN (ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) IS NULL OR ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) > @EndDate) THEN 0 ELSE 1 END AS "IsCompliant"
	FROM [$(EnerGovDatabase)].dbo.CMCODECASE cc
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cc.CMCODECASEID = cwfs.CMCODECASEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODECASESTATUS ccs ON cc.CMCODECASESTATUSID = ccs.CMCODECASESTATUSID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCASETYPE ct ON cc.CMCASETYPEID = ct.CMCASETYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas ON cwfs.CMCODEWFSTEPID = cwfas.CMCODEWFSTEPID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMVIOLATION viol ON cwfas.CMCODEWFACTIONSTEPID = viol.CMCODEWFACTIONID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEREVISION cr ON viol.CMCODEREVISIONID = cr.CMCODEREVISIONID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODE c ON cr.CMCODEID = c.CMCODEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMVIOLATIONSTATUS violstat ON viol.CMVIOLATIONSTATUSID = violstat.CMVIOLATIONSTATUSID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODECASEPARCEL ccp ON cc.CMCODECASEID = ccp.CMCODECASEID AND ccp.[PRIMARY] = 1
	INNER JOIN [$(EnerGovDatabase)].dbo.PARCEL par ON ccp.PARCELID = par.PARCELID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERCODEMANAGEMENT cscm ON cc.CMCODECASEID = cscm.ID
	WHERE
	  c.CMCODECATEGORYID = '93fe5ff3-2372-41ec-9502-2897b8d882f9' AND
	  (cc.OPENEDDATE BETWEEN @ComparisonStartDate AND @EndDate OR
		ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) BETWEEN @ComparisonStartDate AND @EndDate OR
		  (cc.OPENEDDATE < @ComparisonStartDate AND (ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) IS NULL OR ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) > @EndDate))) AND
	  cc.CASENUMBER NOT LIKE 'CONV-%';

	DECLARE @ReleventOTCs TABLE
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
		IsCompliant bit
	);

	INSERT INTO @ReleventOTCs
	SELECT
	  c.DESCRIPTION AS "OTCType",
	  '' AS "OTCCategory",
	  CASE ISNULL(cscm.RentalProperty, 'efcca56d-724e-4f07-95e5-cf613c612adf') WHEN 'efcca56d-724e-4f07-95e5-cf613c612adf' THEN 1 ELSE 0 END AS "IsRental",
	  cc.OPENEDDATE AS "StartDate",
	  ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) AS "EndDate",
	  DATEDIFF(day, cc.OPENEDDATE, ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE)) AS "DaysToResolve",
	  DATEDIFF(day, cc.OPENEDDATE, ISNULL(ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE), @EndDate)) AS "Age",
	  CASE WHEN cc.OPENEDDATE < @StartDate THEN 1 ELSE 0 END AS "IsStarting",
	  CASE WHEN (ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) IS NULL OR ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) > @EndDate) THEN 1 ELSE 0 END AS "IsEnding",
	  CASE WHEN cc.OPENEDDATE BETWEEN @StartDate AND @EndDate THEN 1 ELSE 0 END AS "IsOpened",
	  CASE WHEN ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) BETWEEN @StartDate AND @EndDate THEN 1 ELSE 0 END AS "IsClosed",
	  CASE WHEN (ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) IS NULL OR ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) > @EndDate) THEN 0 ELSE 1 END AS "IsCompliant"
	FROM [$(EnerGovDatabase)].dbo.CMCODECASE cc
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cc.CMCODECASEID = cwfs.CMCODECASEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODECASESTATUS ccs ON cc.CMCODECASESTATUSID = ccs.CMCODECASESTATUSID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCASETYPE ct ON cc.CMCASETYPEID = ct.CMCASETYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas ON cwfs.CMCODEWFSTEPID = cwfas.CMCODEWFSTEPID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMVIOLATION viol ON cwfas.CMCODEWFACTIONSTEPID = viol.CMCODEWFACTIONID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEREVISION cr ON viol.CMCODEREVISIONID = cr.CMCODEREVISIONID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODE c ON cr.CMCODEID = c.CMCODEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMVIOLATIONSTATUS violstat ON viol.CMVIOLATIONSTATUSID = violstat.CMVIOLATIONSTATUSID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODECASEPARCEL ccp ON cc.CMCODECASEID = ccp.CMCODECASEID AND ccp.[PRIMARY] = 1
	INNER JOIN [$(EnerGovDatabase)].dbo.PARCEL par ON ccp.PARCELID = par.PARCELID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERCODEMANAGEMENT cscm ON cc.CMCODECASEID = cscm.ID
	WHERE
	  c.CMCODECATEGORYID = '93fe5ff3-2372-41ec-9502-2897b8d882f9' AND
	  (cc.OPENEDDATE BETWEEN @StartDate AND @EndDate OR
		ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) BETWEEN @StartDate AND @EndDate OR
		  (cc.OPENEDDATE < @StartDate AND (ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) IS NULL OR ISNULL(viol.RESOLVEDDATE, cc.CLOSEDDATE) > @EndDate))) AND
	  cc.CASENUMBER NOT LIKE 'CONV-%';

	DECLARE @ReleventTypes TABLE
	(
		OTCType varchar(100),
		OTCCategory varchar(100)
	);

	INSERT INTO @ReleventTypes
	SELECT
		relevOTCs.OTCType AS "OTCType",
		relevOTCs.OTCCategory AS "OTCCategory"
	FROM @ReleventComparisonOTCs relevOTCs
	GROUP BY relevOTCs.OTCCategory, relevOTCs.OTCType;
	
	INSERT @returntable
	SELECT 
		relevTypes.OTCType AS "OTCType",
		relevTypes.OTCCategory AS "OTCCategory",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType), 0) AS "TotalCount",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsRental = 1), 0) AS "RentalCount",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsStarting = 1), 0) AS "Starting",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsEnding = 1), 0) AS "Ending",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsOpened = 1), 0) AS "Opened",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsClosed = 1), 0) AS "Closed",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsStarting = 1 AND relevOTCs.IsRental = 1), 0) AS "RentalStarting",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsEnding = 1 AND relevOTCs.IsRental = 1), 0) AS "RentalEnding",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsOpened = 1 AND relevOTCs.IsRental = 1), 0) AS "RentalOpened",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsClosed = 1 AND relevOTCs.IsRental = 1), 0) AS "RentalClosed",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1 AND relevOTCs.IsOpened = 1), 0) AS "Compliant",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1 AND relevOTCs.IsRental = 1 AND relevOTCs.IsOpened = 1), 0) AS "RentalCompliant",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.DaysToResolve) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1), 0) AS "AverageDaysToResolve",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.DaysToResolve) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1 AND relevOTCs.IsRental = 1), 0) AS "RentalAverageDaysToResolve",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.Age) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 0), 0) AS "AverageAgeOfOpen",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.Age) FROM @ReleventOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 0 AND relevOTCs.IsRental = 1), 0) AS "RentalAverageAgeOfOpen",

		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType), 0) AS "ComparisonTotalCount",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsRental = 1), 0) AS "ComparisonRentalCount",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsStarting = 1), 0) AS "ComparisonStarting",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsEnding = 1), 0) AS "ComparisonEnding",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsOpened = 1), 0) AS "ComparisonOpened",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsClosed = 1), 0) AS "ComparisonClosed",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsStarting = 1 AND relevOTCs.IsRental = 1), 0) AS "ComparisonRentalStarting",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsEnding = 1 AND relevOTCs.IsRental = 1), 0) AS "ComparisonRentalEnding",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsOpened = 1 AND relevOTCs.IsRental = 1), 0) AS "ComparisonRentalOpened",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsClosed = 1 AND relevOTCs.IsRental = 1), 0) AS "ComparisonRentalClosed",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1 AND relevOTCs.IsOpened = 1), 0) AS "ComparisonCompliant",
		ISNULL((SELECT TOP 1 COUNT(*) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1 AND relevOTCs.IsRental = 1 AND relevOTCs.IsOpened = 1), 0) AS "ComparisonRentalCompliant",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.DaysToResolve) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1), 0) AS "ComparisonAverageDaysToResolve",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.DaysToResolve) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 1 AND relevOTCs.IsRental = 1), 0) AS "ComparisonRentalAverageDaysToResolve",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.Age) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 0), 0) AS "ComparisonAverageAgeOfOpen",
		ISNULL((SELECT TOP 1 AVG(relevOTCs.Age) FROM @ReleventComparisonOTCs relevOTCs WHERE relevOTCs.OTCType = relevTypes.OTCType AND relevOTCs.IsCompliant = 0 AND relevOTCs.IsRental = 1), 0) AS "ComparisonRentalAverageAgeOfOpen"
	FROM @ReleventTypes relevTypes;
	RETURN
END
