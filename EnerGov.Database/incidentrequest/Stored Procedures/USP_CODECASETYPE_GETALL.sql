CREATE PROCEDURE [incidentrequest].[USP_CODECASETYPE_GETALL]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT		[dbo].[CMCASETYPE].[CMCASETYPEID],
				[dbo].[CMCASETYPE].[NAME],
				[dbo].[CMCASETYPE].[DESCRIPTION]
	FROM		[dbo].[CMCASETYPE]
	WHERE		[dbo].[CMCASETYPE].[ACTIVE] = 1
	ORDER BY	[dbo].[CMCASETYPE].[NAME]
END