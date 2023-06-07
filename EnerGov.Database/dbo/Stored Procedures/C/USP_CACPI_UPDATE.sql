﻿CREATE PROCEDURE [dbo].[USP_CACPI_UPDATE]
(
	@CACPIID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(255),
	@STARTDATE DATETIME,
	@ENDDATE DATETIME,
	@CPIVALUE DECIMAL(20,4)
)
AS

UPDATE [dbo].[CACPI] SET	
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[STARTDATE] = @STARTDATE,
	[ENDDATE] = @ENDDATE,
	[CPIVALUE] = @CPIVALUE

WHERE
	[CACPIID] = @CACPIID