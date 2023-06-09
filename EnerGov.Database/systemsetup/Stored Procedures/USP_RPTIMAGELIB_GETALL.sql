﻿CREATE PROCEDURE [systemsetup].[USP_RPTIMAGELIB_GETALL]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT		[dbo].[RPTIMAGELIB].[RPTIMAGELIBID],
				[dbo].[RPTIMAGELIB].[IMAGENAME],
				[dbo].[RPTIMAGELIB].[FILENAME],
				[dbo].[RPTIMAGELIB].[PRIORFILENAME],
				[dbo].[RPTIMAGELIB].[DIMENSIONS],
				[dbo].[RPTIMAGELIB].[IMAGE],
				[dbo].[RPTIMAGELIB].[LASTCHANGEDBY],
				[dbo].[RPTIMAGELIB].[LASTCHANGEDON],
				[dbo].[RPTIMAGELIB].[ROWVERSION]
	FROM		[dbo].[RPTIMAGELIB]
	ORDER BY	[dbo].[RPTIMAGELIB].[IMAGENAME] ASC
END