﻿CREATE PROCEDURE [systemsetup].[USP_ROLEBILLINGRATEXREF_GETBYPARENTID]
(
	@ROLEID CHAR(36)
)
AS
BEGIN
	SELECT 
		[dbo].[ROLEBILLINGRATEXREF].[ROLEBILLINGRATEXREFID],
		[dbo].[ROLEBILLINGRATEXREF].[ROLEID],
		[dbo].[ROLEBILLINGRATEXREF].[BILLINGRATEID],
		[dbo].[BILLINGRATE].[NAME],
		[dbo].[BILLINGRATE].[DESCRIPTION],
		[dbo].[BILLINGRATE].[AMOUNT],
		[dbo].[ROLEBILLINGRATEXREF].[ISDEFAULT]
	FROM [dbo].[ROLEBILLINGRATEXREF]
	INNER JOIN [dbo].[BILLINGRATE]
	ON [dbo].[BILLINGRATE].[BILLINGRATEID] = [dbo].[ROLEBILLINGRATEXREF].[BILLINGRATEID]
	WHERE [dbo].[ROLEBILLINGRATEXREF].[ROLEID] = @ROLEID
	ORDER BY [dbo].[BILLINGRATE].[NAME] ASC
END