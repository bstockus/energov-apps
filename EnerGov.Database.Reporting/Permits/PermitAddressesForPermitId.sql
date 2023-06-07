CREATE PROCEDURE [dbo].[PermitAddressesForPermitId]
	@PERMITID AS VARCHAR(36)
AS
	SELECT
		ISNULL(STUFF((SELECT CAST(', ' + 
				LTRIM(RTRIM(a.ADDRESSLINE1 + ' '  + 
					LTRIM(RTRIM(ISNULL(a.PREDIRECTION, '') + ' ' +
						LTRIM(RTRIM(ISNULL(a.ADDRESSLINE2, ''))) + ' ' + 
							LTRIM(RTRIM(ISNULL(a.STREETTYPE, '') + ' ' + 
								LTRIM(RTRIM(ISNULL(a.POSTDIRECTION, '') + ' ' + 
									LTRIM(RTRIM(ISNULL(a.UNITORSUITE, '')
								))
							))
						))
					))
				))
				AS NVARCHAR(MAX)) [text()]
			FROM [$(EnerGovDatabase)].dbo.PMPERMITADDRESS pa
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON pa.MAILINGADDRESSID = a.MAILINGADDRESSID
			WHERE pa.PMPERMITID = @PERMITID
			FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "Addresses"
	FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
	WHERE p.PMPERMITID = @PERMITID