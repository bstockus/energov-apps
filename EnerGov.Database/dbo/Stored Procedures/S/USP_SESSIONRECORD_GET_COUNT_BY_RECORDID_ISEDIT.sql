﻿CREATE PROCEDURE [dbo].[USP_SESSIONRECORD_GET_COUNT_BY_RECORDID_ISEDIT]
  @RecordId CHAR(36)
AS
BEGIN
  SELECT COUNT(1) FROM SESSIONRECORD WHERE RECORDID = @RecordId AND ISEDIT = 1
END