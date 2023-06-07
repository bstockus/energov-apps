
CREATE PROCEDURE [dbo].[EvaluationPrereqGroup]
-- Add the parameters for the stored procedure here
@CaseID char(36),
@CaseNumber nvarchar(50),
@GroupID char(36),
@ParentOrChildCaseID char(36),
@ParentOrChildCaseNumber nvarchar(50),
@MyParentModule int,
@ParentOrChild bit,
@ParentOrChildModule int,
@Result bit out,
@ErrorMessage nvarchar(max) out
AS
BEGIN	
	DECLARE @SubGroupID char(36) = NULL	
	DECLARE @ConditionID char(36) = NULL
	DECLARE @LogicalOperator nvarchar(3) = NULL		
	DECLARE @IsSubGroupEvaluate bit = 0	
	DECLARE @EvalCondition bit = 0	
	--SubGroupCursor
	DECLARE SubGroupCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT IMPREREQGROUPSUBGROUPXREF.SUBGROUPID
	FROM IMPREREQGROUPSUBGROUPXREF	
	WHERE IMPREREQGROUPSUBGROUPXREF.GROUPID = @GroupID

	--ConditionCursor
	DECLARE ConditionCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT IMPREREQCONDITIONID
	FROM IMPREREQGROUPCONDITIONXREF
	WHERE IMPREREQGROUPID = @GroupID

	SELECT @LogicalOperator = LOGICALOPERATOR FROM IMPREREQGROUP WHERE IMPREREQGROUP.IMPREREQGROUPID = @GroupID
	BEGIN TRY		
		--Evaluate Subgroup
		OPEN SubGroupCursor
		FETCH NEXT FROM SubGroupCursor INTO @SubGroupID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @IsSubGroupEvaluate = 1			
			--Execute Subgroup			
			EXEC [dbo].[EvaluationPrereqGroup] @CaseID = @CaseID, @CaseNumber = @CaseNumber, @GroupID = @SubGroupID, @ParentOrChildCaseID = @ParentOrChildCaseID, @ParentOrChildCaseNumber = @ParentOrChildCaseNumber, @MyParentModule = @MyParentModule, @ParentOrChild = @ParentOrChild, @ParentOrChildModule = @ParentOrChildModule, @Result = @Result Out, @ErrorMessage = @ErrorMessage Out
			IF (@LogicalOperator = 'OR' AND @Result = 1) --With OR, group is true as soon as one of them is true
			BEGIN								
				BREAK
			END				
			SET @SubGroupID = NULL						
			FETCH NEXT FROM SubGroupCursor INTO @SubGroupID
		END
		CLOSE SubGroupCursor		

		--Check to see if we need to process condition.
		IF @IsSubGroupEvaluate = 1 --SubGroup is evaluate
		BEGIN
			IF (@LogicalOperator = 'OR' AND @Result = 1) OR (@LogicalOperator = 'AND' AND @EvalCondition = 0) --Do not need to evaluate condition
			BEGIN
				SET @EvalCondition = 0
			END
			ELSE
			BEGIN
				SET @EvalCondition = 1
			END			
		END
		ELSE
		BEGIN
			SET @EvalCondition = 1
		END
		--We need to process condition
		IF @EvalCondition = 1
		BEGIN
			OPEN ConditionCursor
			FETCH NEXT FROM ConditionCursor INTO @ConditionID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				--Execute Condition
				EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @CaseID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = @ParentOrChildCaseID, @ParentOrChildCaseNumber = @ParentOrChildCaseNumber, @MyParentModule = @MyParentModule, @ParentOrChild = @ParentOrChild, @ParentOrChildModule = @ParentOrChildModule, @Result = @Result Out, @ErrorMessage = @ErrorMessage Out
				IF (@LogicalOperator = 'OR' AND @Result = 1) --With OR, condition is true as soon as one of them is true
				BEGIN										
					BREAK	
				END					
				SET @ConditionID = NULL
				FETCH NEXT FROM ConditionCursor INTO @ConditionID
			END
			CLOSE ConditionCursor			
		END		
	END TRY
	BEGIN CATCH			    		
		SET @Result = 0
		SET @ErrorMessage = ERROR_MESSAGE() 
	END CATCH
	--Deallocate Cursor
	DEALLOCATE SubGroupCursor					
	DEALLOCATE ConditionCursor
END
