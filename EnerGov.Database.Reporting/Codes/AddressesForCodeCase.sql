CREATE PROCEDURE [dbo].[AddressesForCodeCase]
	@CODECASEID AS VARCHAR(36)
AS

WITH Addresses AS (
    SELECT
            p.PARCELNUMBER AS ParcelNumber,
            pa.CMCODECASEID AS CodeCaseId,
            LTRIM(RTRIM(
                LTRIM(RTRIM(a.ADDRESSLINE1)) + ' ' +
                IIF(LEN(a.PREDIRECTION) > 0, LTRIM(RTRIM(a.PREDIRECTION)) + ' ', '') +
                LTRIM(RTRIM(a.ADDRESSLINE2)) + ' ' +
                LTRIM(RTRIM(a.STREETTYPE)) + ' ' +
                IIF(LEN(a.POSTDIRECTION) > 0, LTRIM(RTRIM(a.POSTDIRECTION)) + ' ', '') +
                IIF(LEN(a.UNITORSUITE) > 0, LTRIM(RTRIM(a.UNITORSUITE)) + ' ', ''))) AS Address
        FROM [$(EnerGovDatabase)].dbo.CMCODECASEADDRESS pa
        LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON pa.MAILINGADDRESSID = a.MAILINGADDRESSID
        LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CMCODECASEPARCEL ccp ON ccp.CMCODECASEID = pa.CMCODECASEID AND ccp.[PRIMARY] = 1
        LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PARCEL p ON ccp.PARCELID = p.PARCELID
        WHERE pa.CMCODECASEID = @CODECASEID)
SELECT
    addr.ParcelNumber AS ParcelNumber,
    STUFF((
        SELECT '; ' + x.Address
            FROM Addresses x
            WHERE x.ParcelNumber = addr.ParcelNumber
            FOR XML PATH(''))
        , 1, LEN(';'), '') AS Addresses
FROM Addresses addr
GROUP BY addr.CodeCaseId, addr.ParcelNumber;