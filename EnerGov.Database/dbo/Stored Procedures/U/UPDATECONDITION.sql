CREATE PROCEDURE [dbo].[UPDATECONDITION]
	-- Add the parameters for the stored procedure here
	@ConditionID char(36),		
	@Name nvarchar(255),
	@Description nvarchar(max),
	@Comments nvarchar(max),
	@IsEnable bit	
	AS
	BEGIN		
		UPDATE CONDITION 
		SET NAME = @Name,		
			DESCRIPTION = @Description,
			COMMENTS = @Comments,
			ISENABLE = @IsEnable
		WHERE CONDITIONID = @ConditionID
	END
