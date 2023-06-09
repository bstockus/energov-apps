﻿CREATE PROCEDURE [dbo].[USP_SET_USERID_AND_CASE_TO_CONTEXT_INFO] 
@CONTEXTUSERID CHAR(36),
@CONTEXTCASETEXT VARCHAR(50) = NULL
AS
BEGIN
  DECLARE @EncodedKey VARBINARY(128);
  IF @CONTEXTCASETEXT IS NULL
  BEGIN
    SET @EncodedKey = CONVERT(VARBINARY(128), CONVERT(CHAR(36), @CONTEXTUSERID))
  END
  ELSE
  BEGIN
    SET @EncodedKey = CONVERT(VARBINARY(128), @CONTEXTUSERID + '_' + @CONTEXTCASETEXT)
  END
  SET CONTEXT_INFO @EncodedKey;
END