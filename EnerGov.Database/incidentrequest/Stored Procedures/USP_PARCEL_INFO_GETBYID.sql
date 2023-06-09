﻿CREATE PROCEDURE [incidentrequest].[USP_PARCEL_INFO_GETBYID]
(
	@PARCELID CHAR(36)
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1 [PARCELID], [PARCELNUMBER]
	FROM (

	SELECT 
		[PARCEL].[PARCELID],
		[PARCEL].[PARCELNUMBER]
	FROM [dbo].[PARCEL]
	WHERE [PARCEL].[PARCELID] = @PARCELID

	UNION ALL
	
	SELECT 
		[PARCEL].[PARCELID],
		[PARCEL].[PARCELNUMBER]
	FROM [PARCELADDRESS]
	JOIN [PARCEL] ON [PARCELADDRESS].[PARCELID] = [PARCEL].[PARCELID]
	WHERE [PARCELADDRESS].[ADDRESSID] = @PARCELID

	) TEMP_TABLE

END