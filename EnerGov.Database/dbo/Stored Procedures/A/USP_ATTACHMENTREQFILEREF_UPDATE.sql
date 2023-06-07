﻿CREATE PROCEDURE [dbo].[USP_ATTACHMENTREQFILEREF_UPDATE]
(
	@ATTACHMENTREQFILEREFID CHAR(36),
	@NAME NVARCHAR(260),
	@ISREQUIRED BIT,
	@QUANTITY INT,
	@ATTACHMENTGROUPID CHAR(36),
	@OBJECTCLASSID CHAR(36),
	@OBJECTTYPEID CHAR(36)
)
AS

UPDATE [dbo].[ATTACHMENTREQFILEREF] SET
	[NAME] = @NAME,
	[ISREQUIRED] = @ISREQUIRED,
	[QUANTITY] = @QUANTITY,
	[ATTACHMENTGROUPID] = @ATTACHMENTGROUPID,
	[OBJECTCLASSID] = @OBJECTCLASSID,
	[OBJECTTYPEID] = @OBJECTTYPEID

WHERE
	[ATTACHMENTREQFILEREFID] = @ATTACHMENTREQFILEREFID