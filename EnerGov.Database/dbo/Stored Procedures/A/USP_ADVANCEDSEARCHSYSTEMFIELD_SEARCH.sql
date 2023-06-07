﻿CREATE PROCEDURE [dbo].[USP_ADVANCEDSEARCHSYSTEMFIELD_SEARCH]
(
 @SEARCHCRITERIANAME [nvarchar](100),
 @SEARCHMODULEID INT,
 @PAGE_NUMBER INT,
 @PAGE_SIZE INT 
)
AS
BEGIN
SELECT [dbo].[ADVANCEDSEARCHSYSTEMFIELD].ADVANCEDSEARCHSYSTEMFIELDID,
CASE WHEN (TEMP.NEWLABEL IS NOT NULL OR TEMP.NEWLABEL <> '') THEN TEMP.NEWLABEL ELSE [dbo].[ADVANCEDSEARCHSYSTEMFIELD].NAME END AS NAME,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].FIELDTYPEID,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].FIELDMODULEID,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].WORDSEARCHPATH,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].CHARACTERSEARCHPATH,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].DISPLAYPATH,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].ALLOWSORT,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].ALLOWOUTPUT,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].DISABLEWORDSEARCH,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].PARENTID,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].DEFAULTOUTPUT,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].SEARCHTYPEID,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].DEFAULTOUTPUTORDER,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].DISABLEAGGREGATION,
[dbo].[ADVANCEDSEARCHSYSTEMFIELD].LABEL,
COUNT(1) OVER() AS TotalRows FROM [dbo].[ADVANCEDSEARCHSYSTEMFIELD]
JOIN [dbo].[ADVANCEDSEARCHMODULESYSTEMFIELDMODULE] ON  [ADVANCEDSEARCHSYSTEMFIELD].[FIELDMODULEID] = [ADVANCEDSEARCHMODULESYSTEMFIELDMODULE].[ADVANCEDSEARCHSYSTEMFIELDMODULEID]
LEFT JOIN (
		SELECT [dbo].[ADVANCEDSEARCHADDRESSFIELDSETUP].ADVANCEDSEARCHSYSTEMFIELDID, [dbo].[ADDRESSLAYOUTSETUP].NEWLABEL FROM [dbo].[ADVANCEDSEARCHADDRESSFIELDSETUP]
		INNER JOIN [dbo].[ADDRESSLAYOUTSETUP] ON [ADDRESSLAYOUTSETUP].[ADDRESSLAYOUTSETUPID] = [ADVANCEDSEARCHADDRESSFIELDSETUP].[ADDRESSLAYOUTSETUPID]
		) AS TEMP ON TEMP.ADVANCEDSEARCHSYSTEMFIELDID = [ADVANCEDSEARCHSYSTEMFIELD].[ADVANCEDSEARCHSYSTEMFIELDID]
WHERE (((TEMP.NEWLABEL IS NOT NULL OR TEMP.NEWLABEL <> '') AND TEMP.[NEWLABEL] LIKE '%'+@SEARCHCRITERIANAME+'%')
OR ((TEMP.NEWLABEL IS NULL OR TEMP.NEWLABEL = '') AND [ADVANCEDSEARCHSYSTEMFIELD].[NAME] LIKE '%'+@SEARCHCRITERIANAME+'%'))
AND [ADVANCEDSEARCHMODULESYSTEMFIELDMODULE].[ADVANCEDSEARCHMODULEID] = @SEARCHMODULEID
END