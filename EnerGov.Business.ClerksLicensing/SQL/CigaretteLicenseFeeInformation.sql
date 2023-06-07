SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '81f27437-e682-41bb-a57c-1228b450b6a0' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS Amount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear