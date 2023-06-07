
CREATE PROCEDURE [dbo].[ADDPLANCONDITION]
-- Add the parameters for the stored procedure here
@PlanConditionID char(36),
@ConditionID char(36),
@PlanID char(36),
@IsSatisfied bit,
@Scope int,
@CreatedOn datetime	
AS
BEGIN		
	INSERT INTO PLPLANCONDITION 
	VALUES(
	@PlanConditionID,
	@ConditionID,
	@PlanID,
	@IsSatisfied,
	@Scope,
	@CreatedOn	
	)
END
