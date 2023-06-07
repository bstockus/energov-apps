﻿CREATE PROCEDURE [dbo].[USP_GISZONETOREVIEWITEMDESIG_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS

DECLARE @ZONEREVIEWITEMVALUELIST as TABLE ([ID] CHAR(36))

INSERT INTO @ZONEREVIEWITEMVALUELIST 
SELECT  [GISZONEREVIEWITEMVALUEID]  
FROM	[dbo].[GISZONEREVIEWITEMVALUE] 
WHERE	[GISZONEREVIEWITEMMAPPINGID] = @PARENTID

DELETE	GISZONETOREVIEWITEMDESIG 
FROM	[dbo].[GISZONETOREVIEWITEMDESIG] GISZONETOREVIEWITEMDESIG
		INNER JOIN @ZONEREVIEWITEMVALUELIST ZONEREVIEWITEMVALUELIST ON GISZONETOREVIEWITEMDESIG.GISZONEREVIEWITEMVALUEID = ZONEREVIEWITEMVALUELIST.ID