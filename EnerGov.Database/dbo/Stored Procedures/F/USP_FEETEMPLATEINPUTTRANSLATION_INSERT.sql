﻿CREATE PROCEDURE [dbo].[USP_FEETEMPLATEINPUTTRANSLATION_INSERT]
(
	@TRANSLATIONID CHAR(36),
	@INPUTID CHAR(36),
	@PROPERTYVALUE NVARCHAR(MAX),
	@TRANSLATEDVALUE NVARCHAR(MAX),
	@ISFEEINPUTTRANSLATION BIT
)
AS

IF @ISFEEINPUTTRANSLATION = 1
	BEGIN
		INSERT INTO [dbo].[CAFEEINPUTTRANSLATION](
			[CAFEEINPUTTRANSLATIONID],
			[CAFEETEMPLATEFEEINPUTID],
			[PROPERTYVALUE],
			[TRANSLATEDVALUE]
		)
		VALUES
		(
			@TRANSLATIONID,
			@INPUTID,
			@PROPERTYVALUE,
			@TRANSLATEDVALUE
		)
	END
ELSE
	BEGIN
		INSERT INTO [dbo].[CADISCOUNTINPUTTRANSLATION](
			[CADISCOUNTINPUTTRANSLATIONID],
			[CAFEETEMPLATEDISCOUNTINPUTID],
			[PROPERTYVALUE],
			[TRANSLATEDVALUE]
		)
		VALUES
		(
			@TRANSLATIONID,
			@INPUTID,
			@PROPERTYVALUE,
			@TRANSLATEDVALUE
		)
	END