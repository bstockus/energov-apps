
CREATE PROCEDURE [osdba].[usp_RecompileRoutines]
   
WITH EXECUTE AS CALLER
AS
-------------------------------------------------------------------------------------
-- LJC 2014-02-12
-- * Added error trapping for call to sp_recompile
-- * Added schema to form a two part name for the routine to be marked for recompile
-- In some instances there can be a lock on the routine and when there is
-- it can't be marked for recompile; trying to make it for a recompile
-- results in the error "Lock request time out period exceeded".
-- This error and possibly other will now be logged.
-------------------------------------------------------------------------------------
-- LJC 2013-10-05
-- This stored procedure will recompile User Defined Routines that are called from a
-- computed column or check constraint.  Every once in a while, a client will report
-- an error where a UDF has changed and needs to be recompiled.
-- The solution to the error is to recompile the offending routine.
-- The conditions that lead to this error are not known. The only common thread
-- is it's limited to UDFs called from a computed column or check constraint.
-- Initially, this routine will be called from usp_RebuildIndexes since it is run
-- every night.
------------------------------------------------------------------------------------

BEGIN
   DECLARE @dtmRebuildStart     DATETIME = GETDATE (),
           @dtmRebuildEnd       DATETIME = GETDATE (),
           @strRoutineName      sysname  = 'UNDEFINED'

   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;
BEGIN TRY


-------------------------------------------------------
-- Set the LOCK_TIMEOUT to 5 seconds, this is scoped
-- to the session/connection only
-------------------------------------------------------
SET LOCK_TIMEOUT 5000;

-----------------------------------
-- Purge data more than 90 days old
-----------------------------------
DELETE FROM osdba.RecompileRoutinesErrorLog WHERE BummerDate    < DATEADD (dd, -90, CURRENT_TIMESTAMP);
DELETE FROM osdba.RecompileRoutinesLog      WHERE RecompileDate < DATEADD (dd, -90, CURRENT_TIMESTAMP);

DECLARE cursor_RoutineName
   CURSOR FOR
          SELECT LTRIM (RTRIM(cc.CONSTRAINT_SCHEMA)) + '.' + LTRIM(RTRIM(referenced_entity_name))
            FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
      INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE c
              ON cc.CONSTRAINT_NAME = c.CONSTRAINT_NAME
      CROSS APPLY sys.dm_sql_referenced_entities ('dbo.' + cc.CONSTRAINT_NAME, 'OBJECT')
      WHERE referenced_entity_name IN (SELECT o.name
                                 FROM sys.objects o
                            INNER JOIN sys.sql_modules m
                                    ON o.object_id = m.object_id
                                WHERE o.[type] IN ('FN'))
      UNION
         SELECT LTRIM(RTRIM(ss.name)) + '.' + LTRIM(RTRIM(referenced_entity_name))
           FROM sys.computed_columns scc
      INNER JOIN sys.tables st
              ON scc.object_id = st.object_id
      INNER JOIN sys.schemas ss
              ON st.schema_id = ss.schema_id
      CROSS APPLY sys.dm_sql_referenced_entities ('dbo.' + st.name, 'OBJECT')
            WHERE referenced_entity_name IN (SELECT o.name
                                     FROM sys.objects o
                                  INNER JOIN sys.sql_modules m
                                       ON o.object_id = m.object_id
                                    WHERE o.[type] IN ('FN'))

      OPEN cursor_RoutineName
      FETCH NEXT FROM cursor_RoutineName INTO @strRoutineName
      WHILE (@@FETCH_STATUS = 0)
      BEGIN
         BEGIN TRY
            set @strRoutineName = @strRoutineName
            EXECUTE sp_recompile @strRoutineName
            INSERT INTO osdba.RecompileRoutinesLog (RoutineName) VALUES (@strRoutineName + ' successfully marked for recompilation');
         END TRY
         BEGIN CATCH
            SET @SEVERITY  = ISNULL (ERROR_SEVERITY(), 0)
            SET @ERROR     = ISNULL (ERROR_MESSAGE(), ' ')
            SET @STATE     = ISNULL (ERROR_STATE(), 0)
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            INSERT INTO osdba.[RecompileRoutinesErrorLog] ([RoutineName],   [Severity], [Error], [State])
                                                   VALUES (@strRoutineName, @SEVERITY,  @ERROR,  @STATE);
         END CATCH
         FETCH NEXT FROM cursor_RoutineName INTO @strRoutineName
      END
      CLOSE cursor_RoutineName
      DEALLOCATE cursor_RoutineName
END TRY
  BEGIN CATCH
      IF (CURSOR_STATUS('global', 'cursor_RoutineName') >= 0)
      BEGIN
         CLOSE cursor_RoutineName
         DEALLOCATE cursor_RoutineName
      END

      SET @SEVERITY  = ISNULL (ERROR_SEVERITY(), 0)
      SET @ERROR     = ISNULL (ERROR_MESSAGE(), ' ')
      SET @STATE     = ISNULL (ERROR_STATE(), 0)

      IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
      INSERT INTO osdba.[RecompileRoutinesErrorLog] ([RoutineName],   [Severity], [Error], [State])
                                              VALUES (@strRoutineName, @SEVERITY,  @ERROR,  @STATE);

      RAISERROR(@ERROR, @SEVERITY, @STATE);
 END CATCH
END
