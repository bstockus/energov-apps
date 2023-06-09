﻿CREATE PROCEDURE [dbo].[USP_CAFEETEMPLATE_INSERT]
	@CAFEETEMPLATEID AS CHAR(36),
	@CAFEETEMPLATENAME AS NVARCHAR(30),
	@CAENTITYID AS INT,
	@CAFEETEMPLATEDESCRIPTION AS NVARCHAR(MAX),
	@ROWVERSION AS INT,
	@LASTCHANGEDON AS DATETIME,
	@LASTCHANGEDBY AS CHAR(36)
AS
BEGIN
	
	DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
	
	INSERT INTO [dbo].[CAFEETEMPLATE] 
			(
			[CAFEETEMPLATEID], 
			[CAENTITYID], 
			[CAFEETEMPLATENAME], 
			[CAFEETEMPLATEDESCRIPTION], 
			[ROWVERSION], 
			[LASTCHANGEDON], 
			[LASTCHANGEDBY]
			)
			OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
	VALUES	(
			@CAFEETEMPLATEID,
			@CAENTITYID,
			@CAFEETEMPLATENAME,
			@CAFEETEMPLATEDESCRIPTION,
			@ROWVERSION,
			@LASTCHANGEDON,
			@LASTCHANGEDBY
			)
			
	SELECT * FROM @OUTPUTTABLE

END