CREATE PROCEDURE [dbo].[PermitParcelsForPermitId]
	@PERMITID AS VARCHAR(36)
AS

	SELECT
		pp.MAIN AS "PermitParcelIsMain",
		p.PARCELNUMBER AS "PermitParcelNumber",
		ISNULL(p.LEGALDESCRIPTION, '') AS "ParcelLegalDescription"
	FROM [$(EnerGovDatabase)].dbo.PMPERMITPARCEL pp
	INNER JOIN [$(EnerGovDatabase)].dbo.PARCEL p ON pp.PARCELID = p.PARCELID
	WHERE pp.PMPERMITID = @PERMITID