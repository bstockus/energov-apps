﻿CREATE FUNCTION [dbo].[USF_HAS_BLLICENSETYPE_USED_BY_BLLICENSETYPEID]
(
	@BLLICENSETYPEID CHAR(36)  
)
RETURNS BIT
AS
BEGIN
	DECLARE @RESULT AS BIT = 0
    
    IF EXISTS (SELECT 1 FROM [dbo].[BLLICENSEALLOWEDACTIVITY] WHERE [BLLICENSETYPEID] = @BLLICENSETYPEID)
	BEGIN
		SET @RESULT = 1
	END
	ELSE  IF EXISTS (SELECT 1 FROM [dbo].[BLLICENSETYPECLASS] WHERE [BLLICENSETYPEID] = @BLLICENSETYPEID)
	BEGIN
		SET @RESULT = 1
	END
	  IF EXISTS (SELECT 1 FROM [dbo].[BLLICENSEWFACTIONSTEP] WHERE [BLLICENSETYPEID] = @BLLICENSETYPEID)
	BEGIN
		SET @RESULT = 1
	END
	ELSE  IF EXISTS (SELECT 1 FROM [dbo].[PMPERMITTYPEBUSLICTYPE] WHERE [BLLICENSETYPEID] = @BLLICENSETYPEID)
	BEGIN
		SET @RESULT = 1
	END
	ELSE  IF EXISTS (SELECT 1 FROM [dbo].[PMPERMITWFACTIONSTEP] WHERE [BLLICENSETYPEID] = @BLLICENSETYPEID)
	BEGIN
		SET @RESULT = 1
	END
	ELSE  IF EXISTS (SELECT 1 FROM [dbo].[SEARCHBUSINESSLICENSE] WHERE [BLLICENSETYPEID] = @BLLICENSETYPEID)
	BEGIN
		SET @RESULT = 1
	END
    
	RETURN @RESULT
END