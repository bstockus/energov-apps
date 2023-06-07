﻿CREATE PROCEDURE [dbo].[USP_FEETEMPLATEINPUT_UPDATE]
	@INPUTID CHAR(36),
	@PARENTID CHAR(36),
	@INPUTTYPEID INT,
	@INPUTVALUE NVARCHAR(50),
	@INPUTFRIENDLYNAME NVARCHAR(MAX),
	@ISDISPLAY BIT,
	@CUSTOMFIELDTABLE NVARCHAR(MAX),
	@CLASSNAME NVARCHAR(MAX),
	@ISFEEINPUT BIT
AS
IF @ISFEEINPUT = 1
	BEGIN
		UPDATE [dbo].[CAFEETEMPLATEFEEINPUT] SET
			[CAFEETEMPLATEFEEID] = @PARENTID,
			[CAFEETEMPLATEINPUTTYPEID] = @INPUTTYPEID,
			[INPUTVALUE] = @INPUTVALUE,
			[INPUTFRIENDLYNAME] = @INPUTFRIENDLYNAME,
			[ISDISPLAY] = @ISDISPLAY,
			[CUSTOMFIELDTABLE] = @CUSTOMFIELDTABLE,
			[CLASSNAME] = @CLASSNAME
		WHERE
			[CAFEETEMPLATEFEEINPUTID] = @INPUTID
	END
ELSE
	BEGIN
		UPDATE [dbo].[CAFEETEMPLATEDISCOUNTINPUT] SET
			[CAFEETEMPLATEDISCOUNTID] = @PARENTID,
			[CAFEETEMPLATEINPUTTYPEID] = @INPUTTYPEID,
			[INPUTVALUE] = @INPUTVALUE,
			[INPUTFRIENDLYNAME] = @INPUTFRIENDLYNAME,
			[ISDISPLAY] = @ISDISPLAY,
			[CLASSNAME] = @CLASSNAME
		WHERE
			[CAFEETEMPLATEDISCOUNTINPUTID] = @INPUTID
END