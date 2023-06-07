

CREATE PROCEDURE [dbo].[GetAllCustomFields]
       (
	  --@ReportId AS CHAR(36),
	  @id AS CHAR(36),
	  @output AS NVARCHAR(MAX) OUTPUT
	  )
AS
BEGIN
    
      DECLARE @idTab AS IdTableType;
    
      INSERT    INTO @idTab
                ([Id])
      VALUES    (@id);

      DECLARE @customFields TABLE
              ([Id] CHAR(36)
              ,[Text] NVARCHAR(MAX));

      INSERT    INTO @customFields
                EXEC [dbo].[GetAllCustomFieldsTable] @idTab;

      SET @output = (
                     SELECT TOP 1 [cf].[Text] FROM @customFields AS [cf] WHERE [cf].[Id] = @id
                    );
    
END;
