﻿CREATE PROCEDURE [managebusiness].[USP_TAGGEDBUSINESSLICENSEFEE_GETBYGLOBALENTITYID]
(
    @BLGLOBALENTITYEXTENSIONID CHAR(36),
    @CURRENTDATE DATETIME
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  [BLLICENSE].[BLLICENSEID],
            [BLLICENSE].LICENSENUMBER,
            BASEFEEDETAILS.[FEETOTAL],
            BASEFEEDETAILS.AMOUNTPAIDTOTAL,
            BASEFEEDETAILS.FEEDUE,
            1 AS BUSINESSLICENSE -- BusinessLicense => 1
    FROM    [dbo].[BLLICENSE]        
            INNER JOIN [managebusiness].[UFN_GET_BASE_FEE_DETAILS_BYID](@BLGLOBALENTITYEXTENSIONID) AS BASEFEEDETAILS
            ON [BLLICENSE].[BLLICENSEID] = BASEFEEDETAILS.[BLLICENSEID]
    WHERE   [BLLICENSE].[BLGLOBALENTITYEXTENSIONID] = @BLGLOBALENTITYEXTENSIONID
            AND [BLLICENSE].[LASTRENEWALDATE] IS NULL
            AND
            (
                [BLLICENSE].[EXPIRATIONDATE] IS NULL
                OR [BLLICENSE].[EXPIRATIONDATE] > @CURRENTDATE
            )
            AND ISNULL((SELECT COUNT(1) FROM BLLICENSE CHILD WHERE CHILD.BLLICENSEPARENTID IS NOT NULL AND CHILD.BLLICENSEPARENTID = BLLICENSE.BLLICENSEID), 0) = 0
            AND [BASEFEEDETAILS].[FEEDUE] > 0
    ORDER BY BLLICENSE.LASTCHANGEDON;

END;