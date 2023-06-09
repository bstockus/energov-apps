﻿CREATE FUNCTION [reviewcoordinator].[UFN_IS_SNOOZED]
(
	@SNOOZETYPEID INT,
	@HASUNPAIDFEES BIT = 0,
	@SNOOZUNTILDATE DATE = NULL,	
	@TODAY DATE = NULL
)
RETURNS BIT
AS
BEGIN
DECLARE @isSnoozed BIT = 0

DECLARE @untilDate int = 2
DECLARE @feesPaidInFull int = 3

IF ((@SNOOZETYPEID = @feesPaidInFull AND @HASUNPAIDFEES = 1) OR (@SNOOZETYPEID = @untilDate AND ((@TODAY IS NULL AND @SNOOZUNTILDATE IS NOT NULL) OR @SNOOZUNTILDATE > @TODAY)))
BEGIN
	SET @isSnoozed = 1
END

return @isSnoozed
END