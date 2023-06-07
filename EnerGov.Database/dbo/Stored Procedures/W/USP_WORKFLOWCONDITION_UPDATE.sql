﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWCONDITION_UPDATE]
(
	@WORKFLOWCONDITIONID CHAR(36),
	@WORKFLOWCONDITIONGROUPID CHAR(36),
	@CLASSNAME NVARCHAR(MAX),
	@FRIENDLYCLASSNAME NVARCHAR(MAX),
	@PROPERTYNAME NVARCHAR(MAX),
	@FRIENDLYPROPERTYNAME NVARCHAR(MAX),
	@WORKFLOWCLASSCONDITIONTYPEID INT,
	@WORKFLOWPROPERTYCONDTYPEID INT,
	@PROPERTYCONDITIONCOMPAREVALUE NVARCHAR(MAX),
	@CONDITIONNUMBER INT,
	@WORKFLOWCONTROLTYPEID INT,
	@CUSTOMFIELDNAME NVARCHAR(MAX),
	@CUSTOMFIELDTABLE NVARCHAR(MAX)
)
AS
DECLARE @OUTPUTTABLE as TABLE([WORKFLOWCONDITIONID]  char(36))
UPDATE [dbo].[WORKFLOWCONDITION] SET
	[WORKFLOWCONDITIONGROUPID] = @WORKFLOWCONDITIONGROUPID,
	[CLASSNAME] = @CLASSNAME,
	[FRIENDLYCLASSNAME] = @FRIENDLYCLASSNAME,
	[PROPERTYNAME] = @PROPERTYNAME,
	[FRIENDLYPROPERTYNAME] = @FRIENDLYPROPERTYNAME,
	[WORKFLOWCLASSCONDITIONTYPEID] = @WORKFLOWCLASSCONDITIONTYPEID,
	[WORKFLOWPROPERTYCONDTYPEID] = @WORKFLOWPROPERTYCONDTYPEID,
	[PROPERTYCONDITIONCOMPAREVALUE] = @PROPERTYCONDITIONCOMPAREVALUE,
	[CONDITIONNUMBER] = @CONDITIONNUMBER,
	[WORKFLOWCONTROLTYPEID] = @WORKFLOWCONTROLTYPEID,
	[CUSTOMFIELDNAME] = @CUSTOMFIELDNAME,
	[CUSTOMFIELDTABLE] = @CUSTOMFIELDTABLE
OUTPUT inserted.[WORKFLOWCONDITIONID] INTO @OUTPUTTABLE
WHERE
	[WORKFLOWCONDITIONID] = @WORKFLOWCONDITIONID AND 
	[WORKFLOWCONDITIONGROUPID]= @WORKFLOWCONDITIONGROUPID

SELECT * FROM @OUTPUTTABLE