﻿
CREATE PROCEDURE SP_UPSERT_CUST_BLN
	@CUSTOM_DATA CUSTOM_BLN_TYPE READONLY
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE TARGET SET TARGET.BITVALUE = SOURCE.BITVALUE
	FROM CUSTOMSAVERTBLCOL_BLN TARGET
	INNER JOIN  @CUSTOM_DATA AS SOURCE ON 
		TARGET.OBJECTID = SOURCE.PARENT_ID AND TARGET.CFTABLECOLUMNREFID = SOURCE.CUSTOM_FIELD_ID AND TARGET.ROWNUMBER = SOURCE.ROWNUMBER

	INSERT INTO CUSTOMSAVERTBLCOL_BLN
		(
			CUSTOMSAVERTABLECOLUMNID,
			OBJECTID,
			MODULEID,
			CFTABLECOLUMNREFID,
			BITVALUE,
			ROWNUMBER
		)
	SELECT 
		SOURCE.ID,
		SOURCE.PARENT_ID,
		SOURCE.MODULEID,
		SOURCE.CUSTOM_FIELD_ID,
		SOURCE.BITVALUE,
		SOURCE.ROWNUMBER
	FROM @CUSTOM_DATA SOURCE
	LEFT OUTER JOIN CUSTOMSAVERTBLCOL_BLN TARGET WITH (NOLOCK) ON 
		TARGET.OBJECTID = SOURCE.PARENT_ID AND TARGET.CFTABLECOLUMNREFID = SOURCE.CUSTOM_FIELD_ID AND TARGET.ROWNUMBER = SOURCE.ROWNUMBER
	WHERE TARGET.CUSTOMSAVERTABLECOLUMNID IS NULL

END