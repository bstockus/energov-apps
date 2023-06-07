
CREATE PROCEDURE [dbo].[EvaluationPrereqCondition]
-- Add the parameters for the stored procedure here
@CaseID char(36),
@CaseNumber nvarchar(50),
@ConditionID char(36),
@ParentOrChildCaseID char(36),
@ParentOrChildCaseNumber nvarchar(50),
@MyParentModule int,
@ParentOrChild bit,
@ParentOrChildModule int,
@Result bit out,
@ErrorMessage nvarchar(max) out
AS
BEGIN  
	--Initialize evaluation paramater		
	DECLARE @ParentPermitID char(36) = NULL
	DECLARE @ParentPlanID char(36) = NULL
	DECLARE @ChildPermitID char(36) = NULL
	DECLARE @ChildPlanID char(36) = NULL
	DECLARE @ChildInspectionID char(36) = NULL				
	DECLARE @RecordNumber nvarchar(100) = NULL	
	DECLARE @ErrorMessagePrefix nvarchar(100) = NULL
	DECLARE @TempResult bit = 0	
	--Condition Information
	DECLARE @FieldLogicalOperator nvarchar(3) = NULL--OR, AND, NULL	
	DECLARE @ConditionName nvarchar(50) = NULL		
	DECLARE @Module int = 0
	DECLARE @InspectionTypeID char(36) = NULL
	DECLARE @ParentGroupConditionID char(36) = NULL--Parent GroupID or ConditionID
	DECLARE @ParentGroupOrCondition bit = NULL --Group: 1  - Condition: 0
	DECLARE @ParentModule int = NULL --Permit: 1 - Plan: 2 - Inspection: 3
	DECLARE @ChildGroupConditionID char(36) = NULL--Child GroupID or ConditionID
	DECLARE @ChildGroupOrCondition bit = NULL--Group: 1 - Condition: 0
	DECLARE @ChildModule int = NULL--Permit: 1 - Plan: 2 - Inspection 3
	DECLARE @HasChild bit = 0--If there is no child, evaluate to false	
	DECLARE @HasParent bit = 0--if there is no parent, evaluate to false	
	DECLARE @FailMessage nvarchar(max) = NULL
	DECLARE @CaseTypeID char(36) = NULL--Permit Type or Plan Type
	DECLARE @CaseWorkClassID char(36) = NULL--Permit Workclass or Plan Workclass					 
				
	BEGIN TRY		    	
		--Get Condition Information
		SELECT @FieldLogicalOperator = FIELDLOGICALOPERATOR,	       
			   @CaseTypeID = CASETYPEID,
			   @ConditionName = CONDITIONNAME,
			   @CaseWorkClassID = CASEWORKCLASSID,
			   @Module = MODULE,
			   @InspectionTypeID = IMINSPECTIONTYPEID,
			   @ParentGroupConditionID = PARENTGROUPCONDITIONID,
			   @ParentGroupOrCondition = PARENTGROUPORCOND,
			   @ParentModule = PARENTMODULE,
			   @ChildGroupConditionID = CHILDGROUPCONDITIONID,
			   @ChildGroupOrCondition = CHILDGROUPORCOND,
			   @ChildModule = CHILDMODULE,
			   @FailMessage = FAILMESSAGE		   
		FROM IMPREREQCONDITION
		WHERE IMPREREQCONDITIONID = @ConditionID
		--Case Information
		--Note: @CaseID could be permit, plan or inspection	
		IF @Module = 1 --If @CaseID Or @ParentOrChildCaseID is permit
		BEGIN			
			--Check if the case matching the condition case type or work class before continue evaluation	
			IF @CaseID IS NOT NULL
			BEGIN
				IF EXISTS (SELECT 1 FROM PMPERMIT WHERE PMPERMITID = @CaseID AND PMPERMITTYPEID = @CaseTypeID AND PMPERMITWORKCLASSID = @CaseWorkClassID)
				BEGIN				
					SELECT @RecordNumber = PMPERMIT.PERMITNUMBER FROM PMPERMIT WHERE PMPERMITID = @CaseID AND PMPERMITTYPEID = @CaseTypeID AND PMPERMITWORKCLASSID = @CaseWorkClassID
					SET @CaseNumber = @RecordNumber
					--First Evaluate condition on case fields
					SET @TempResult = 1 --Assume Result is good before evaluation
					EXEC [dbo].[EvaluationPermitField] @CaseID = @CaseID, @ConditionID = @ConditionID, @FieldLogicalOperator = @FieldLogicalOperator, @Result = @TempResult out
					SET @Result = @TempResult
					IF @Result = 0 --Error on evaluate Case Fields
					BEGIN					
						SET @ErrorMessagePrefix = 'Condition ' + @ConditionName + ' is not satisfied on PERMIT CASE: ' + @RecordNumber
						IF @ErrorMessage IS NULL OR @ErrorMessage = ''
						BEGIN
							IF @FailMessage IS NULL
							BEGIN
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found' 
							END
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage
							END																
						END						
						ELSE IF CHARINDEX(@ErrorMessagePrefix, @ErrorMessage) = 0 --ErrorMessage is not null, check to make sure no duplicate error message
						BEGIN
							IF @FailMessage IS NULL
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found'
							END
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage
							END		
						END	
					END		
				
					--Next Parent Condition or Parent Group								
					IF  @ParentGroupConditionID IS NOT NULL --evaluate parent condition/group
					BEGIN										
						SET @TempResult = 1
						IF @ParentGroupOrCondition = 1 --Call Group on Parent Permit/Plan
						BEGIN								
							EXEC [dbo].[EvaluationPrereqGroup] @CaseID = NULL, @CaseNumber = NULL, @GroupID = @ParentGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 1, @ParentOrChild = 1, @ParentOrChildModule = @ParentModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out							
						END					
						ELSE IF @ParentGroupOrCondition = 0 --Call condition on Parent Permit/Plan
						BEGIN								
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = NULL, @CaseNumber = NULL, @ConditionID = @ParentGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 1, @ParentOrChild = 1, @ParentOrChildModule = @ParentModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END	
						SET @Result = @TempResult
					END					
																	      		                									
					--Next Child Condition or Child Group
					IF @ChildGroupConditionID IS NOT NULL--evaluate child condition/group
					BEGIN
						SET @TempResult = 1
						IF @ChildGroupOrCondition = 1 --Call Group on Child Permit/Plan/Inspection
						BEGIN								
							EXEC [dbo].[EvaluationPrereqGroup] @CaseID = NULL, @CaseNumber = NULL, @GroupID = @ChildGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 1, @ParentOrChild = 0, @ParentOrChildModule = @ChildModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out							
						END					
						ELSE IF @ChildGroupOrCondition = 0 --Call condition on Child Permit/Plan/Inspection
						BEGIN								
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = NULL, @CaseNumber = NULL, @ConditionID = @ChildGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 1, @ParentOrChild = 0, @ParentOrChildModule = @ChildModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END	
						SET @Result = @TempResult
					END
				END					
			END
			ELSE IF @ParentOrChildCaseID IS NOT NULL --Check on parent or child
			BEGIN
				IF @ParentOrChild = 1 --Check on parent
				BEGIN					
					IF @ParentOrChildModule = 1 --My Parent is permit
					BEGIN
						SET @TempResult = 1
						SELECT @ParentPermitID = PMPERMIT.PMPERMITID, @CaseNumber = PMPERMIT.PERMITNUMBER
						FROM PMPERMIT
						INNER JOIN PMPERMITWFSTEP ON PMPERMIT.PMPERMITID = PMPERMITWFSTEP.PMPERMITID
						INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
						INNER JOIN PMPERMITACTIONREF ON PMPERMITACTIONREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID
						WHERE PMPERMITACTIONREF.PMPERMITID = @ParentOrChildCaseID AND PMPERMIT.PMPERMITTYPEID = @CaseTypeID AND PMPERMIT.PMPERMITWORKCLASSID = @CaseWorkClassID
						IF @ParentPermitID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ParentPermitID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult
					END
					ELSE IF @ParentOrChildModule = 2 --My Parent is plan 
					BEGIN
						SET @TempResult = 1						
						SELECT @ParentPlanID = PLPLAN.PLPLANID, @CaseNumber = PLPLAN.PLANNUMBER
						FROM PLPLAN
						INNER JOIN PLPLANWFSTEP ON PLPLAN.PLPLANID = PLPLANWFSTEP.PLPLANID
						INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
						INNER JOIN PMPERMITACTIONREF ON PMPERMITACTIONREF.OBJECTID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID
						WHERE PMPERMITACTIONREF.PMPERMITID = @ParentOrChildCaseID AND PLPLAN.PLPLANTYPEID = @CaseTypeID AND PLPLAN.PLPLANWORKCLASSID = @CaseWorkClassID
						IF @ParentPlanID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ParentPlanID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult	
					END
				END
				ELSE --Check On Child
				BEGIN
					IF @ParentOrChildModule = 1 --My Child is permit
					BEGIN
						SET @TempResult = 1
						SELECT @ChildPermitID = PMPERMIT.PMPERMITID, @CaseNumber = PMPERMIT.PERMITNUMBER FROM PMPERMIT WHERE 
						PMPERMITID IN (
						SELECT PMPERMITACTIONREF.PMPERMITID
						FROM PMPERMIT
						INNER JOIN PMPERMITWFSTEP ON PMPERMIT.PMPERMITID = PMPERMITWFSTEP.PMPERMITID
						INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
						INNER JOIN PMPERMITACTIONREF ON PMPERMITACTIONREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID
						WHERE PMPERMIT.PMPERMITID = @ParentOrChildCaseID) AND PMPERMIT.PMPERMITTYPEID = @CaseTypeID AND PMPERMIT.PMPERMITWORKCLASSID = @CaseWorkClassID
						IF @ChildPermitID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ChildPermitID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult
					END
					ELSE IF @ParentOrChildModule = 2--My child is plan
					BEGIN
						SET @TempResult = 1						
						SELECT @ChildPlanID = PLPLAN.PLPLANID, @CaseNumber = PLPLAN.PLANNUMBER FROM PLPLAN WHERE 
						PLPLAN.PLPLANID IN (
						SELECT PLPLANACTIONREF.PLPLANID
						FROM PMPERMIT
						INNER JOIN PMPERMITWFSTEP ON PMPERMIT.PMPERMITID = PMPERMITWFSTEP.PMPERMITID
						INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
						INNER JOIN PLPLANACTIONREF ON PLPLANACTIONREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID
						WHERE PMPERMIT.PMPERMITID = @ParentOrChildCaseID) AND PLPLAN.PLPLANTYPEID = @CaseTypeID AND PLPLAN.PLPLANWORKCLASSID = @CaseWorkClassID
						IF @ChildPlanID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ChildPlanID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult	
					END					
				END
			END									
		END	
		ELSE IF @Module = 2 --IF @CaseID or ParentOrChildCaseID is plan
		BEGIN
			--Check if the case matching the condition case type or work class before continue evaluation	
			IF @CaseID IS NOT NULL
			BEGIN
				IF EXISTS (SELECT 1 FROM PLPLAN WHERE PLPLANID = @CaseID AND PLPLANTYPEID = @CaseTypeID AND PLPLANWORKCLASSID = @CaseWorkClassID)
				BEGIN				
					SELECT @RecordNumber = PLPLAN.PLANNUMBER FROM PLPLAN WHERE PLPLANID = @CaseID AND PLPLANTYPEID = @CaseTypeID AND PLPLANWORKCLASSID = @CaseWorkClassID
					SET @CaseNumber = @RecordNumber
					--First Evaluate condition on case fields
					SET @TempResult = 1 --Assume Result is good before evaluation
					EXEC [dbo].[EvaluationPlanField] @CaseID = @CaseID, @ConditionID = @ConditionID, @FieldLogicalOperator = @FieldLogicalOperator, @Result = @TempResult out
					SET @Result = @TempResult
					IF @Result = 0 --Error on evaluate Case Fields
					BEGIN					
						SET @ErrorMessagePrefix = 'Condition ' + @ConditionName + ' is not satisfied on PLAN CASE: ' + @RecordNumber
						IF @ErrorMessage IS NULL OR @ErrorMessage = ''
						BEGIN
							IF @FailMessage IS NULL
							BEGIN
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found' 
							END
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage
							END																
						END						
						ELSE IF CHARINDEX(@ErrorMessagePrefix, @ErrorMessage) = 0 --ErrorMessage is not null, check to make sure no duplicate error message
						BEGIN
							IF @FailMessage IS NULL
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found'
							END
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage
							END		
						END	
					END		
				
					--Next Parent Condition or Parent Group								
					IF  @ParentGroupConditionID IS NOT NULL --evaluate parent condition/group
					BEGIN										
						SET @TempResult = 1
						IF @ParentGroupOrCondition = 1 --Call Group on Parent Permit/Plan
						BEGIN								
							EXEC [dbo].[EvaluationPrereqGroup] @CaseID = NULL, @CaseNumber = NULL, @GroupID = @ParentGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 2, @ParentOrChild = 1, @ParentOrChildModule = @ParentModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out							
						END					
						ELSE IF @ParentGroupOrCondition = 0 --Call condition on Parent Permit/Plan
						BEGIN								
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = NULL, @CaseNumber = NULL, @ConditionID = @ParentGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 2, @ParentOrChild = 1, @ParentOrChildModule = @ParentModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END	
						SET @Result = @TempResult
					END					

					--Next Child Condition or Child Group
					IF @ChildGroupConditionID IS NOT NULL--evaluate child condition/group
					BEGIN
						SET @TempResult = 1
						IF @ChildGroupOrCondition = 1 --Call Group on Child Permit/Plan/Inspection
						BEGIN								
							EXEC [dbo].[EvaluationPrereqGroup] @CaseID = NULL, @CaseNumber = NULL, @GroupID = @ChildGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 2, @ParentOrChild = 0, @ParentOrChildModule = @ChildModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out							
						END					
						ELSE IF @ChildGroupOrCondition = 0 --Call condition on Child Permit/Plan/Inspection
						BEGIN								
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = NULL, @CaseNumber = NULL, @ConditionID = @ChildGroupConditionID, @ParentOrChildCaseID = @CaseID, @ParentOrChildCaseNumber = @CaseNumber, @MyParentModule = 2, @ParentOrChild = 0, @ParentOrChildModule = @ChildModule, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END	
						SET @Result = @TempResult
					END
				END					
			END
			ELSE IF @ParentOrChildCaseID IS NOT NULL --Check on parent or child
			BEGIN
				IF @ParentOrChild = 1 --Check on parent
				BEGIN					
					IF @ParentOrChildModule = 1 --My Parent is permit
					BEGIN
						SET @TempResult = 1						
						SELECT @ParentPermitID = PMPERMIT.PMPERMITID, @CaseNumber = PMPERMIT.PERMITNUMBER
						FROM PMPERMIT
						INNER JOIN PMPERMITWFSTEP ON PMPERMIT.PMPERMITID = PMPERMITWFSTEP.PMPERMITID
						INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
						INNER JOIN PLPLANACTIONREF ON PLPLANACTIONREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID
						WHERE PLPLANACTIONREF.PLPLANID = @ParentOrChildCaseID AND PMPERMIT.PMPERMITTYPEID = @CaseTypeID AND PMPERMIT.PMPERMITWORKCLASSID = @CaseWorkClassID
						IF @ParentPermitID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ParentPermitID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult
					END
					ELSE IF @ParentOrChildModule = 2 --My Parent is plan
					BEGIN
						SET @TempResult = 1												
						SELECT  @ParentPlanID = PLPLAN.PLPLANID, @CaseNumber = PLPLAN.PLANNUMBER FROM PLPLAN WHERE 
						PLPLANID IN (
						SELECT PLPLANACTIONREF.PLPLANID
						FROM PLPLAN
						INNER JOIN PLPLANWFSTEP ON PLPLAN.PLPLANID = PLPLANWFSTEP.PLPLANID
						INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
						INNER JOIN PLPLANACTIONREF ON PLPLANACTIONREF.OBJECTID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID
						WHERE PLPLAN.PLPLANID = @ParentOrChildCaseID) AND PLPLAN.PLPLANTYPEID = @CaseTypeID AND PLPLAN.PLPLANWORKCLASSID = @CaseWorkClassID
						IF @ParentPlanID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ParentPlanID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult	
					END
				END
				ELSE --Check On Child
				BEGIN
					IF @ParentOrChildModule = 1 --My Child is permit
					BEGIN
						SET @TempResult = 1						
						SELECT @ChildPermitID = PMPERMIT.PMPERMITID, @CaseNumber = PMPERMIT.PERMITNUMBER FROM PMPERMIT WHERE 
						PMPERMIT.PMPERMITID IN (
						SELECT PMPERMITACTIONREF.PMPERMITID
						FROM PLPLAN
						INNER JOIN PLPLANWFSTEP ON PLPLAN.PLPLANID = PLPLANWFSTEP.PLPLANID
						INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
						INNER JOIN PMPERMITACTIONREF ON PMPERMITACTIONREF.OBJECTID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID
						WHERE PLPLAN.PLPLANID = @ParentOrChildCaseID) AND PMPERMIT.PMPERMITTYPEID = @CaseTypeID AND PMPERMIT.PMPERMITWORKCLASSID = @CaseWorkClassID
						IF @ChildPermitID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ChildPermitID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult
					END
					ELSE IF @ParentOrChildModule = 2--My child is plan
					BEGIN
						SET @TempResult = 1												
						SELECT @ChildPlanID = PLPLAN.PLPLANID, @CaseNumber = PLPLAN.PLANNUMBER FROM PLPLAN WHERE 
						PLPLANID IN (
						SELECT PLPLANACTIONREF.PLPLANID
						FROM PLPLAN
						INNER JOIN PLPLANWFSTEP ON PLPLAN.PLPLANID = PLPLANWFSTEP.PLPLANID
						INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
						INNER JOIN PLPLANACTIONREF ON PLPLANACTIONREF.OBJECTID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID
						WHERE PLPLAN.PLPLANID = @ParentOrChildCaseID) AND PLPLAN.PLPLANTYPEID = @CaseTypeID AND PLPLAN.PLPLANWORKCLASSID = @CaseWorkClassID
						IF @ChildPlanID IS NOT NULL
						BEGIN
							EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ChildPlanID, @CaseNumber = @CaseNumber, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = NULL, @MyParentModule = NULL, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						END						
						SET @Result = @TempResult
					END						
				END
			END									
		END	
		ELSE IF @Module = 3--If @CaseID is inspection
		BEGIN
			IF @CaseID IS NOT NULL
			BEGIN
				--Only evaluate if matching inspection and its type			
				IF EXISTS (SELECT 1 FROM IMINSPECTION WHERE IMINSPECTIONID = @CaseID AND IMINSPECTIONTYPEID = @InspectionTypeID)
				BEGIN				
					SELECT @RecordNumber = IMINSPECTION.INSPECTIONNUMBER FROM IMINSPECTION WHERE IMINSPECTIONID = @CaseID AND IMINSPECTIONTYPEID = @InspectionTypeID	
					--First Evaluate condition on case fields
					SET @TempResult = 1 --Assume Result is good before evaluation
					EXEC [dbo].[EvaluationInspectionField] @CaseID = @CaseID, @ConditionID = @ConditionID, @FieldLogicalOperator = @FieldLogicalOperator, @Result = @TempResult out
					SET @Result = @TempResult	
					IF @Result = 0
					BEGIN
						SET @ErrorMessagePrefix = 'Condition ' + @ConditionName + ' is not satisfied on INSPECTION CASE: ' + @RecordNumber
						IF @MyParentModule = 1
						BEGIN
							SET @ErrorMessagePrefix = @ErrorMessagePrefix + ' of PERMIT CASE: ' + @ParentOrChildCaseNumber
						END
						ELSE
						BEGIN
							SET @ErrorMessagePrefix = @ErrorMessagePrefix + ' of PLAN CASE: ' + @ParentOrChildCaseNumber
						END
						IF @ErrorMessage IS NULL OR @ErrorMessage = ''
						BEGIN
							IF @FailMessage IS NULL
							BEGIN
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found.' 
								IF @MyParentModule = 1
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
								END
								ELSE
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
								END
							END
							ELSE
							BEGIN								
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage
								IF @MyParentModule = 1
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
								END
								ELSE
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
								END
							END																
						END						
						ELSE IF CHARINDEX(@ErrorMessagePrefix, @ErrorMessage) = 0
						BEGIN
							IF @FailMessage IS NULL
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found'
								IF @MyParentModule = 1
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
								END
								ELSE
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
								END
							END
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage
								IF @MyParentModule = 1
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
								END
								ELSE
								BEGIN
									SET @ErrorMessage = @ErrorMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
								END
							END																
						END	
					END		
				END
			END	
			ELSE IF @ParentOrChildCaseID IS NOT NULL
			BEGIN
				SET @HasChild = 0 --For inspection, if not exist
				SET @TempResult = 0 --For inspection, if not exist, consider as failed

				IF @MyParentModule = 1 --My Parent is permit
				BEGIN					
					--Maybe more than one inspection, loop through all of them to see if any met the condition
					DECLARE PermitInspectionCursor CURSOR LOCAL FAST_FORWARD FOR
					SELECT IMINSPECTION.IMINSPECTIONID  FROM IMINSPECTION WHERE
					IMINSPECTIONID IN (
					SELECT IMINSPECTIONACTREF.IMINSPECTIONID
					FROM PMPERMIT
					INNER JOIN PMPERMITWFSTEP ON PMPERMIT.PMPERMITID = PMPERMITWFSTEP.PMPERMITID
					INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
					INNER JOIN IMINSPECTIONACTREF ON IMINSPECTIONACTREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID
					WHERE PMPERMIT.PMPERMITID = @ParentOrChildCaseID) AND IMINSPECTION.IMINSPECTIONTYPEID = @InspectionTypeID	

					OPEN PermitInspectionCursor
					FETCH NEXT FROM PermitInspectionCursor INTO @ChildInspectionID
					WHILE @@FETCH_STATUS = 0 --foreach inspection, start evaluation
					BEGIN
						SET @HasChild = 1
						EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ChildInspectionID, @CaseNumber = NULL, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = @ParentOrChildCaseNumber, @MyParentModule = @MyParentModule, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						SET @Result = @TempResult
						IF @Result = 1
						BEGIN
							BREAK
						END
						--Initialize for next rule
						SET @ChildInspectionID = NULL												
						FETCH NEXT FROM PermitInspectionCursor INTO @ChildInspectionID
					END	
					CLOSE PermitInspectionCursor
					DEALLOCATE PermitInspectionCursor				
				END	
				ELSE IF @MyParentModule = 2 --My Parent is plan
				BEGIN
					--Maybe more than one inspection, loop through all of them to see if any met the condition
					DECLARE PlanInspectionCursor CURSOR LOCAL FAST_FORWARD FOR
					SELECT IMINSPECTION.IMINSPECTIONID  FROM IMINSPECTION WHERE
					IMINSPECTIONID IN (
					SELECT IMINSPECTIONACTREF.IMINSPECTIONID
					FROM PLPLAN
					INNER JOIN PLPLANWFSTEP ON PLPLAN.PLPLANID = PLPLANWFSTEP.PLPLANID
					INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
					INNER JOIN IMINSPECTIONACTREF ON IMINSPECTIONACTREF.OBJECTID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID
					WHERE PLPLAN.PLPLANID = @ParentOrChildCaseID) AND IMINSPECTION.IMINSPECTIONTYPEID = @InspectionTypeID

					OPEN PlanInspectionCursor
					FETCH NEXT FROM PlanInspectionCursor INTO @ChildInspectionID
					WHILE @@FETCH_STATUS = 0 --foreach inspection, start evaluation
					BEGIN
						SET @HasChild = 1
						EXEC [dbo].[EvaluationPrereqCondition] @CaseID = @ChildInspectionID, @CaseNumber = NULL, @ConditionID = @ConditionID, @ParentOrChildCaseID = NULL, @ParentOrChildCaseNumber = @ParentOrChildCaseNumber, @MyParentModule = @MyParentModule, @ParentOrChild = NULL, @ParentOrChildModule = NULL, @Result = @TempResult Out, @ErrorMessage = @ErrorMessage Out														
						SET @Result = @TempResult
						IF @Result = 1
						BEGIN
							BREAK
						END
						--Initialize for next rule
						SET @ChildInspectionID = NULL												
						FETCH NEXT FROM PlanInspectionCursor INTO @ChildInspectionID
					END	
					CLOSE PlanInspectionCursor
					DEALLOCATE PlanInspectionCursor														
				END																				
				IF @HasChild = 0 --No Child Exist, report error message
				BEGIN
					SET @Result = 0							
					IF @MyParentModule = 1
					BEGIN
						SET @ErrorMessagePrefix = 'Condition ' + @ConditionName + ' is not satisfied on PERMIT CASE: ' + @ParentOrChildCaseNumber
					END					
					ELSE 
					BEGIN
						SET @ErrorMessagePrefix = 'Condition ' + @ConditionName + ' is not satisfied on PLAN CASE: ' + @ParentOrChildCaseNumber
					END
					IF @ErrorMessage IS NULL OR @ErrorMessage = ''
					BEGIN
						IF @FailMessage IS NULL
						BEGIN
							SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found.'
							IF @MyParentModule = 1
							BEGIN
								SET @ErrorMessage = @ErrorMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
							END							
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
							END
						END
						ELSE
						BEGIN
							IF @MyParentModule = 1
							BEGIN
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
							END							
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
							END
						END																
					END						
					ELSE IF CHARINDEX(@ErrorMessagePrefix, @ErrorMessage) = 0
					BEGIN
						IF @FailMessage IS NULL
						BEGIN
							SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: No Failed Message Found'
							IF @MyParentModule = 1
							BEGIN
								SET @ErrorMessage = @ErrorMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
							END							
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
							END
						END
						ELSE
						BEGIN
							IF @MyParentModule = 1
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage + ' on PERMIT CASE: ' + @ParentOrChildCaseNumber
							END							
							ELSE
							BEGIN
								SET @ErrorMessage = @ErrorMessage + Char(13) + @ErrorMessagePrefix + ' . ERROR MESSAGE: ' + @FailMessage + ' on PLAN CASE: ' + @ParentOrChildCaseNumber
							END
						END																
					END		
				END
			END	
		END		
	END TRY
	BEGIN CATCH
		SET @Result = 0
		SET @ErrorMessage = ERROR_MESSAGE() 				
	END CATCH			
END
