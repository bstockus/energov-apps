﻿CREATE PROCEDURE [dbo].[USP_IPCASEALLOWEDCONTACTTYPE_UPDATE]
(
	@IPCASEALLOWEDCONTACTTYPEID CHAR(36),
	@IPCASETYPEID CHAR(36),
	@CONTACTTYPEID CHAR(36),
	@ISREQUIRED BIT,
	@CONTACTTYPEGROUP INT
)
AS

UPDATE [dbo].[IPCASEALLOWEDCONTACTTYPE] SET
	[IPCASETYPEID] = @IPCASETYPEID,
	[CONTACTTYPEID] = @CONTACTTYPEID,
	[ISREQUIRED] = @ISREQUIRED,
	[CONTACTTYPEGROUP] = @CONTACTTYPEGROUP

WHERE
	[IPCASEALLOWEDCONTACTTYPEID] = @IPCASEALLOWEDCONTACTTYPEID