CREATE FUNCTION [dbo].[UFN_GET_ALL_PARENT_CHILD_PERMITS_FROM_CHILD_PERMIT]
    ( @paramPermitId CHAR(36) )
RETURNS @returnTable TABLE ( PermitId CHAR(36) )
AS
BEGIN
	
	DECLARE @inProcessingTable TABLE ( PermitId CHAR(36) );
	
	INSERT INTO @inProcessingTable VALUES ( @paramPermitId );
	
	WHILE ((Select Count(*) From @inProcessingTable) > 0)
	BEGIN
		SET @paramPermitId = ( SELECT TOP 1 PermitId FROM @inProcessingTable );

		-- Add to be processed permit
		INSERT INTO @returnTable VALUES ( @paramPermitId );

		-- Fetch and Prepare permit list from set of parent and children permtis from parameter permitid.
		INSERT INTO @inProcessingTable 
		SELECT PermitId FROM dbo.UFN_GET_PARENT_CHILD_PERMITS_FROM_CHILD_PERMIT(@paramPermitId);

		-- Remove permits once processed
		DELETE @inProcessingTable WHERE PermitId IN ( SELECT PermitId FROM @returnTable );
	END
		
	RETURN;
END;