﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDPICKLISTITEM_DELETE_BYPARENTID]
(
	@RECORDIDs RecordIDs READONLY
)
AS
DELETE FROM [dbo].[CUSTOMFIELDPICKLISTITEM]
WHERE
	[FKGCUSTOMFIELDPICKLIST] IN (
	SELECT 
		GCUSTOMFIELDPICKLIST 
	FROM [dbo].[CUSTOMFIELDPICKLIST] 
	INNER JOIN 	@RECORDIDs AS DELETED_CUSTOM_FIELDS ON DELETED_CUSTOM_FIELDS.RECORDID = [dbo].[CUSTOMFIELDPICKLIST].[FKGCUSTOMFIELD])