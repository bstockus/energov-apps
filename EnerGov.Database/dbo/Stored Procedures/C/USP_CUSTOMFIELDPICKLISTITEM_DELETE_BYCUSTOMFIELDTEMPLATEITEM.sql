﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDPICKLISTITEM_DELETE_BYCUSTOMFIELDTEMPLATEITEM]
(
	@FKCUSTOMFIELDTEMPLATEITEM CHAR(36)
)
AS
DELETE FROM [dbo].[CUSTOMFIELDPICKLISTITEM]
WHERE
	[FKCUSTOMFIELDTEMPLATEITEM] = @FKCUSTOMFIELDTEMPLATEITEM