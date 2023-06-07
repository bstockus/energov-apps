

CREATE PROCEDURE [dbo].[EvaluateImpactOnPlan]
-- Add the parameters for the stored procedure here
@CaseID char(36)
AS
BEGIN	
	--Constant DECLARE
	DECLARE @CaseStatusActive bit  --This is active case	
	DECLARE @ConditionActive int  --Active Condition
	DECLARE @ConditionFeesAssessed int  --Fees Assessed Condition
	DECLARE @ConditionFeesAssessedStatusID char(36) --Condition Status of Fees Assessed
	DECLARE @WorkflowStepStartedMileStone int  --Workflow Step Started Mile Stone
	DECLARE @WorkflowStepCompletedMileStone int  --Workflow Step Completed Mile Stone
	DECLARE @WorkflowActionStartedMileStone int  --Workflow Action Started Mile Stone
	DECLARE @WorkflowActionCompletedMileStone int  --Workflow Action Completed Mile Stone
	DECLARE @DateRangeMileStone int  --Date Range Mile Stone		
	DECLARE @PlanApplicationMileStone int  --Plan Application Mile Stone
	DECLARE @PlanCompletionMileStone int  --Plan Completion Mile Stone
	DECLARE @OtherMileStone int  --Other Mile Stone
	DECLARE @WorkflowStartStatus int  --Workflow step start status
	DECLARE @WorkflowPassedStatus int  --Workflow step passed status	
	DECLARE @CurrentDate datetime
	DECLARE @ServiceUser char(36)
	DECLARE @FeeClassName nvarchar(5)
	DECLARE @CaseNumber nvarchar(50)
	DECLARE @ConditionNumber nvarchar(50)
	DECLARE @ModuleID int --Plan Module
	DECLARE @IndexNameElastic varchar(36)
	DECLARE @CaseTypeID char(36)
	DECLARE @CaseTypeWorkClassID char(36)

	--Initialize Variables
	SET @CaseStatusActive = 1 --This is active case	
	SET @ConditionActive = 1 --Active Condition
	SET @ConditionFeesAssessed = 4 --Fees Assessed Condition
	SET @ConditionFeesAssessedStatusID = NULL --Condition Status of Fees Assessed
	SET @WorkflowStepStartedMileStone = 1 --Workflow Step Started Mile Stone
	SET @WorkflowStepCompletedMileStone = 2 --Workflow Step Completed Mile Stone
	SET @WorkflowActionStartedMileStone = 3 --Workflow Action Started Mile Stone
	SET @WorkflowActionCompletedMileStone = 4 --Workflow Action Completed Mile Stone
	SET @DateRangeMileStone = 5 --Date Range Mile Stone		
	SET @PlanApplicationMileStone = 10 --Plan Application Mile Stone
	SET @PlanCompletionMileStone = 11 --Plan Completion Mile Stone
	SET @OtherMileStone = 12 --Other Mile Stone
	SET @WorkflowStartStatus = 5 --Workflow step start status
	SET @WorkflowPassedStatus = 1 --Workflow step passed status	
	SET @CurrentDate = dateadd(dd, 0, datediff(dd, 0, getdate()))
	SET @ServiceUser = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa'
	SET @FeeClassName = 'EnerGovBusiness.Cashier.CAComputedFee'
	SET @CaseNumber = NULL
	SET @ConditionNumber = NULL
	SET @ModuleID = 1 --Plan Module
	SET @IndexNameElastic = (select STRINGVALUE from SETTINGS where NAME = 'ServiceBusTenant')

	--Condition Information
	DECLARE @ConditionID char(36)
	DECLARE @MileStoneType int	
	DECLARE @MileStoneConfigField char(36)
	DECLARE @ConditionMet bit
	DECLARE @ConditionStartDate datetime
	DECLARE @ConditionEndDate datetime
	DECLARE @AssessThreshold int
	DECLARE @UnitAssessedToDate decimal(20,4)
	DECLARE @UpdateUnitAssessedToDate decimal(20,4)
	DECLARE @UnitTypeID char(36)
	DECLARE @NumOfCaseImpactUnit decimal(20,4)
	DECLARE @NumOfProcessUnit decimal(20,4)
	DECLARE @Monetary bit
	DECLARE @ConditionMonetaryID char(36)		
	DECLARE @LumpSum bit
	DECLARE @AssessAmount money
	DECLARE @CalculateAssessAmount money
	DECLARE @CapConditionUnit bit
	DECLARE @NumOfConditionUnit decimal(20,4)
	DECLARE @CapConditionMet bit
	DECLARE @IgnoreOnImpactedRecord bit
	DECLARE @InflationType int
	DECLARE @InflationEffectiveDate datetime
	DECLARE @InflationCurrentRate decimal(20,4)

	--Initialize Variables
	SET @ConditionID = NULL
	SET @MileStoneType = 0	
	SET @MileStoneConfigField = NULL
	SET @ConditionMet = 0	
	SET @ConditionStartDate = NULL
	SET @ConditionEndDate = NULL
	SET @AssessThreshold = 0
	SET @UnitAssessedToDate = 0
	SET @UpdateUnitAssessedToDate = 0
	SET @UnitTypeID = NULL
	SET @NumOfCaseImpactUnit = 0
	SET @NumOfProcessUnit = 0
	SET @Monetary = 0
	SET @ConditionMonetaryID = NULL	
	SET @LumpSum = 0
	SET @AssessAmount = 0
	SET @CalculateAssessAmount = 0
	SET @CapConditionUnit = 0
	SET @NumOfConditionUnit = 0	
	SET @CapConditionMet = 0
	SET @IgnoreOnImpactedRecord = 0
	SET @InflationType = 1
	SET @InflationEffectiveDate = NULL
	SET @InflationCurrentRate = 0

	--Fee Information
	DECLARE @FeeID char(36)
	DECLARE @FeeTemplateID char(36)
	DECLARE @IsManual bit
	DECLARE @FeeDescription nvarchar(max)
	DECLARE @FeeOrder int
	DECLARE @FeePriority int
	DECLARE @FeeName nvarchar(50)
	DECLARE @ComputedFeeID char(36)
	--Initialize Variable
	SET @FeeID = NULL
	SET @FeeTemplateID = NULL
	SET @IsManual = 0
	SET @FeeDescription = NULL
	SET @FeeOrder = 0
	SET @FeePriority = 0
	SET @FeeName = NULL	

	--Land Condition Information
	DECLARE @LandConditionID char(36)
	DECLARE @IsSatisfied bit
	DECLARE @Scope int
	--Initialize Variables
	SET @LandConditionID = NULL
	SET @IsSatisfied = 0
	SET @Scope = 0
	
	SELECT @ConditionFeesAssessedStatusID = IPCONDITIONSTATUSID FROM IPCONDITIONSTATUS WHERE IPCONDITIONSYSTEMSTATUSID = @ConditionFeesAssessed
	SELECT @CaseTypeID = PLPLANTYPEID, @CaseTypeWorkClassID = PLPLANWORKCLASSID from PLPLAN where PLPLAN.PLPLANID = @CaseID

	--Select all the active condition
	DECLARE PlanImpactConditionCursor CURSOR FAST_FORWARD FOR
	SELECT DISTINCT IPCONDITION.IPCONDITIONID, 
					IPASSESSMENTMILESTONE.IPMILESTONETYPEID, 
					IPCONDITION.STARTDATE, 
					IPCONDITION.ENDDATE,
					IPCONDITION.ASSESSMENTTHRESHOLD,
					IPCONDITION.UNITASSESSEDTODATE,
					IPCONDITION.IPUNITTYPEID,
					IPCONDITION.MONETARY,					
					IPCONDITIONMONETARY.IPCONDITIONMONETARYID,
					IPCONDITION.CAFEEID,
					IPCONDITIONMONETARY.LUMPSUM,
					IPCONDITIONMONETARY.ASSESSAMOUNT,
					IPCONDITIONMONETARY.CAPCONDITIONUNIT,
					IPCONDITIONMONETARY.NUMOFCONDITIONUNIT,
					IPCASE.CASENUMBER,
					IPCONDITION.CONDITIONNUMBER,					
					IPASSESSMENTMILESTONE.CONFIGUREFIELDID,
					IPUNITTYPE.IGNOREONIMPACTEDRECORD,
					IPCONDITIONMONETARY.IPINFLATIONTYPEID,
					IPCONDITIONMONETARY.EFFECTIVEDATE,
					IPCONDITIONMONETARY.CURRENTRATE
	FROM IPCONDITION 
	INNER JOIN IPCONDITIONSTATUS ON IPCONDITION.IPCONDITIONSTATUSID	= IPCONDITIONSTATUS.IPCONDITIONSTATUSID		
	INNER JOIN IPASSESSMENTMILESTONE ON IPASSESSMENTMILESTONE.IPASSESSMENTMILESTONEID = IPCONDITION.IPASSESSMENTMILESTONEID		
	INNER JOIN IPCASE ON IPCONDITION.IPCASEID = IPCASE.IPCASEID
	INNER JOIN IPCASESTATUS ON IPCASE.IPCASESTATUSID = IPCASESTATUS.IPCASESTATUSID		
	INNER JOIN IPCASEPLANXREF ON IPCASEPLANXREF.IPCASEID = IPCASE.IPCASEID	
	INNER JOIN IPUNITTYPE ON IPUNITTYPE.IPUNITTYPEID = IPCONDITION.IPUNITTYPEID
	LEFT OUTER JOIN IPCONDITIONMONETARY ON IPCONDITIONMONETARY.IPCONDITIONID = IPCONDITION.IPCONDITIONID
	WHERE IPCASEPLANXREF.PLPLANID = @CaseID AND		           
		    IPCASESTATUS.ACTIVE = @CASESTATUSACTIVE AND
			IPCONDITIONSTATUS.IPCONDITIONSYSTEMSTATUSID = @ConditionActive AND
			IPASSESSMENTMILESTONE.MODULEID = @ModuleID AND
			IPCONDITION.IPCONDITIONID NOT IN (SELECT IPCONDITIONID FROM IPCONDITIONPLANXREF WHERE IPCONDITIONPLANXREF.PLPLANID = @CaseID) --Already Evaluate
			  	    
	OPEN PlanImpactConditionCursor
	FETCH NEXT FROM	PlanImpactConditionCursor 
				INTO @ConditionID, 
					@MileStoneType, 
					@ConditionStartDate, 
					@ConditionEndDate, 
					@AssessThreshold, 
					@UnitAssessedToDate, 
					@UnitTypeID,
					@Monetary,					
					@ConditionMonetaryID,					
					@FeeID,
					@LumpSum,
					@AssessAmount,
					@CapConditionUnit,
					@NumOfConditionUnit,
					@CaseNumber,
					@ConditionNumber,					
					@MileStoneConfigField,
					@IgnoreOnImpactedRecord,
					@InflationType,
					@InflationEffectiveDate,
					@InflationCurrentRate
	WHILE @@FETCH_STATUS = 0 --foreach condition, start evaluation
	BEGIN	
		--Begin Evaluation check on plan based on case types 
		IF dbo.IMPACT_EVALUATION_CHECK_WITH_CASETYPE(@CaseTypeID, @CaseTypeWorkClassID, @ConditionID) = 1
		BEGIN
			--Only check the milestone if it is monetary condition
			--Begin MileStone Logic
			IF @MileStoneType = @WorkflowStepStartedMileStone
			BEGIN
				--If there is any workflow step in plan is started, the condition is met
				IF EXISTS(
					SELECT 1 
					FROM PLPLANWFSTEP
					INNER JOIN WFTEMPLATESTEP ON WFTEMPLATESTEP.WFTEMPLATESTEPID = PLPLANWFSTEP.WFTEMPLATESTEPID
					INNER JOIN WFSTEP ON WFSTEP.WFSTEPID = WFTEMPLATESTEP.WFSTEPID
					WHERE WFSTEP.WFSTEPID = @MileStoneConfigField AND PLPLANWFSTEP.PLPLANID = @CaseID AND PLPLANWFSTEP.WORKFLOWSTATUSID = @WorkflowStartStatus)									 
				BEGIN
					SET @ConditionMet = 1
				END				
			END
			ELSE IF @MileStoneType = @WorkflowStepCompletedMileStone
			BEGIN
				--If there is any workflow step in plan is passed, the condition is met
				IF EXISTS(
					SELECT 1 
					FROM PLPLANWFSTEP
					INNER JOIN WFTEMPLATESTEP ON WFTEMPLATESTEP.WFTEMPLATESTEPID = PLPLANWFSTEP.WFTEMPLATESTEPID
					INNER JOIN WFSTEP ON WFSTEP.WFSTEPID = WFTEMPLATESTEP.WFSTEPID
					WHERE WFSTEP.WFSTEPID = @MileStoneConfigField AND PLPLANWFSTEP.PLPLANID = @CaseID AND PLPLANWFSTEP.WORKFLOWSTATUSID = @WorkflowPassedStatus)	 			
				BEGIN
					SET @ConditionMet = 1					
				END
			END
			ELSE IF @MileStoneType = @WorkflowActionStartedMileStone
			BEGIN			
				--If there is any workflow action started, condition is met			
				IF  EXISTS(
					SELECT 1
					FROM PLPLANWFACTIONSTEP
					INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANWFSTEPID = PLPLANWFACTIONSTEP.PLPLANWFSTEPID
					INNER JOIN WFTEMPLATESTEP ON WFTEMPLATESTEP.WFTEMPLATESTEPID = PLPLANWFSTEP.WFTEMPLATESTEPID
					INNER JOIN WFTEMPLATESTEPACTION ON WFTEMPLATESTEPACTION.WFTEMPLATESTEPID = WFTEMPLATESTEP.WFTEMPLATESTEPID
					WHERE WFTEMPLATESTEPACTION.WFACTIONID = @MileStoneConfigField AND PLPLANWFSTEP.PLPLANID = @CaseID AND PLPLANWFACTIONSTEP.WORKFLOWSTATUSID = @WorkflowStartStatus)				
				BEGIN
					SET @ConditionMet = 1					
				END				
			END
			ELSE IF @MileStoneType = @WorkflowActionCompletedMileStone
			BEGIN
				--If there is any workflow action started, condition is met
				IF  EXISTS(
					SELECT 1
					FROM PLPLANWFACTIONSTEP
					INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANWFSTEPID = PLPLANWFACTIONSTEP.PLPLANWFSTEPID
					INNER JOIN WFTEMPLATESTEP ON WFTEMPLATESTEP.WFTEMPLATESTEPID = PLPLANWFSTEP.WFTEMPLATESTEPID
					INNER JOIN WFTEMPLATESTEPACTION ON WFTEMPLATESTEPACTION.WFTEMPLATESTEPID = WFTEMPLATESTEP.WFTEMPLATESTEPID
					WHERE WFTEMPLATESTEPACTION.WFACTIONID = @MileStoneConfigField AND PLPLANWFSTEP.PLPLANID = @CaseID AND PLPLANWFACTIONSTEP.WORKFLOWSTATUSID = @WorkflowPassedStatus)			
				BEGIN
					SET @ConditionMet = 1					
				END		
			END
			ELSE IF @MileStoneType = @DateRangeMileStone
			BEGIN
				SET @ConditionStartDate = dateadd(dd, 0, datediff(dd, 0, @ConditionStartDate))
				SET @ConditionEndDate = dateadd(dd, 0, datediff(dd, 0, @ConditionEndDate))
				--If current date is fall in between the start and end date of condition, condition is met
				IF (@CurrentDate >= @ConditionStartDate AND @CurrentDate <= @ConditionEndDate)
				BEGIN
					SET @ConditionMet = 1					
				END
			END			
			ELSE IF @MileStoneType = @PlanApplicationMileStone
			BEGIN
				SET @ConditionMet = 1
			END
			ELSE IF @MileStoneType = @PlanCompletionMileStone
			BEGIN
				--If finalized date is not null, condition is met
				IF EXISTS (SELECT 1 FROM PLPLAN WHERE PLPLAN.PLPLANID = @CaseID AND PLPLAN.COMPLETEDATE IS NOT NULL)
				BEGIN
					SET @ConditionMet = 1
				END				
			END								
			--End MileStone Logic							
			--Start evaluation
			IF @ConditionMet = 1 --Condition Met
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
				--Find number of impacted unit
				SELECT @NumOfCaseImpactUnit = SUM(PLPLANIMPACTUNIT.NUMOFUNIT) 
				FROM PLPLANIMPACTUNIT 
				WHERE PLPLANIMPACTUNIT.IPUNITTYPEID = @UnitTypeID AND PLPLANIMPACTUNIT.PLPLANID = @CaseID

				IF @NumOfCaseImpactUnit >= 0 OR @IgnoreOnImpactedRecord = 1
				BEGIN	
					SET @UpdateUnitAssessedToDate = @UnitAssessedToDate + @NumOfCaseImpactUnit --Update the Unit assessed to date									
					IF @UnitAssessedToDate < @AssessThreshold
					BEGIN
						IF @UpdateUnitAssessedToDate >= @AssessThreshold
						BEGIN
							IF @AssessThreshold > 0
							BEGIN 
								SET @NumOfProcessUnit = @UnitAssessedToDate + @NumOfCaseImpactUnit - @AssessThreshold + 1
							END
							ELSE
							BEGIN
								SET @NumOfProcessUnit = @UnitAssessedToDate + @NumOfCaseImpactUnit - @AssessThreshold
							END
						END	
						ELSE
						BEGIN
							SET @NumOfProcessUnit = 0
						END									
					END
					ELSE 
					BEGIN
						SET @NumOfProcessUnit = @NumOfCaseImpactUnit
					END								
					--Only Evaluate if Exceed Threshold
					IF @NumOfProcessUnit > 0 OR @IgnoreOnImpactedRecord = 1
					BEGIN					
						--Logic based on Monetary Part, Ignore Unit Type is only for non-monetary condition
						IF @Monetary = 1 AND @IgnoreOnImpactedRecord = 0
						BEGIN
							IF @CapConditionUnit = 1 AND @LumpSum = 0--if using cap condition unit, should not be lump sum
							BEGIN
								IF @UpdateUnitAssessedToDate > @NumOfConditionUnit
								BEGIN
									SET @CapConditionMet = 1
									IF @NumOfProcessUnit > (@UpdateUnitAssessedToDate - @NumOfConditionUnit)	
									BEGIN
										IF @AssessThreshold > 0
										BEGIN
											SET @NumOfProcessUnit = @NumOfConditionUnit - @AssessThreshold - @UnitAssessedToDate + 1
										END
										ELSE
										BEGIN
											SET @NumOfProcessUnit = @NumOfConditionUnit - @AssessThreshold - @UnitAssessedToDate
										END
									END	
									ELSE									
									BEGIN
										SET @NumOfProcessUnit = 0
									END							
								END																					
							END

							IF @NumOfProcessUnit > 0 AND @LumpSum = 0--This is not lump sum
							BEGIN
								SET @CalculateAssessAmount = @AssessAmount * @NumOfProcessUnit
							END
							ELSE IF @LumpSum = 1
							BEGIN
								SET @CalculateAssessAmount = @AssessAmount
							END	
							
							--Calculate fee with CPI
							IF @InflationType = 3 AND @InflationEffectiveDate IS NOT NULL AND @CurrentDate >= @InflationEffectiveDate
							BEGIN
								SET @CalculateAssessAmount = ROUND(@CalculateAssessAmount * (@InflationCurrentRate + 1), 2)
							END	
						
							--Do the money part
							IF @CalculateAssessAmount > 0
							BEGIN
								SELECT @FeeTemplateID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID, 
									   @IsManual = CAFEETEMPLATEFEE.ISMANUAL,
									   @FeeDescription = CAFEETEMPLATEFEE.FEEDESCRIPTION,
									   @FeeOrder = CAFEETEMPLATEFEE.FEEORDER,
									   @FeePriority = CAFEETEMPLATEFEE.FEEPRIORITY,
									   @FeeName = CAFEETEMPLATEFEE.FEENAME							  
								FROM CAFEETEMPLATEFEE
								WHERE CAFEETEMPLATEFEE.CAFEEID = @FeeID AND CAFEETEMPLATEFEE.CAFEETEMPLATEID IN 
								( SELECT PLPLANTYPEWORKCLASS.CAFEETEMPLATEID FROM PLPLAN 
								  INNER JOIN PLPLANTYPEWORKCLASS ON PLPLAN.PLPLANTYPEID = PLPLANTYPEWORKCLASS.PLPLANTYPEID AND PLPLAN.PLPLANWORKCLASSID = PLPLANTYPEWORKCLASS.PLPLANWORKCLASSID
								  WHERE PLPLAN.PLPLANID = @CaseID
								)
								IF @FeeTemplateID IS NOT NULL
								BEGIN														
									SET @ComputedFeeID = newid()
									IF @FeeDescription IS NULL
									BEGIN
										SET @FeeDescription = @FeeName
									END							
									INSERT INTO CACOMPUTEDFEE 
									(
										CACOMPUTEDFEEID, 
										CAFEETEMPLATEFEEID, 
										FEEDESCRIPTION, 
										FEEORDER, 
										ISMANUALLYADDED, 
										COMPUTEDAMOUNT, 
										ISPROCESSED, 
										CASTATUSID,
										AMOUNTPAIDTODATE,
										ROWVERSION, 
										LASTCHANGEDON, 
										LASTCHANGEDBY,
										ISDELETED,
										FEEPRIORITY,
										FEENUMBER,
										CREATEDBY,
										CREATEDON,
										FEENAME,
										BASEAMOUNT,
										DISPLAYINPUTVALUE,
										ISONLINEADDED,
										NOTES
									)
									VALUES
									(
										@ComputedFeeID,
										@FeeTemplateID,
										@FeeDescription,
										@FeeOrder,
										@IsManual,
										@CalculateAssessAmount,
										0,
										1,
										0,
										1,
										@CurrentDate,
										@ServiceUser,
										0,
										@FeePriority,
										dbo.GetAutoNumberWithClassName(@FeeClassName),
										@ServiceUser,
										@CurrentDate,
										@FeeName,
										@CalculateAssessAmount,
										0,
										0,
										@ConditionNumber + ' (' + @CaseNumber + ')'
									)

									--Add Fee to Plan
									INSERT INTO PLPLANFEE VALUES (newid(), @CaseID, @ComputedFeeID, @CurrentDate)
									INSERT INTO ELASTICSEARCHOBJECT ([ELASTICSEARCHOBJECTID], [OBJECTID], [OBJECTCLASSNAME], [ROWVERSION], [CREATEDATE], [PROCESSEDDATE], [OBJECTACTION], [INDEXNAME]) 
															 VALUES (NEWID(), @CaseID, 'EnerGovBusiness.PlanManagement.Plan', 1, GETDATE(), null, 1, @IndexNameElastic)

									--Add Fee Reference
									INSERT INTO IPCONDITIONCASEFEEXREF VALUES (newid(), @ConditionID, @CaseID, @ModuleID, @ComputedFeeID, @CalculateAssessAmount) 
									--Update Auto Number
									UPDATE AUTONUMBERSETTINGS SET NEXTVALUE = NEXTVALUE + 1 WHERE CLASSNAME = @FeeClassName																						
								END
								ELSE
								BEGIN
									SET @CalculateAssessAmount = 0
								END							
							END
						
							--Update All Fees Assessed
							IF (@LumpSum = 1 OR @CapConditionMet = 1) AND @ConditionFeesAssessedStatusID IS NOT NULL 
							BEGIN
								UPDATE IPCONDITION SET IPCONDITIONSTATUSID = @ConditionFeesAssessedStatusID WHERE IPCONDITIONID = @ConditionID					
							END																																		
						END	
						ELSE
						BEGIN
							--Do the land condition part	
							DECLARE LandConditionCursor CURSOR FAST_FORWARD FOR																			
							SELECT CONDITIONID, ISSATISFIED, SCOPE FROM IPCONDITIONLMCONDITION WHERE IPCONDITIONID = @ConditionID
							OPEN LandConditionCursor
							FETCH NEXT FROM	LandConditionCursor INTO @LandConditionID, @IsSatisfied, @Scope 
							WHILE @@FETCH_STATUS = 0 --foreach land condition
							BEGIN
								INSERT INTO PLPLANCONDITION 
									(PLPLANCONDITIONID, CONDITIONID, PLANID, ISSATISFIED, SCOPE, CREATEDON)
								VALUES 
									(newid(), @LandConditionID, @CaseID, @IsSatisfied, @Scope, @CurrentDate)
								INSERT INTO ELASTICSEARCHOBJECT ([ELASTICSEARCHOBJECTID], [OBJECTID], [OBJECTCLASSNAME], [ROWVERSION], [CREATEDATE], [PROCESSEDDATE], [OBJECTACTION], [INDEXNAME]) 
														 VALUES (NEWID(), @CaseID, 'EnerGovBusiness.PlanManagement.Plan', 1, GETDATE(), null, 1, @IndexNameElastic)

								--Initialize Land Condition Variable		
								SET @LandConditionID = NULL
								SET @IsSatisfied = 0
								SET @Scope = 0

								FETCH NEXT FROM	LandConditionCursor INTO @LandConditionID, @IsSatisfied, @Scope 
							END	
							CLOSE LandConditionCursor
							DEALLOCATE LandConditionCursor
						END																													
					END	
									
					--Update Unit Assess to date, only if we do not ignore Unit Type
					IF @IgnoreOnImpactedRecord = 0
					BEGIN
						UPDATE IPCONDITION SET UNITASSESSEDTODATE = @UpdateUnitAssessedToDate WHERE IPCONDITIONID = @ConditionID		
					END	
				END	
			
				--Condition has been met, it does not matter if it is processed or not, we need to update IPCONDITIONPERMITXREF			
				--Update condition processed on permit
				INSERT INTO IPCONDITIONPLANXREF VALUES(newid(), @ConditionID, @CaseID)	
				INSERT INTO ELASTICSEARCHOBJECT ([ELASTICSEARCHOBJECTID], [OBJECTID], [OBJECTCLASSNAME], [ROWVERSION], [CREATEDATE], [PROCESSEDDATE], [OBJECTACTION], [INDEXNAME]) 
										 VALUES (NEWID(), @CaseID, 'EnerGovBusiness.PlanManagement.Plan', 1, GETDATE(), null, 1, @IndexNameElastic)												

				COMMIT TRANSACTION
				END TRY
				BEGIN CATCH
					ROLLBACK TRANSACTION
				END CATCH						
			END
			--End Evaluation
			--Initialize variable back to default for next round
			--Initialize Condition variable
			SET @ConditionID  = NULL
			SET @MileStoneType = 0
			SET @MileStoneConfigField = NULL
			SET @ConditionMet = 0	
			SET @ConditionStartDate  = NULL
			SET @ConditionEndDate = NULL
			SET @AssessThreshold = 0
			SET @UnitAssessedToDate = 0
			SET @UpdateUnitAssessedToDate = 0
			SET @UnitTypeID = NULL
			SET @NumOfCaseImpactUnit = 0
			SET @NumOfProcessUnit = 0
			SET @Monetary = 0
			SET @ConditionMonetaryID = NULL			
			SET @LumpSum = 0
			SET @AssessAmount = 0
			SET @CalculateAssessAmount = 0
			SET @CapConditionUnit = 0
			SET @NumOfConditionUnit = 0		
			SET @CapConditionMet = 0
			SET @CaseNumber = NULL
			SET @ConditionNumber = NULL
			SET @InflationType = 1
			SET @InflationEffectiveDate = NULL
			SET @InflationCurrentRate = 0
			--Initialize Fee variable
			SET @FeeID = NULL
			SET @FeeTemplateID = NULL
			SET @IsManual = 0
			SET @FeeDescription = NULL
			SET @FeeOrder = 0
			SET @FeePriority = 0
			SET @FeeName = NULL
			SET @ComputedFeeID = NULL
		END
		FETCH NEXT FROM	PlanImpactConditionCursor 
				INTO @ConditionID, 
					@MileStoneType, 
					@ConditionStartDate, 
					@ConditionEndDate, 
					@AssessThreshold, 
					@UnitAssessedToDate, 
					@UnitTypeID,
					@Monetary,					
					@ConditionMonetaryID,					
					@FeeID,
					@LumpSum,
					@AssessAmount,
					@CapConditionUnit,
					@NumOfConditionUnit,
					@CaseNumber,
					@ConditionNumber,					
					@MileStoneConfigField,
					@IgnoreOnImpactedRecord,
					@InflationType,
					@InflationEffectiveDate,
					@InflationCurrentRate
	END
	CLOSE PlanImpactConditionCursor
	DEALLOCATE PlanImpactConditionCursor	
END