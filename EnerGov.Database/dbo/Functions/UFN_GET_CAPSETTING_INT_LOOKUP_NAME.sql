CREATE FUNCTION [dbo].[UFN_GET_CAPSETTING_INT_LOOKUP_NAME]
(
	@CAPSETTINGNAME NVARCHAR(50),
	@INTVALUE INT
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @LookupValue NVARCHAR(50)

	-- "Allow Contact Updates"
	IF(@CAPSETTINGNAME = 'ContactUpdateAllowed')
	BEGIN
		SET @LookupValue = CASE @INTVALUE
								WHEN 0 THEN 'Until Issued'
								WHEN 1 THEN 'Until Finaled'
						   END
	END

	-- "Inspection Allowed"
	ELSE IF(@CAPSETTINGNAME = 'InspectionAllowRequest')
	BEGIN
		SET @LookupValue = CASE @INTVALUE
								WHEN 0 THEN 'Always'
								WHEN 1 THEN 'When All fees on case are paid in full'
								WHEN 2 THEN 'When Invoiced fees are paid in full'
						   END
	END

	RETURN ISNULL(@LookupValue, '[none]')
END