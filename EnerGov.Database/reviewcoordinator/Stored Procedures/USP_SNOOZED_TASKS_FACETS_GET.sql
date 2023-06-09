﻿CREATE PROCEDURE [reviewcoordinator].[USP_SNOOZED_TASKS_FACETS_GET]
	@ASSIGNEDUSERIDS AS RECORDIDS READONLY,
	@ASSIGNEDTEAMIDS AS RECORDIDS READONLY,
	@OWNEDTEAMIDS AS RECORDIDS READONLY,
	@TODAY AS DATE = NULL
AS
BEGIN
SET NOCOUNT ON;
DECLARE @facetTypeSnoozed INT = 2;

EXEC [reviewcoordinator].[USP_INBOX_CARD_FACETS_GET_TASK_TYPE] @FACETTYPE = @facetTypeSnoozed, @ASSIGNEDUSERIDS = @ASSIGNEDUSERIDS, @ASSIGNEDTEAMIDS = @ASSIGNEDTEAMIDS, @TODAY = @TODAY
EXEC [reviewcoordinator].[USP_INBOX_CARD_FACETS_GET_ENTITY_TYPE] @FACETTYPE = @facetTypeSnoozed, @ASSIGNEDUSERIDS = @ASSIGNEDUSERIDS, @ASSIGNEDTEAMIDS = @ASSIGNEDTEAMIDS, @TODAY = @TODAY
EXEC [reviewcoordinator].[USP_INBOX_CARD_FACETS_GET_ENTITY_NUMBER] @FACETTYPE = @facetTypeSnoozed, @ASSIGNEDUSERIDS = @ASSIGNEDUSERIDS, @ASSIGNEDTEAMIDS = @ASSIGNEDTEAMIDS, @TODAY = @TODAY

END