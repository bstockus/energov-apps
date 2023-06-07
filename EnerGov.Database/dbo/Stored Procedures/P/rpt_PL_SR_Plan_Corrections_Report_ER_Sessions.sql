﻿
CREATE PROCEDURE [dbo].[rpt_PL_SR_Plan_Corrections_Report_ER_Sessions]
@PLPLANID AS VARCHAR(36)
AS

DECLARE @SQL AS VARCHAR(MAX);
IF EXISTS (SELECT * FROM SYS.TABLES WHERE [NAME] = 'ERENTITYPROJECTSESSIONFILE')
SET @SQL = 
'
	SELECT S.PLPLANID
		, ES.ERENTITYSESSIONID, ES.SESSIONNAME
		, S.PLSUBMITTALID
		, ST.[TYPENAME]
		, PF.[FILENAME]
		, FM.AUTHOR, FM.MARKUPTYPE, FM.COMMENTS, FM.PAGENUMBER, FM.CREATEDON
		, WFAS.VERSIONNUMBER WFASVERSION
		, WFS.VERSIONNUMBER WFSVERSION
		, STUFF((SELECT DISTINCT ''||'' + PF1.[FILENAME]
			FROM ERENTITYPROJECTSESSIONFILE EPSF1
			INNER JOIN ERPROJECTFILEVERSION PFV1 ON EPSF1.ERPROJECTFILEVERSIONID = PFV1.ERPROJECTFILEVERSIONID
			INNER JOIN ERPROJECTFILE PF1 ON PFV1.ERPROJECTFILEID = PF1.ERPROJECTFILEID
			WHERE EPSF1.ERENTITYSESSIONID = ES.ERENTITYSESSIONID
			FOR XML PATH(''''), root(''MyString''), type
			).value(''/MyString[1]'',''varchar(max)''),1,2,''''
		  ) FILELIST
		, ROW_NUMBER () OVER (
			PARTITION BY S.PLPLANID
			ORDER BY WFS.PRIORITYORDER, WFS.SORTORDER, WFS.VERSIONNUMBER, WFS.[NAME], WFAS.PRIORITYORDER, WFAS.SORTORDER, WFAS.VERSIONNUMBER, WFAS.[NAME], FM.CREATEDON
		 ) SORTORD
	FROM PLSUBMITTAL S
	INNER JOIN PLSUBMITTALTYPE ST ON S.PLSUBMITTALTYPEID = ST.PLSUBMITTALTYPEID
	INNER JOIN ERENTITYSESSION ES ON S.PLSUBMITTALID = ES.PLSUBMITTALID
	INNER JOIN ERENTITYPROJECTSESSIONFILE EPSF ON ES.ERENTITYSESSIONID = EPSF.ERENTITYSESSIONID
	INNER JOIN ERPROJECTFILEVERSION PFV ON EPSF.ERPROJECTFILEVERSIONID = PFV.ERPROJECTFILEVERSIONID
	INNER JOIN ERPROJECTFILE PF ON PFV.ERPROJECTFILEID = PF.ERPROJECTFILEID
	INNER JOIN ERFILEMARKUP FM ON PFV.ERPROJECTFILEVERSIONID = FM.ERPROJECTFILEVERSIONID
	INNER JOIN PLPLANWFACTIONSTEP WFAS ON S.PLPLANWFACTIONSTEPID = WFAS.PLPLANWFACTIONSTEPID
	INNER JOIN PLPLANWFSTEP WFS ON WFAS.PLPLANWFSTEPID = WFS.PLPLANWFSTEPID
	WHERE S.PLPLANID = ''' + @PLPLANID + '''
	ORDER BY SORTORD
'

BEGIN

IF OBJECT_ID('tempdb.dbo.#MAINDATA') IS NOT NULL
	DROP TABLE #MAINDATA;
CREATE TABLE #MAINDATA (PLPLANID VARCHAR(36), ERENTITYSESSIONID VARCHAR(36), SESSIONNAME VARCHAR(100), PLSUBMITTALID VARCHAR(36), TYPENAME VARCHAR(50)
	, [FILENAME] VARCHAR(200), AUTHOR VARCHAR(100), MARKUPTYPE VARCHAR(50), COMMENTS VARCHAR(MAX), PAGENUMBER INT, CREATEDON DATETIME, WFASVERSION INT
	, WFSVERSION INT, FILELIST VARCHAR(MAX), SORTORD INT);

INSERT INTO #MAINDATA
	EXECUTE(@SQL);

SELECT * 
FROM #MAINDATA

--SELECT S.PLPLANID
--	, ES.ERENTITYSESSIONID, ES.SESSIONNAME
--	, S.PLSUBMITTALID
--	, ST.[TYPENAME]
--	, PF.[FILENAME]
--	, FM.AUTHOR, FM.MARKUPTYPE, FM.COMMENTS, FM.PAGENUMBER, FM.CREATEDON
--	, WFAS.VERSIONNUMBER WFASVERSION
--	, WFS.VERSIONNUMBER WFSVERSION
--	, STUFF((SELECT DISTINCT '||' + PF1.[FILENAME]
--		FROM ERENTITYPROJECTSESSIONFILE EPSF1
--		INNER JOIN ERPROJECTFILEVERSION PFV1 ON EPSF1.ERPROJECTFILEVERSIONID = PFV1.ERPROJECTFILEVERSIONID
--		INNER JOIN ERPROJECTFILE PF1 ON PFV1.ERPROJECTFILEID = PF1.ERPROJECTFILEID
--		WHERE EPSF1.ERENTITYSESSIONID = ES.ERENTITYSESSIONID
--		FOR XML PATH(''), root('MyString'), type
--		).value('/MyString[1]','varchar(max)'),1,2,''
--	  ) FILELIST
--	, ROW_NUMBER () OVER (
--		PARTITION BY S.PLPLANID
--		ORDER BY WFS.PRIORITYORDER, WFS.SORTORDER, WFS.VERSIONNUMBER, WFS.[NAME], WFAS.PRIORITYORDER, WFAS.SORTORDER, WFAS.VERSIONNUMBER, WFAS.[NAME], FM.CREATEDON
--	 ) SORTORD
--FROM PLSUBMITTAL S
--INNER JOIN PLSUBMITTALTYPE ST ON S.PLSUBMITTALTYPEID = ST.PLSUBMITTALTYPEID
--INNER JOIN ERENTITYSESSION ES ON S.PLSUBMITTALID = ES.PLSUBMITTALID
--INNER JOIN ERENTITYPROJECTSESSIONFILE EPSF ON ES.ERENTITYSESSIONID = EPSF.ERENTITYSESSIONID
--INNER JOIN ERPROJECTFILEVERSION PFV ON EPSF.ERPROJECTFILEVERSIONID = PFV.ERPROJECTFILEVERSIONID
--INNER JOIN ERPROJECTFILE PF ON PFV.ERPROJECTFILEID = PF.ERPROJECTFILEID
--INNER JOIN ERFILEMARKUP FM ON PFV.ERPROJECTFILEVERSIONID = FM.ERPROJECTFILEVERSIONID
--INNER JOIN PLPLANWFACTIONSTEP WFAS ON S.PLPLANWFACTIONSTEPID = WFAS.PLPLANWFACTIONSTEPID
--INNER JOIN PLPLANWFSTEP WFS ON WFAS.PLPLANWFSTEPID = WFS.PLPLANWFSTEPID
--WHERE S.PLPLANID = @PLPLANID
--ORDER BY SORTORD

END