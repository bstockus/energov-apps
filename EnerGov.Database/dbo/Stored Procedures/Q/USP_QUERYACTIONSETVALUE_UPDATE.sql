﻿CREATE PROCEDURE [dbo].[USP_QUERYACTIONSETVALUE_UPDATE]
(
	@QUERYACTIONSETVALUEID CHAR(36),
	@QUERYACTIONID CHAR(36),
	@SETVALUEFIELD NVARCHAR(MAX),
	@SETVALUEFIELDFRIENDLYNAME NVARCHAR(50),
	@SETVALUEFIELDVALUE NVARCHAR(MAX),
	@SETVALUEFIELDADJUSTMENTVALUE NVARCHAR(MAX),
	@SETVALUEWEEKDAYSONLY BIT,
	@SETVALUEUSEPREVIOUSWEEKDAY BIT
)
AS
DECLARE @OUTPUTTABLE as TABLE([QUERYACTIONSETVALUEID]  char(36))
UPDATE [dbo].[QUERYACTIONSETVALUE] SET
	[QUERYACTIONID] = @QUERYACTIONID,
	[SETVALUEFIELD] = @SETVALUEFIELD,
	[SETVALUEFIELDFRIENDLYNAME] = @SETVALUEFIELDFRIENDLYNAME,
	[SETVALUEFIELDVALUE] = @SETVALUEFIELDVALUE,
	[SETVALUEFIELDADJUSTMENTVALUE] = @SETVALUEFIELDADJUSTMENTVALUE,
	[SETVALUEWEEKDAYSONLY] = @SETVALUEWEEKDAYSONLY,
	[SETVALUEUSEPREVIOUSWEEKDAY] = @SETVALUEUSEPREVIOUSWEEKDAY
OUTPUT inserted.[QUERYACTIONSETVALUEID] INTO @OUTPUTTABLE
WHERE
	[QUERYACTIONSETVALUEID] = @QUERYACTIONSETVALUEID  
SELECT * FROM @OUTPUTTABLE