

CREATE PROCEDURE [dbo].[ADDPROJECTCONDITION]
-- Add the parameters for the stored procedure here
@ProjectConditionID char(36),
@ConditionID char(36),
@ProjectID char(36),	
@Scope int,
@CreatedOn datetime,
@IsSatisfied bit
AS
BEGIN		
	INSERT INTO PRPROJECTCONDITION 
	VALUES(
	@ProjectConditionID,
	@ConditionID,
	@ProjectID,
	@Scope,
	@CreatedOn,
	@IsSatisfied
	)
END
