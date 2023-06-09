﻿CREATE PROCEDURE [dbo].[USP_CACONDITION_UPDATE]
(
	@CACONDITIONID CHAR(36),
	@CACONDITIONGROUPID CHAR(36),
	@OPERANDTYPEID INT,
	@OPERANDVALUE NVARCHAR(100),
	@OPERANDFRIENDLYNAME NVARCHAR(MAX),
	@OPERANDDATATYPEID INT,
	@OPERATORID INT,
	@COMPAREEXPRESSIONID CHAR(36),
	@CLASSNAME NVARCHAR(MAX),
	@CUSTOMFIELDTABLE NVARCHAR(MAX)
)
AS

UPDATE [dbo].[CACONDITION] SET
	[CACONDITIONGROUPID] = @CACONDITIONGROUPID,
	[OPERANDTYPEID] = @OPERANDTYPEID,
	[OPERANDVALUE] = @OPERANDVALUE,
	[OPERANDFRIENDLYNAME] = @OPERANDFRIENDLYNAME,
	[OPERANDDATATYPEID] = @OPERANDDATATYPEID,
	[OPERATORID] = @OPERATORID,
	[COMPAREEXPRESSIONID] = @COMPAREEXPRESSIONID,
	[CLASSNAME] = @CLASSNAME,
	[CUSTOMFIELDTABLE] = @CUSTOMFIELDTABLE

WHERE
	[CACONDITIONID] = @CACONDITIONID