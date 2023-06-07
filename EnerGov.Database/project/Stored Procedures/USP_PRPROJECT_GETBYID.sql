﻿CREATE PROCEDURE [project].[USP_PRPROJECT_GETBYID]
(
	 @ID AS CHAR(36)
)
AS
BEGIN
	DECLARE @PRPROJECTLIST AS RecordIDs
	INSERT INTO @PRPROJECTLIST (RECORDID) VALUES (@ID)

	EXEC [project].[USP_PRPROJECT_GETBYIDS] @PRPROJECTLIST, NULL
END