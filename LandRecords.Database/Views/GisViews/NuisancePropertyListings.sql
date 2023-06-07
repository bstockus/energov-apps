CREATE VIEW [gisviews].[NuisancePropertyListings]
	AS 
SELECT
  x.*,
  CASE
    WHEN x.DaysInLastYear >= 4 THEN 5
    WHEN x.DaysInLastYear = 3 THEN 4
    WHEN x.DaysInLastYear = 2 THEN 3
    WHEN x.DaysInLastYear = 1 THEN 2
    WHEN x.DaysInLastYear = 0 AND x.TotalViolations <> 0 THEN 1
    ELSE 0 END AS "Color"
FROM (SELECT
  parcelOverview.ParcelNumber,
  parcelOverview.OwnerName,
  parcelOverview.Addresses,
  parcelOverview.PLSSLocation,
  parcelOverview.LegalDescription,
  (SELECT COUNT(*) FROM NuisanceProperties np WHERE np.Parcel = parcelOverview.ParcelNumber) AS "TotalViolations",
  (SELECT COUNT(*) FROM NuisanceProperties np WHERE np.Parcel = parcelOverview.ParcelNumber AND DATEADD(year, -1, GETDATE()) <= np.Date) AS "ViolationsInLastYear",
  (SELECT COUNT(DISTINCT CONVERT(date, np.Date)) FROM NuisanceProperties np WHERE np.Parcel = parcelOverview.ParcelNumber AND DATEADD(year, -1, GETDATE()) <= np.Date) AS "DaysInLastYear"
FROM [ParcelOverview] parcelOverview
WHERE parcelOverview.ParcelNumber LIKE '17-%') x
