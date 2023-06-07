﻿CREATE PROCEDURE [globalsearch].[USP_LANDLORDLICENSE_SEARCH_BY_CASE_NUMBER]
(
	@SEARCH AS NVARCHAR(MAX) = ''
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 	[RPLANDLORDLICENSE].[RPLANDLORDLICENSEID],[RPLANDLORDLICENSE].[LANDLORDNUMBER]
FROM [dbo].[RPLANDLORDLICENSE]
WHERE [RPLANDLORDLICENSE].[LANDLORDNUMBER] LIKE '%'+@SEARCH+'%'
END