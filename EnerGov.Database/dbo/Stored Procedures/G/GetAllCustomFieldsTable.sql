
CREATE PROCEDURE [dbo].[GetAllCustomFieldsTable]
       (
	  --@ReportId AS CHAR(36),
	  @ids AS IdTableType READONLY
	  )
AS
BEGIN
      SET NOCOUNT ON;
    
      DECLARE @queries TABLE
              (CustomTable VARCHAR(28)
              ,LayoutId CHAR(36)
              ,[Ids] NVARCHAR(MAX));

      INSERT    INTO @queries
                ([CustomTable]
                ,[LayoutId]
                ,[Ids])
      SELECT    [eclr].[CustomTable]
               ,[eclr].[LayoutId]
               ,'(' + STUFF((SELECT ',''' + [eclr2].[Id] + ''''
                             FROM   [EntityCustomLayoutRef] AS [eclr2]
                             WHERE  [eclr2].[LayoutId] = [eclr].[LayoutId]
                                    AND [eclr2].[CustomTable] = [eclr].[CustomTable]
                                    AND [eclr2].[Id] IN (SELECT Id
                                                         FROM   @ids)
                FOR         XML PATH('')
                               ,ROOT('strings')
                               ,TYPE).value('/', 'NVarchar(MAX)'), 1, 1, '') + ')' AS [Ids]
      FROM      (
                 SELECT DISTINCT
                        [CustomTable]
                       ,[LayoutId]
                 FROM   [dbo].[EntityCustomLayoutRef]
                 WHERE  [Id] IN (SELECT [Id]
                                 FROM   @ids)
                ) AS [eclr];
                
      IF OBJECT_ID('tempdb..#vals') IS NOT NULL
         DROP TABLE #vals;
	   
      CREATE TABLE #vals
             ([Id] CHAR(36)
             ,[Values] NVARCHAR(MAX));

	 /* declare variables */
      DECLARE @query NVARCHAR(MAX);
	 
      DECLARE customFieldCursor CURSOR FAST_FORWARD READ_ONLY
      FOR
      SELECT    query.query
      FROM      @queries [q]
      OUTER APPLY (
                   SELECT   'INSERT INTO #vals(Id, [Values])
			    SELECT pm1.[ID] AS [Id], ''''' + [s].query('/strings/All').value('/', 'Nvarchar(max)') + ' as [AllValues]
			    FROM [dbo].[' + [q].[CustomTable] + '] [pm1] 
			    JOIN [dbo].[' + [q].[CustomTable] + '2] [pm2] ON [pm1].[ID] = [pm2].[ID]
			    WHERE [pm1].[ID] IN ' + [q].[Ids] AS query
                   FROM     (
                             SELECT (
                                     SELECT ' + ISNULL(''<b>' + CASE WHEN [obj].[ISLABELSURPRESSED] = 1 THEN c2.[SCUSTOMFIELD]
                                                                     ELSE [obj].[SLABEL]
                                                                END + ':</b> '' + NULLIF(CONVERT(VARCHAR(4000),'
                                            + CASE WHEN obj.[FKCUSTOMFIELDLAYOUTCONTROLTYPE] IN (1) THEN '[' + c2.[SFIELDNAME] + ']'
                                                   WHEN obj.[FKCUSTOMFIELDLAYOUTCONTROLTYPE] = 2
                                                        AND [pickList].[BALLOWMULTIPLESELECTIONS] = 0
                                                   THEN '(SELECT TOP 1 [c].[SVALUE] FROM [CUSTOMFIELDPICKLISTITEM] AS [c] WHERE [c].[FKGCUSTOMFIELDPICKLIST] = '''
                                                        + [pickList].[GCUSTOMFIELDPICKLIST] + ''' AND [c].[GCUSTOMFIELDPICKLISTITEM] = [' + [c2].[SFIELDNAME]
                                                        + '])'
                                                   WHEN [obj].[FKCUSTOMFIELDLAYOUTCONTROLTYPE] = 2
                                                        AND [pickList].[BALLOWMULTIPLESELECTIONS] = 1
                                                   THEN '[dbo].[GetMultiSelectValue](pm1.[ID],''' + [c2].[GCUSTOMFIELD] + ''')'
                                                   WHEN [obj].[FKCUSTOMFIELDLAYOUTCONTROLTYPE] = 3
                                                   THEN 'CASE WHEN COALESCE([' + [c2].[SFIELDNAME] + '],0) = 0 THEN ''No'' ELSE ''Yes'' END'
                                              END + '),'''') + ''<br>'' + CHAR(13) + CHAR(10),'''')' AS [All]
                                     FROM   [CUSTOMFIELDLAYOUT] AS [c]
                                     JOIN   [CUSTOMFIELDOBJECT] AS [obj]
                                            ON [obj].[FKGCUSTOMFIELDLAYOUT] = [c].[GCUSTOMFIELDLAYOUTS]
                                     LEFT JOIN [CUSTOMFIELDOBJECT] AS [tab]
                                            ON tab.[GCUSTOMFIELD] = [obj].[FKGPARENTCONTROL]
                                     JOIN   [CUSTOMFIELD] AS [c2]
                                            ON [c2].[GCUSTOMFIELD] = [obj].[GCUSTOMFIELD]
                                     LEFT JOIN [CUSTOMFIELDPICKLIST] AS [pickList]
                                            ON [pickList].[FKGCUSTOMFIELD] = [c2].[GCUSTOMFIELD]
                                     --JOIN   [RPTCUSTOMFIELD] AS [r]
                                     --       ON [r].[REPORTID] = @ReportId
                                     --          AND [r].[CUSTOMFIELDOBJECTID] = [obj].[GCUSTOMFIELD]
                                     WHERE  [c].[GCUSTOMFIELDLAYOUTS] = [q].LayoutId
                                            AND [c2].[SFIELDNAME] != ''
                                            AND [obj].[FKCUSTOMFIELDLAYOUTCONTROLTYPE] IN (1, 2, 3)
                                     ORDER BY [tab].[TABINDEX]
                                           ,[obj].[TABINDEX]
                                           ,[obj].[FTOPPOS]
                                           ,[obj].[FLEFTPOS]
                                    FOR
                                     XML PATH('')
                                        ,ROOT('strings')
                                        ,TYPE
                                    ) AS [s]
                            ) AS [s]
                  ) AS query;
	 
      OPEN customFieldCursor;
	 
      FETCH NEXT FROM customFieldCursor INTO @query;
	 
      WHILE @@FETCH_STATUS = 0
            BEGIN

                  EXEC sp_executesql @stmt = @query;

                  FETCH NEXT FROM customFieldCursor INTO @query;
            END;
	 
      CLOSE customFieldCursor;
      DEALLOCATE customFieldCursor;

      SELECT    [i].[Id]
               ,ISNULL([v].[Values], '')
      FROM      @ids AS [i]
      LEFT JOIN #vals AS [v]
                ON [v].[Id] = [i].[Id];

END;
