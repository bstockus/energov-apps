
CREATE PROCEDURE [dbo].[ADDCONDITION]
-- Add the parameters for the stored procedure here
@ConditionID char(36),
@ConditionCategoryID char(36),
@Name nvarchar(255),
@Description nvarchar(max),
@Comments nvarchar(max),
@IsEnable bit,
@OriginObject nvarchar(255),
@OriginObjectID varchar(50),
@OriginObjectName nvarchar(255)
AS
BEGIN		
	INSERT INTO CONDITION 
	VALUES(
	@ConditionID,
	@ConditionCategoryID,
	@Name,
	@Description,
	@Comments,
	@IsEnable,
	@OriginObject,
	@OriginObjectID,
	@OriginObjectName
	)
END
