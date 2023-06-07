﻿CREATE PROCEDURE [dbo].[USP_CAFEETIMETRACKINGTYPEXREF_INSERT]
(
	@CAFEETIMETRACKINGTYPEXREFID CHAR(36),
	@CAFEEID CHAR(36),
	@TIMETRACKINGTYPEID CHAR(36)
)
AS

INSERT INTO [dbo].[CAFEETIMETRACKINGTYPEXREF](
	[CAFEETIMETRACKINGTYPEXREFID],
	[CAFEEID],
	[TIMETRACKINGTYPEID]
)

VALUES
(
	@CAFEETIMETRACKINGTYPEXREFID,
	@CAFEEID,
	@TIMETRACKINGTYPEID
)