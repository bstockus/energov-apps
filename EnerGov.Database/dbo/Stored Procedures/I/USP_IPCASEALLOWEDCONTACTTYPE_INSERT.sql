﻿CREATE PROCEDURE [dbo].[USP_IPCASEALLOWEDCONTACTTYPE_INSERT]
(
	@IPCASEALLOWEDCONTACTTYPEID CHAR(36),
	@IPCASETYPEID CHAR(36),
	@CONTACTTYPEID CHAR(36),
	@ISREQUIRED BIT,
	@CONTACTTYPEGROUP INT
)
AS

INSERT INTO [dbo].[IPCASEALLOWEDCONTACTTYPE](
	[IPCASEALLOWEDCONTACTTYPEID],
	[IPCASETYPEID],
	[CONTACTTYPEID],
	[ISREQUIRED],
	[CONTACTTYPEGROUP]
)

VALUES
(
	@IPCASEALLOWEDCONTACTTYPEID,
	@IPCASETYPEID,
	@CONTACTTYPEID,
	@ISREQUIRED,
	@CONTACTTYPEGROUP
)