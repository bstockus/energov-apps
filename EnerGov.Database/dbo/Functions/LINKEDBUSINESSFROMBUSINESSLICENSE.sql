﻿CREATE FUNCTION [dbo].[LINKEDBUSINESSFROMBUSINESSLICENSE]
(
	@ENTITY_ID char(36),
	@BLEXTCOMPANYTYPEMODULE_ID INT
)
RETURNS TABLE 
AS
RETURN 
(		
	SELECT blg.BLGLOBALENTITYEXTENSIONID FROM BLGLOBALENTITYEXTENSION blg
	INNER JOIN BLLICENSE bl ON bl.BLGLOBALENTITYEXTENSIONID=blg.BLGLOBALENTITYEXTENSIONID
	INNER JOIN BLEXTCOMPANYTYPE ON BLEXTCOMPANYTYPE.BLEXTCOMPANYTYPEID = blg.BLEXTCOMPANYTYPEID
	WHERE bl.BLLICENSEID = @ENTITY_ID AND BLEXTCOMPANYTYPE.BLEXTCOMPANYTYPEMODULEID= @BLEXTCOMPANYTYPEMODULE_ID	
)