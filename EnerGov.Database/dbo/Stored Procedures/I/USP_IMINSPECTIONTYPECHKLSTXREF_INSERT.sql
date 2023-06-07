﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONTYPECHKLSTXREF_INSERT]
(
	@IMINSPECTIONTYPECHKLSTXREFID CHAR(36),
	@IMCHECKLISTID CHAR(36),
	@IMINSPECTIONTYPEID CHAR(36),
	@SORTORDER INT,
	@AUTOADD BIT
)
AS

INSERT INTO [dbo].[IMINSPECTIONTYPECHKLSTXREF](
	[IMINSPECTIONTYPECHKLSTXREFID],
	[IMCHECKLISTID],
	[IMINSPECTIONTYPEID],
	[SORTORDER],
	[AUTOADD]
)

VALUES
(
	@IMINSPECTIONTYPECHKLSTXREFID,
	@IMCHECKLISTID,
	@IMINSPECTIONTYPEID,
	@SORTORDER,
	@AUTOADD
)