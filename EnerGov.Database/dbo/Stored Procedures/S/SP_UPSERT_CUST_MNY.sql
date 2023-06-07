﻿
CREATE PROCEDURE SP_UPSERT_CUST_MNY
	@CUSTOM_DATA CUSTOM_MNY_TYPE READONLY
AS
BEGIN
	
	SET NOCOUNT ON;
	UPDATE TARGET SET TARGET.CURRENCYVALUE = SOURCE.CURRENCYVALUE
	FROM CUSTOMSAVERTBLCOL_MNY TARGET
	INNER JOIN  @CUSTOM_DATA AS SOURCE ON 
		TARGET.OBJECTID = SOURCE.PARENT_ID AND TARGET.CFTABLECOLUMNREFID = SOURCE.CUSTOM_FIELD_ID AND TARGET.ROWNUMBER = SOURCE.ROWNUMBER

	INSERT INTO CUSTOMSAVERTBLCOL_MNY
		(
			CUSTOMSAVERTABLECOLUMNID,
			OBJECTID,
			MODULEID,
			CFTABLECOLUMNREFID,
			CURRENCYVALUE,
			ROWNUMBER
		)
	SELECT 
		SOURCE.ID,
		SOURCE.PARENT_ID,
		SOURCE.MODULEID,
		SOURCE.CUSTOM_FIELD_ID,
		SOURCE.CURRENCYVALUE,
		SOURCE.ROWNUMBER
	FROM @CUSTOM_DATA SOURCE
	LEFT OUTER JOIN CUSTOMSAVERTBLCOL_MNY TARGET WITH (NOLOCK) ON 
		TARGET.OBJECTID = SOURCE.PARENT_ID AND TARGET.CFTABLECOLUMNREFID = SOURCE.CUSTOM_FIELD_ID AND TARGET.ROWNUMBER = SOURCE.ROWNUMBER
	WHERE TARGET.CUSTOMSAVERTABLECOLUMNID IS NULL

END