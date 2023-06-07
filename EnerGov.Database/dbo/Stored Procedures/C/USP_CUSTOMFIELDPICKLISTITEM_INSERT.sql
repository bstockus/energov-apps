﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDPICKLISTITEM_INSERT]
(
	@GCUSTOMFIELDPICKLISTITEM CHAR(36),
	@FKGCUSTOMFIELDPICKLIST CHAR(36),
	@SVALUE VARCHAR(50),
	@IORDER INT,
	@ISRETIRE BIT,
	@FKCUSTOMFIELDTEMPLATEITEM CHAR(36)
)
AS

INSERT INTO [dbo].[CUSTOMFIELDPICKLISTITEM](
	[GCUSTOMFIELDPICKLISTITEM],
	[FKGCUSTOMFIELDPICKLIST],
	[SVALUE],
	[IORDER],
	[ISRETIRE],
	[FKCUSTOMFIELDTEMPLATEITEM]
)

VALUES
(
	@GCUSTOMFIELDPICKLISTITEM,
	@FKGCUSTOMFIELDPICKLIST,
	@SVALUE,
	@IORDER,
	@ISRETIRE,
	@FKCUSTOMFIELDTEMPLATEITEM
)