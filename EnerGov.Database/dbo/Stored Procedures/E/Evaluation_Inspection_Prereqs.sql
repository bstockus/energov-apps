
CREATE PROCEDURE [dbo].[Evaluation_Inspection_Prereqs]
-- Add the parameters for the stored procedure here
@CaseID char(36),
@CaseTypeID char(36),
@CaseWorkClassID char(36),
@Module int, 
@InspectionTypeID char(36)
AS
BEGIN	
	DECLARE @Result bit = 0
	DECLARE @ErrorMessage nvarchar(max) = NULL	
	DECLARE @RuleID char(36) = NULL
	DECLARE @GroupID char(36) = NULL
	DECLARE @EvalOrder int = 0	
	DECLARE @HASRULE bit = 0
	DECLARE @HasChildParent bit = 0

	--Rule Cursor
	DECLARE RuleCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT IMPREREQRULE.IMPREREQRULEID, IMPREREQRULE.EVALORDER
	FROM IMPREREQRULE
	INNER JOIN IMPREREQCASERULEXREF ON IMPREREQCASERULEXREF.IMPREREQRULEID = IMPREREQRULE.IMPREREQRULEID
	WHERE IMPREREQCASERULEXREF.CASETYPEID = @CaseTypeID AND 
			IMPREREQCASERULEXREF.CASEWORKCLASSID = @CaseWorkClassID AND
			IMPREREQCASERULEXREF.MODULE = @Module AND
			IMPREREQCASERULEXREF.IMINSPECTIONTYPEID = @InspectionTypeID
	ORDER BY IMPREREQRULE.EVALORDER   

	BEGIN TRY
		--Find all the matching rules				
		OPEN RuleCursor
        FETCH NEXT FROM RuleCursor INTO @RuleID, @EvalOrder
        WHILE @@FETCH_STATUS = 0 --foreach condition, start evaluation
        BEGIN
			IF @HASRULE = 0
			BEGIN
				SET @HASRULE = 1
			END			
			--Each Rule should have only one top level group
			SELECT @GroupID = IMPREREQGROUPID FROM IMPREREQRULEGROUPXREF WHERE IMPREREQRULEID = @RuleID
			IF @GroupID IS NOT NULL
			BEGIN				
				EXEC [dbo].[EvaluationPrereqGroup] @CaseID = @CaseID, @CaseNumber = NULL, @GroupID = @GroupID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @Result Out, @ErrorMessage = @ErrorMessage Out
			END

			IF @Result = 0 --Rule Failed -Do not need to process next rule.
			BEGIN
				BREAK
			END
			--Initialize for next rule
			SET @GroupID = NULL
			SET @RuleID = NULL
			SET @EvalOrder = 0
			FETCH NEXT FROM RuleCursor INTO @RuleID, @EvalOrder
		END	
		CLOSE RuleCursor	
	END TRY
	BEGIN CATCH --There is an error during execute the stored procedure
		SET @Result = 0
		SET @ErrorMessage = ERROR_MESSAGE() 		
	END CATCH
	--Deallocate Cursor	
	DEALLOCATE RuleCursor					
	--Return Result
	IF @HASRULE = 0 --No rule, always allow to create inspection
	BEGIN
		SET @Result = 1
	END
	IF @Result = 0 
	BEGIN
		RAISERROR('%s', 16, 11, @ErrorMessage);
	END
END
