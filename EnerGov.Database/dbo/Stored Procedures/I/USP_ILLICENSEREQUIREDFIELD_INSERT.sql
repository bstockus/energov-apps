﻿CREATE PROCEDURE [dbo].[USP_ILLICENSEREQUIREDFIELD_INSERT]
(
	@REQUIREDCUSTOMFIELDID CHAR(36),
	@ILLICENSETYPELICENSECLASSID CHAR(36),
	@GCUSTOMFIELD CHAR(36),
	@SORTORDER INT
)
AS

INSERT INTO [dbo].[ILLICENSEREQUIREDFIELD](
	[REQUIREDCUSTOMFIELDID],
	[ILLICENSETYPELICENSECLASSID],
	[GCUSTOMFIELD],
	[SORTORDER]
)

VALUES
(
	@REQUIREDCUSTOMFIELDID,
	@ILLICENSETYPELICENSECLASSID,
	@GCUSTOMFIELD,
	@SORTORDER
)