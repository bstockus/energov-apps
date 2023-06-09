﻿CREATE PROCEDURE [dbo].[USP_PLSUBMITTALTYPEITEMREVIEWTYPEX_INSERT]
(
 @PLSUBMITTALTYPEITEMREVWTYPXID CHAR(36),
 @PLSUBMITTALTYPEID CHAR(36),
 @PLITEMREVIEWTYPEID CHAR(36),
 @PRIORITY INT,
 @AUTOADD BIT
)
AS

INSERT INTO [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX]
(
[PLSUBMITTALTYPEITEMREVWTYPXID],
[PLSUBMITTALTYPEID],
[PLITEMREVIEWTYPEID],
[PRIORITY],
[AUTOADD]
)

VALUES
(
 @PLSUBMITTALTYPEITEMREVWTYPXID,
 @PLSUBMITTALTYPEID,
 @PLITEMREVIEWTYPEID,
 @PRIORITY,
 @AUTOADD
)