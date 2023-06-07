﻿
CREATE PROCEDURE SP_UPSERT_CUST_LST
	@CUSTOM_DATA CUSTOM_LST_TYPE READONLY
AS
BEGIN
	
	SET NOCOUNT ON;
	UPDATE TARGET SET TARGET.PICKLISTVALUE = SOURCE.PICKLISTVALUE
	FROM CUSTOMSAVERTBLCOL_LST TARGET
	INNER JOIN  @CUSTOM_DATA AS SOURCE ON 
		TARGET.OBJECTID = SOURCE.PARENT_ID AND TARGET.CFTABLECOLUMNREFID = SOURCE.CUSTOM_FIELD_ID AND TARGET.ROWNUMBER = SOURCE.ROWNUMBER

	INSERT INTO CUSTOMSAVERTBLCOL_LST
		(
			CUSTOMSAVERTABLECOLUMNID,
			OBJECTID,
			MODULEID,
			CFTABLECOLUMNREFID,
			PICKLISTVALUE,
			ROWNUMBER
		)
	SELECT 
		SOURCE.ID,
		SOURCE.PARENT_ID,
		SOURCE.MODULEID,
		SOURCE.CUSTOM_FIELD_ID,
		SOURCE.PICKLISTVALUE,
		SOURCE.ROWNUMBER
	FROM @CUSTOM_DATA SOURCE
	LEFT OUTER JOIN CUSTOMSAVERTBLCOL_LST TARGET WITH (NOLOCK) ON 
		TARGET.OBJECTID = SOURCE.PARENT_ID AND TARGET.CFTABLECOLUMNREFID = SOURCE.CUSTOM_FIELD_ID AND TARGET.ROWNUMBER = SOURCE.ROWNUMBER
	WHERE TARGET.CUSTOMSAVERTABLECOLUMNID IS NULL

END