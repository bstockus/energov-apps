﻿CREATE PROCEDURE [globalsetup].[USP_CAFEECONSTANTVALUE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CAFEECONSTANTVALUE].[CAFEECONSTANTVALUEID],
	[dbo].[CAFEECONSTANTVALUE].[CAFEECONSTANTID],
	[dbo].[CAFEECONSTANTVALUE].[VALUE],
	[dbo].[CAFEECONSTANTVALUE].[CASCHEDULEID]
FROM 
	[dbo].[CAFEECONSTANTVALUE] 
ORDER BY
	[dbo].[CAFEECONSTANTVALUE].[VALUE]
		
END