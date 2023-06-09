﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_OMOBJECTCLASSIFICATION_GETALL]
AS
BEGIN
SET NOCOUNT ON;
	SELECT		[dbo].[OMOBJECTCLASSIFICATION].[OMOBJECTCLASSIFICATIONID],
				[dbo].[OMOBJECTCLASSIFICATION].[NAME],
				[dbo].[OMOBJECTCLASSIFICATION].[DESCRIPTION],
				[dbo].[OMOBJECTCLASSIFICATION].[LASTCHANGEDBY],
				[dbo].[OMOBJECTCLASSIFICATION].[LASTCHANGEDON],
				[dbo].[OMOBJECTCLASSIFICATION].[ROWVERSION]
	FROM		[dbo].[OMOBJECTCLASSIFICATION]
	ORDER BY	[dbo].[OMOBJECTCLASSIFICATION].[NAME] ASC

END