SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '18845cb0-6eae-4abe-8d41-08d396d603cf' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS LicenseFeeAmount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear