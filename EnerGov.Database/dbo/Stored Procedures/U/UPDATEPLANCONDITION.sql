CREATE PROCEDURE [dbo].[UPDATEPLANCONDITION]
	-- Add the parameters for the stored procedure here
	@PlanConditionID char(36),		
	@IsSatisfied bit	
	AS
	BEGIN		
		UPDATE PLPLANCONDITION 
		SET ISSATISFIED = @IsSatisfied			
		WHERE PLPLANCONDITIONID = @PlanConditionID
	END
