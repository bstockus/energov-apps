﻿CREATE PROCEDURE [systemsetup].[USP_ILMAPPEDVALUECLASS_GETALL]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[dbo].[ILMAPPEDVALUECLASS].[MAPPEDVALUEID],
			[dbo].[ILLICENSECLASSIFICATION].[NAME],
			[dbo].[ILMAPPEDVALUECLASS].[MAPPEDVALUE],
			[dbo].[ILMAPPEDVALUECLASS].[ILLICENSECLASSIFICATIONID],
			[dbo].[ILMAPPEDVALUECLASS].[LASTCHANGEDBY],
			[dbo].[ILMAPPEDVALUECLASS].[LASTCHANGEDON],
			[dbo].[ILMAPPEDVALUECLASS].[ROWVERSION]
	FROM	[dbo].[ILMAPPEDVALUECLASS]
	LEFT JOIN	[dbo].[ILLICENSECLASSIFICATION] ON [dbo].[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [dbo].[ILMAPPEDVALUECLASS].[ILLICENSECLASSIFICATIONID]
	ORDER BY [dbo].[ILLICENSECLASSIFICATION].[NAME]
END