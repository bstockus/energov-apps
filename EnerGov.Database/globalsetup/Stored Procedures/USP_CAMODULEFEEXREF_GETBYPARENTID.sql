﻿CREATE PROCEDURE [globalsetup].[USP_CAMODULEFEEXREF_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	 [dbo].[CAMODULEFEEXREF].[CAMODULEFEEXREFID],
	 [dbo].[CAMODULEFEEXREF].[CAMODULEID],
	 [dbo].[CAMODULEFEEXREF].[CAFEEID],
	 [dbo].[CAMODULEFEEXREF].[CACPIREFERENCEDATEID],
	 [dbo].[CAMODULEFEEXREF].[CACOMPOUNDINGINTERESTREFERENCEDATEID],
	 [dbo].[CAMODULE].[NAME]
FROM [dbo].[CAMODULEFEEXREF]
JOIN [dbo].[CAMODULE] WITH (NOLOCK) ON [dbo].[CAMODULE].[CAMODULEID] =  [dbo].[CAMODULEFEEXREF].[CAMODULEID] 
WHERE
	 [dbo].[CAMODULEFEEXREF].[CAFEEID] = @PARENTID
ORDER BY 
	 [dbo].[CAMODULE].[NAME]
END