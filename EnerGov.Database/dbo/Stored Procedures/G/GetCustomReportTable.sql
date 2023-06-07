
-- ##################################################################
-- ##################################################################
-- ##################################################################
-- This is the main stored procedure that returns a formatted string
-- containing the custom field names and values that are associated
-- with the given record. It will automatically look up the value on
-- combo box selections and concatenate the values of multi-select
-- values
-- ##################################################################
-- ##################################################################
-- ##################################################################

CREATE PROCEDURE [dbo].[GetCustomReportTable] (@id AS CHAR(36))
AS
BEGIN
    
      DECLARE @idTab AS IdTableType;
    
      INSERT    INTO @idTab
                ([Id])
      VALUES    (@id);

      DECLARE @customFields TABLE
              ([Id] CHAR(36)
              ,[Field] NVARCHAR(4000)
              ,[Value] NVARCHAR(MAX));

      INSERT    INTO @customFields
                EXEC [dbo].[GetAllCustomReportTable] @ids = @idTab;

      SELECT    *
      FROM      @customFields AS [cf]
      WHERE     [cf].[Id] = @id;
    
END;
