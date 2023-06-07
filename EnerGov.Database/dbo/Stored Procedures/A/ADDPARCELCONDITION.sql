CREATE PROCEDURE [dbo].[ADDPARCELCONDITION]
	-- Add the parameters for the stored procedure here
	@ParcelConditionID char(36),
	@ParcelID char(36),
	@ConditionID char(36),	
	@Scope int,
	@CreatedOn datetime	
	AS
	BEGIN		
		INSERT INTO PARCELCONDITION 
		VALUES(
		@ParcelConditionID,
		@ParcelID,
		@ConditionID,
		@Scope,
		@CreatedOn	
		)
	END
