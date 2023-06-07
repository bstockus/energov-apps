﻿CREATE PROCEDURE [dbo].[USP_CACHECLEARQUEUE_INSERT]
(
	@CREATEDDATE DATETIME,
	@CREATEDBYBUSINESSOBJECT NVARCHAR(256),
	@CACHECLEARAREAID INT,
	@ADDITIONALID NVARCHAR(256) = NULL
)
AS
INSERT INTO [dbo].[CACHECLEARQUEUE](
	[CREATEDDATE],
	[CREATEDBYBUSINESSOBJECT],
	[CACHECLEARAREAID],
	[ADDITIONALID]
)
VALUES
(
	@CREATEDDATE,
	@CREATEDBYBUSINESSOBJECT,
	@CACHECLEARAREAID,
	@ADDITIONALID
)