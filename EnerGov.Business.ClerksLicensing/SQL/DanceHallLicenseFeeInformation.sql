SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '4af65756-18cc-4017-9ece-5a8b16159698' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS Amount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear