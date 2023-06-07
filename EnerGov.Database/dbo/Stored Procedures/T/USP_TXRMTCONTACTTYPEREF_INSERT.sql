﻿CREATE PROCEDURE [dbo].[USP_TXRMTCONTACTTYPEREF_INSERT]
(
	@CONTACTTYPEEXTID CHAR(36),
	@TXREMITTANCETYPEID CHAR(36),
	@BLCONTACTTYPEID CHAR(36),
	@CONTACTTYPEGROUPID INT,
	@ISREQUIRED BIT
)
AS

INSERT INTO [dbo].[TXRMTCONTACTTYPEREF](
	[CONTACTTYPEEXTID],
	[TXREMITTANCETYPEID],
	[BLCONTACTTYPEID],
	[CONTACTTYPEGROUPID],
	[ISREQUIRED]
)

VALUES
(
	@CONTACTTYPEEXTID,
	@TXREMITTANCETYPEID,
	@BLCONTACTTYPEID,
	@CONTACTTYPEGROUPID,
	@ISREQUIRED
)