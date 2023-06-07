﻿CREATE FUNCTION [managebusiness].[UFN_GET_BASE_FEE_DETAILS_BYID]
(
   @BLGLOBALENTITYEXTENSIONID CHAR(36)
)
RETURNS TABLE
AS
RETURN SELECT [BLLICENSE].[BLLICENSEID],
              ISNULL(SUM(CACOMPUTEDFEE.COMPUTEDAMOUNT), 0) FEETOTAL,
              ISNULL(SUM(CACOMPUTEDFEE.AMOUNTPAIDTODATE), 0) AMOUNTPAIDTOTAL,
              (ISNULL(SUM(CACOMPUTEDFEE.COMPUTEDAMOUNT), 0) - ISNULL(SUM(CACOMPUTEDFEE.AMOUNTPAIDTODATE), 0)) FEEDUE
       FROM [dbo].[BLLICENSE]
           INNER JOIN [dbo].[BLLICENSEFEE]
               ON [BLLICENSE].[BLLICENSEID] = [BLLICENSEFEE].[BLLICENSEID]
           INNER JOIN [dbo].[CACOMPUTEDFEE]
               ON [BLLICENSEFEE].[CACOMPUTEDFEEID] = [CACOMPUTEDFEE].[CACOMPUTEDFEEID]
                  AND CACOMPUTEDFEE.CASTATUSID NOT IN ( 10, 5 ) -- DELETED & VOID
       WHERE [BLLICENSE].[BLGLOBALENTITYEXTENSIONID] = @BLGLOBALENTITYEXTENSIONID
       GROUP BY [BLLICENSE].[BLLICENSEID];