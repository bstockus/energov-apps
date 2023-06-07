--This script will enable/disable triggers that will stage updates for ElasticSearch index.
--The target for this script is the data conversion process, where all of these triggers
--would need to be disabled while mass data commits are performed.  Then, the triggers can
--be reenabled after all is done.
CREATE PROCEDURE [uspEnableElasticSearchTriggers]
    @enableFlag BIT = 'True'	--Ensable triggers by default.
AS
BEGIN
	DECLARE @triggerName NVARCHAR(200),
	@tableName NVARCHAR(100),
	@sqlStatement NVARCHAR(500),
	@sqlActionKeyword NVARCHAR(10);

	SET @sqlActionKeyword = CASE WHEN @enableFlag = 'True' THEN 'ENABLE' ELSE 'DISABLE' END;
	
	DECLARE cursor_triggers CURSOR FAST_FORWARD READ_ONLY FOR 
	SELECT [TAB].[name], [T].[name]  
	FROM sys.[triggers] AS [T]
	JOIN sys.[tables] AS [TAB] ON [TAB].[object_id] = [T].[parent_id]
	WHERE [T].[name] LIKE 'TG%ELASTIC%'
	AND [T].[name] != 'TG_ELASTIC_INSERT_RECORDCHANGETRACKQUEUE'

	OPEN cursor_triggers
	
	FETCH NEXT FROM cursor_triggers INTO @tableName, @triggerName
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @sqlStatement = @sqlActionKeyword + ' TRIGGER [' + @triggerName + '] ON [' + @tableName + ']'
		 EXEC sp_executesql @sqlStatement;
	
	    FETCH NEXT FROM cursor_triggers INTO @tableName, @triggerName
	END
	
	CLOSE cursor_triggers
	DEALLOCATE cursor_triggers

	
END