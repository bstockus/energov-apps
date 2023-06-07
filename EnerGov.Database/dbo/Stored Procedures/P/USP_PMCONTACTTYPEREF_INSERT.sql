﻿CREATE PROCEDURE [dbo].[USP_PMCONTACTTYPEREF_INSERT]
(
	@CONTACTTYPEEXTID CHAR(36),
	@LANDMANAGEMENTCONTACTTYPEID CHAR(36),
	@CONTACTTYPEGROUP INT,
	@ISREQUIRED BIT,
	@OBJCLASSID CHAR(36),
	@OBJTYPEID CHAR(36),
	@OBJMODULEID INT,
	@ISDEFAULTONLINECONTACTTYPE BIT
)
AS
INSERT INTO [dbo].[PMCONTACTTYPEREF](
	[CONTACTTYPEEXTID],
	[LANDMANAGEMENTCONTACTTYPEID],
	[CONTACTTYPEGROUP],
	[ISREQUIRED],
	[OBJCLASSID],
	[OBJTYPEID],
	[OBJMODULEID],
	[ISDEFAULTONLINECONTACTTYPE]
)
VALUES
(
	@CONTACTTYPEEXTID,
	@LANDMANAGEMENTCONTACTTYPEID,
	@CONTACTTYPEGROUP,
	@ISREQUIRED,
	@OBJCLASSID,
	@OBJTYPEID,
	@OBJMODULEID,
	@ISDEFAULTONLINECONTACTTYPE
)