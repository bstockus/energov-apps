﻿CREATE PROCEDURE [dbo].[USP_CHECK_CMCITATIONATTACHMENTREF_WITH_ATTACHMENTID_AND_CITATIONID]
	@CMCITATIONID as char(36),
	@ATTACHMENTID as char(36)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Exists bit = 0
	DECLARE @NotExists bit = 0
	
	IF (@ATTACHMENTID IS NOT NULL AND 
		@ATTACHMENTID != '' AND 
		@ATTACHMENTID != 'Not Enabled' AND 
		@ATTACHMENTID != 'Not Found')
	BEGIN
		IF (NOT EXISTS (SELECT 1 FROM [dbo].[ATTACHMENT] WITH (NOLOCK) WHERE [ATTACHMENTID] = @ATTACHMENTID))
		BEGIN
			DECLARE @TCMDOCID nvarchar(255) = @ATTACHMENTID
			SET @ATTACHMENTID = NULL
			SELECT TOP 1 @ATTACHMENTID = [ATTACHMENTID] FROM [dbo].[ATTACHMENT] WITH (NOLOCK) WHERE [TCMDOCID] = @TCMDOCID
		END

		IF (@ATTACHMENTID IS NOT NULL)
		BEGIN
			SELECT @Exists = 1
			FROM [dbo].[CMCITATIONATTACHMENTREF] WITH (NOLOCK)
			WHERE [dbo].[CMCITATIONATTACHMENTREF].[CMCITATIONID] = @CMCITATIONID
			AND [dbo].[CMCITATIONATTACHMENTREF].[ATTACHMENTID] = @ATTACHMENTID
		END
	END

	SELECT COALESCE(@Exists, @NotExists)
END