﻿CREATE PROCEDURE [globalsearch].[USP_FORMSEARCH_SELECT_LOOKUP]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@USERID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @ROLEID CHAR(36)
DECLARE @REMOVESILVERLIGHTLINKS BIT

	--(from u in ctx.USERS where u.SUSERGUID == userId select u.ROLES.SROLEGUID).Single()
	-- As single() is used in entity framework, we are not using top 1.
	SET @ROLEID = (SELECT [ROLES].[SROLEGUID] FROM [DBO].[USERS] WITH (NOLOCK)
	INNER JOIN [DBO].[ROLES] WITH (NOLOCK) ON [USERS].[SROLEID] = [ROLES].[SROLEGUID]
	WHERE [USERS].[SUSERGUID] = @USERID)
	
	SET @REMOVESILVERLIGHTLINKS = (SELECT TOP 1 BITVALUE FROM SETTINGS WHERE NAME = 'RemoveSilverlightLinks')

	SELECT DISTINCT -- To remove duplicate records use distinct.
	[FORMS].[SFORMSGUID],
	[FORMS].[FKSUBMENUGUID],
	[FORMS].[SFORMNAME],
	[FORMS].[SCOMMONNAME],
	[FORMS].[SHINT],
	[FORMS].[IORDER],
	[FORMS].[BALLOWMULTIPLEINSTANCES],
	[FORMS].[ROOTCLASSNAME],
	[FORMS].[MODULE_ID],
	[FORMS].[URL],
	[FORMS].[IS_HTML_ACTIVE],
	[FORMS].[ICONPATH],
	[FORMS].[HTML_COMMON_NAME],
	[ROLEMENUXREF].[BVISIBLE],
	[ROLESUBMENUXREF].[BVISIBLE],
	[ROLEFORMSXREF].[BVISIBLE],
	[ROLEFORMSXREF].[BALLOWADD],
	[ROLEFORMSXREF].[BALLOWUPDATE],
	[ROLEFORMSXREF].[BALLOWDELETE]
	FROM
	[dbo].[FORMS] WITH (NOLOCK)
	INNER JOIN [DBO].[SUBMENUS] WITH (NOLOCK) ON  [FORMS].[FKSUBMENUGUID] =  [SUBMENUS].[SSUBMENUGUID]
	INNER JOIN [DBO].[MENUS] WITH (NOLOCK) ON [SUBMENUS].[FKMENUGUID]  = [MENUS].[SMENUGUID]
	INNER JOIN [DBO].[ROLEFORMSXREF] WITH (NOLOCK) ON [FORMS].[SFORMSGUID] = [ROLEFORMSXREF].[FKFORMSID]
	INNER JOIN [DBO].[ROLESUBMENUXREF] WITH (NOLOCK) ON [SUBMENUS].[SSUBMENUGUID] = [ROLESUBMENUXREF].[FKSUBMENUID]
	INNER JOIN [DBO].[ROLEMENUXREF] WITH (NOLOCK) ON [MENUS].[SMENUGUID] = [ROLEMENUXREF].[FKMENUID]
	LEFT JOIN [DBO].[FORMEXCEPTION] WITH (NOLOCK) ON [FORMS].[SFORMSGUID] = [FORMEXCEPTION].[SFORMSGUID] 
	WHERE
		([FORMS].[IS_HTML_ACTIVE] IS NULL OR [FORMS].[IS_HTML_ACTIVE] = 0)
		AND( 
			[FORMS].[SCOMMONNAME] like '%'+@SEARCH+'%' 
			OR 	[FORMS].[HTML_COMMON_NAME] like '%'+@SEARCH+'%'
			OR 	[FORMS].[SFORMSGUID] =@SEARCH
			)
		AND [ROLEMENUXREF].[BVISIBLE] = 1 
		AND [ROLEFORMSXREF].[BVISIBLE] = 1 
		AND [ROLESUBMENUXREF].[BVISIBLE] = 1
		AND [ROLEMENUXREF].[FKROLEID] = @ROLEID 
		AND [ROLEFORMSXREF].[FKROLEID] = @ROLEID
		AND ISNULL([FORMEXCEPTION].[ISHTMLSEARCHEXCEPTION], 0) = 0
		AND COALESCE(@REMOVESILVERLIGHTLINKS, 0) <> 1
END