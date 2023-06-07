CREATE PROCEDURE [dbo].[UPDATEITEMREVIEW]
-- Add the parameters for the stored procedure here
@ItemReviewID char(36),
@ItemReviewStatusID char(36),
@Completed bit,
@CompletedDate datetime,
@DueDate datetime,
@AssignedDate datetime,
@AssignedUser char(36),
@Passed bit,
@NotRequired bit,
@ApprovedUserID char(36),
@HasUnresolvedCorrections bit,
@Comments nvarchar(max),
@LastChangedOn datetime,
@LastChangedBy char(36),
@RowVersion int,
@CaseID char(36),
@ModuleID int,
@CurrentLoginUser char(36)	
AS
BEGIN	
	DECLARE @SuccessFlag bit
	DECLARE @FailureFlag bit
	DECLARE @COUNT int	
	DECLARE @CurrentRowVersion int
	DECLARE @ReturnCode int	
	SET @CurrentRowVersion = @RowVersion - 1
	SELECT @COUNT = COUNT(*) FROM PLITEMREVIEW WHERE PLITEMREVIEWID = @ItemReviewID AND ROWVERSION = @CurrentRowVersion
	IF @COUNT > 0
	BEGIN
		UPDATE PLITEMREVIEW 
		SET PLITEMREVIEWSTATUSID = @ItemReviewStatusID, 
			LASTCHANGEDON = @LastChangedOn, 
			LASTCHANGEDBY = @LastChangedBy, 
			COMPLETED = @Completed,
			PASSED = @Passed,
			APPROVEDUSERID = @ApprovedUserID,
			HASUNRESOLVEDCORRECTIONS = @HasUnresolvedCorrections,
			COMPLETEDATE = @CompletedDate,
			COMMENTS = @Comments,
			ASSIGNEDDATE = @AssignedDate,
			ASSIGNEDUSERID = @AssignedUser,
			NOTREQUIRED = @NotRequired,
			DUEDATE = @DueDate,
			ROWVERSION = @RowVersion 
		WHERE PLITEMREVIEWID = @ItemReviewID					
		SET @ReturnCode = 1 --Success			
		SELECT @SuccessFlag = SUCCESSFLAG, @FailureFlag = FAILUREFLAG 
		FROM PLITEMREVIEWSTATUS WHERE PLITEMREVIEWSTATUSID = @ItemReviewStatusID
		IF (@SuccessFlag IS NOT NULL AND @SuccessFlag = 1) OR (@FailureFlag IS NOT NULL AND @FailureFlag = 1)
		BEGIN
			IF @ModuleID = 1
			BEGIN
				INSERT INTO WORKFLOWPOSTPROCESS 
				(
				CLASSNAME,
				CREATEDATE,
				USERID,
				PROCESSEDDATE,
				FETCHMETHODNAME,
				ENTITYID,
				RESULTLOG
				)
				VALUES(
				'EnerGovBusiness.PlanManagement.Plan',
				getdate(),
				@CurrentLoginUser,
				NULL,
				'GetPlan',
				@CaseID,
				NULL)
			END
			ELSE IF @ModuleID = 2
			BEGIN
				INSERT INTO WORKFLOWPOSTPROCESS 
				(
				CLASSNAME,
				CREATEDATE,
				USERID,
				PROCESSEDDATE,
				FETCHMETHODNAME,
				ENTITYID,
				RESULTLOG
				)
				VALUES(
				'EnerGovBusiness.PermitManagement.Permit',
				getdate(),
				@CurrentLoginUser,
				NULL,
				'GetPermit',
				@CaseID,
				NULL)
			END
		END
	END	
	ELSE
	BEGIN
		SET @ReturnCode = 2 --Concurrency
	END	
	SELECT @ReturnCode AS RETURNCODE
END