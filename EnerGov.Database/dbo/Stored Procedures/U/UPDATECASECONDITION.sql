CREATE PROCEDURE [dbo].[UPDATECASECONDITION]
	-- Add the parameters for the stored procedure here
	@CaseConditionID char(36),
	@ModuleID int,		
	@IsSatisfied bit	
	AS
	BEGIN		
		IF @ModuleID = 1
		BEGIN
			UPDATE PLPLANCONDITION 
			SET ISSATISFIED = @IsSatisfied			
			WHERE PLPLANCONDITIONID = @CaseConditionID
		END
		ELSE IF @ModuleID = 2
		BEGIN
			UPDATE PMPERMITCONDITION 
			SET ISSATISFIED = @IsSatisfied			
			WHERE PMPERMITCONDITIONID = @CaseConditionID
		END
	END