﻿CREATE PROCEDURE [dbo].[USP_CMCODECASECONTACTTYPEREF_INSERT]
(
	@CONTACTTYPEEXTID CHAR(36),
	@CMCODECASECONTACTTYPEID CHAR(36),
	@CONTACTTYPEGROUP INT,
	@ISREQUIRED BIT,
	@OBJCLASSID CHAR(36),
	@OBJTYPEID CHAR(36),
	@OBJMODULEID INT
)
AS

INSERT INTO [dbo].[CMCODECASECONTACTTYPEREF](
	[CONTACTTYPEEXTID],
	[CMCODECASECONTACTTYPEID],
	[CONTACTTYPEGROUP],
	[ISREQUIRED],
	[OBJCLASSID],
	[OBJTYPEID],
	[OBJMODULEID]
)

VALUES
(
	@CONTACTTYPEEXTID,
	@CMCODECASECONTACTTYPEID,
	@CONTACTTYPEGROUP,
	@ISREQUIRED,
	@OBJCLASSID,
	@OBJTYPEID,
	@OBJMODULEID
)