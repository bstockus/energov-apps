CREATE PROCEDURE [dbo].[DELETECONDITION]
	-- Add the parameters for the stored procedure here
	@ConditionID char(36)	
	AS
	BEGIN		
		DELETE FROM CONDITION WHERE CONDITIONID = @ConditionID		
	END
