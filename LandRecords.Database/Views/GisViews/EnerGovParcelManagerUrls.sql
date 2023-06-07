CREATE VIEW [gisviews].[EnerGovParcelManagerUrls]
	AS SELECT
        par.PARCELNUMBER AS ParcelNumber,
        'https://egapp.cityoflacrosse.org/energov_prod/maps/#/parcel/' + par.PARCELID + '/summary' AS ParcelManagerUrl
    FROM [$(OtherServer)].[$(EnerGov_Prod)].[dbo].[PARCEL] par