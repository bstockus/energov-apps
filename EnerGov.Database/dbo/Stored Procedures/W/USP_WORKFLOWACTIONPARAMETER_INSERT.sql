﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTIONPARAMETER_INSERT]
(
	@WORKFLOWACTIONPARAMETERID CHAR(36),
	@WORKFLOWACTIONID CHAR(36),
	@PARAMETERNAME NVARCHAR(MAX),
	@PARAMETERVALUE NVARCHAR(MAX),
	@PARAMETERTYPE NVARCHAR(MAX)
)
AS
INSERT INTO [dbo].[WORKFLOWACTIONPARAMETER](
	[WORKFLOWACTIONPARAMETERID],
	[WORKFLOWACTIONID],
	[PARAMETERNAME],
	[PARAMETERVALUE],
	[PARAMETERTYPE]
)

VALUES
(
	@WORKFLOWACTIONPARAMETERID,
	@WORKFLOWACTIONID,
	@PARAMETERNAME,
	@PARAMETERVALUE,
	@PARAMETERTYPE
)