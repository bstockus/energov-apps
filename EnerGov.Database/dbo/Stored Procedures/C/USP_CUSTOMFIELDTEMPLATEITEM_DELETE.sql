﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDTEMPLATEITEM_DELETE]
(
@GCUSTOMFIELDTEMPLATEITEM CHAR(36)
)
AS

EXEC [dbo].[USP_CUSTOMFIELDPICKLISTITEM_DELETE_BYCUSTOMFIELDTEMPLATEITEM] @GCUSTOMFIELDTEMPLATEITEM

DELETE FROM [dbo].[CUSTOMFIELDTEMPLATEITEM]
	WHERE
		[GCUSTOMFIELDTEMPLATEITEM] = @GCUSTOMFIELDTEMPLATEITEM