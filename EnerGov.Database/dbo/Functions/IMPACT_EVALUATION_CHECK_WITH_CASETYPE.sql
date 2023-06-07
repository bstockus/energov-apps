
CREATE FUNCTION [dbo].[IMPACT_EVALUATION_CHECK_WITH_CASETYPE]
(
	@CASETYPE_ID CHAR(36),
	@CASETYPE_WORKCLASS_ID CHAR(36),
	@IPCONDITION_ID CHAR(36)
)
RETURNS BIT
AS
BEGIN
	-- variable declaration
	DECLARE @RESULT AS BIT
	-- variable initialization
	SET @RESULT = 0 -- assume that evaluation should not run 
	-- Check If 
	-- 1) case types feature is diabled then impact evaluation check should return true as impact evaluation should run if case type feature is not enabled
	-- 2) case types are enabled in settings table and case type with given case type work class id is also a part of impact condition then return result as true
	IF ((dbo.IS_SETTING_ENABLED('EnableCaseTypes') = 0) OR (dbo.IS_SETTING_ENABLED('EnableCaseTypes') = 1 AND dbo.CASETYPE_HAS_MODULECASETYPE(@CASETYPE_ID, @CASETYPE_WORKCLASS_ID, @IPCONDITION_ID) = 1))
	BEGIN
		SET @RESULT  = 1
	END
	RETURN @RESULT
END