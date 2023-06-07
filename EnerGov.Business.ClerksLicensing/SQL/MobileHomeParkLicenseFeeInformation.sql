SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'bcbc864c-554f-4b03-9c81-5eece9be542c' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS LicenseFeeAmount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear