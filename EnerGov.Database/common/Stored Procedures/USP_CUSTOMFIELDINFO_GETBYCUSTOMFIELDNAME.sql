﻿CREATE PROCEDURE [common].[USP_CUSTOMFIELDINFO_GETBYCUSTOMFIELDNAME]
(
	@CUSTOMFIELDNAME NVARCHAR(MAX),
	@CUSTOMFIELDFRIENDLYNAME NVARCHAR(MAX),
    @USEFRIENDLYNAMEONLY bit = 0
)
AS
BEGIN
DECLARE @CUSTOMFIELDLIST RecordIds

	INSERT INTO @CUSTOMFIELDLIST
	SELECT TOP 1 [dbo].[CUSTOMFIELD].[GCUSTOMFIELD] FROM [dbo].[CUSTOMFIELD] 
	JOIN [dbo].[CUSTOMFIELDOBJECT] ON [dbo].[CUSTOMFIELD].[GCUSTOMFIELD] = [dbo].[CUSTOMFIELDOBJECT].[FKGCUSTOMFIELD]
	JOIN [dbo].[CUSTOMFIELDLAYOUT] ON [dbo].[CUSTOMFIELDOBJECT].[FKGCUSTOMFIELDLAYOUT] = [dbo].[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS]
	WHERE [dbo].[CUSTOMFIELD].[GCUSTOMFIELD] NOT IN (SELECT [dbo].[NONSEARCHABLE_CUSTOMFIELDSVIEW].[GCUSTOMFIELD] FROM [dbo].[NONSEARCHABLE_CUSTOMFIELDSVIEW]) 
	AND [dbo].[CUSTOMFIELD].[SFIELDNAME] = @CUSTOMFIELDNAME AND ([dbo].[CUSTOMFIELDOBJECT].[SLABEL] + ' (' + [dbo].[CUSTOMFIELDLAYOUT].[SNAME] + ')') = @CUSTOMFIELDFRIENDLYNAME
	ORDER BY [dbo].[CUSTOMFIELD].[SFIELDNAME]

IF NOT EXISTS (SELECT * FROM @CUSTOMFIELDLIST)
    INSERT INTO @CUSTOMFIELDLIST
	SELECT TOP 1 [dbo].[CUSTOMFIELD].[GCUSTOMFIELD] FROM [dbo].[CUSTOMFIELD] 
	JOIN [dbo].[CUSTOMFIELDOBJECT] ON [dbo].[CUSTOMFIELD].[GCUSTOMFIELD] = [dbo].[CUSTOMFIELDOBJECT].[FKGCUSTOMFIELD]
	JOIN [dbo].[CUSTOMFIELDLAYOUT] ON [dbo].[CUSTOMFIELDOBJECT].[FKGCUSTOMFIELDLAYOUT] = [dbo].[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS]
	WHERE [dbo].[CUSTOMFIELD].[GCUSTOMFIELD] NOT IN (SELECT [dbo].[NONSEARCHABLE_CUSTOMFIELDSVIEW].[GCUSTOMFIELD] FROM [dbo].[NONSEARCHABLE_CUSTOMFIELDSVIEW]) 
	AND [dbo].[CUSTOMFIELD].[SFIELDNAME] = @CUSTOMFIELDNAME AND @USEFRIENDLYNAMEONLY = 0
	ORDER BY [dbo].[CUSTOMFIELD].[SFIELDNAME]

SELECT 
	[CUSTOMFIELDLIST].[RECORDID] AS CUSTOMFIELDID,
	[dbo].[CUSTOMFIELD].[SFIELDNAME] AS CUSTOMFIELDNAME,
	[dbo].[CUSTOMFIELD].[FKICUSTOMFIELDTYPE] AS CUSTOMFIELDTYPEID,
	[dbo].[CUSTOMFIELDOBJECT].[SLABEL] AS CUSTOMFIELDLABELNAME,
	([dbo].[CUSTOMFIELDOBJECT].[SLABEL] + ' (' + [dbo].[CUSTOMFIELDLAYOUT].[SNAME] + ')') AS LABEL,
	([dbo].[CUSTOMFIELDOBJECT].[SLABEL] + ' (' + [dbo].[CUSTOMFIELD].[SFIELDNAME] + ', ' + [dbo].[CUSTOMFIELDTYPE].[SNAME] + ')') AS CUSTOMFIELDDISPLAYNAME,
	[dbo].[CUSTOMFIELDOBJECT].[FKCUSTOMFIELDLAYOUTCONTROLTYPE] AS CUSTOMFIELDLAYOUTCONTROLTYPE,
	[dbo].[CUSTOMFIELDTABLE].[NAME] AS CUSTOMFIELDTABLENAME
FROM [dbo].[CUSTOMFIELDOBJECT] 
JOIN @CUSTOMFIELDLIST CUSTOMFIELDLIST ON [dbo].[CUSTOMFIELDOBJECT].[GCUSTOMFIELD] = [CUSTOMFIELDLIST].[RECORDID]
JOIN [CUSTOMFIELD] ON [dbo].[CUSTOMFIELD].[GCUSTOMFIELD] = [CUSTOMFIELDLIST].[RECORDID]
JOIN [dbo].[CUSTOMFIELDTYPE] ON [dbo].[CUSTOMFIELD].[FKICUSTOMFIELDTYPE] = [dbo].[CUSTOMFIELDTYPE].[ICUSTOMFIELDTYPE]
JOIN [dbo].[CUSTOMFIELDLAYOUT] ON [dbo].[CUSTOMFIELDOBJECT].[FKGCUSTOMFIELDLAYOUT] = [dbo].[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS]
LEFT OUTER JOIN [dbo].[CUSTOMFIELDTABLE] ON [dbo].[CUSTOMFIELD].[FKCUSTOMFIELDTABLE] = [dbo].[CUSTOMFIELDTABLE].[CUSTOMFIELDTABLEID]
END