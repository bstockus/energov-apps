﻿CREATE PROCEDURE [dbo].[USP_CACONDITION_INSERT]
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

INSERT INTO [dbo].[CACONDITION](
	[CACONDITIONID],
	[CACONDITIONGROUPID],
	[OPERANDTYPEID],
	[OPERANDVALUE],
	[OPERANDFRIENDLYNAME],
	[OPERANDDATATYPEID],
	[OPERATORID],
	[COMPAREEXPRESSIONID],
	[CLASSNAME],
	[CUSTOMFIELDTABLE]
)

VALUES
(
	@CACONDITIONID,
	@CACONDITIONGROUPID,
	@OPERANDTYPEID,
	@OPERANDVALUE,
	@OPERANDFRIENDLYNAME,
	@OPERANDDATATYPEID,
	@OPERATORID,
	@COMPAREEXPRESSIONID,
	@CLASSNAME,
	@CUSTOMFIELDTABLE
)