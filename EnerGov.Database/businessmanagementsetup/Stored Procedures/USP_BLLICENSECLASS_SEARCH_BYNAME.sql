﻿CREATE PROCEDURE [businessmanagementsetup].[USP_BLLICENSECLASS_SEARCH_BYNAME]  
(  
 @SEARCH AS NVARCHAR(MAX) = '',  
 @PAGE_NUMBER AS INT = 1,  
 @PAGE_SIZE AS INT = 10,  
 @IS_ASCENDING AS BIT = 1  
)  
AS  
WITH RAW_DATA AS (  
 SELECT  
  [dbo].[BLLICENSECLASS].[BLLICENSECLASSID],  
  [dbo].[BLLICENSECLASS].[NAME],  
  CASE @IS_ASCENDING WHEN 1 THEN  
   ROW_NUMBER() OVER(ORDER BY [dbo].[BLLICENSECLASS].[NAME])  
  ELSE  
   ROW_NUMBER() OVER(ORDER BY [dbo].[BLLICENSECLASS].[NAME] DESC)  
  END AS RowNumber,  
  COUNT(1) OVER() AS TotalRows  
 FROM [dbo].[BLLICENSECLASS]  
 WHERE ([dbo].[BLLICENSECLASS].[NAME] LIKE '%'+ @SEARCH +'%')  
)  
  
SELECT *   
FROM RAW_DATA  
WHERE  
 RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND   
 RowNumber <= @PAGE_SIZE * @PAGE_NUMBER  
ORDER BY   
 RowNumber