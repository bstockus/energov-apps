﻿CREATE FUNCTION [laxreports].[GetCustomFieldTableFloatValue]
(
	@TABLEID char(36),
	@COLUMNID char(36),
	@OBJECTID char(36),
	@MODULEID int,
	@ROWNUMBER int
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @value FLOAT;

	SELECT TOP 1 @value = col.FLOATVALUE 
		FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERTBLCOL_FLT col 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDTABLECOLUMNREF colref ON col.CFTABLECOLUMNREFID = colref.CUSTOMFIELDTABLECOLUMNREFID
		WHERE col.OBJECTID = @OBJECTID AND col.ROWNUMBER = @ROWNUMBER AND colref.CUSTOMFIELDTABLEID = @TABLEID AND colref.CUSTOMFIELDCOLUMNTEMPLATEID = @COLUMNID;

	RETURN @value;

END