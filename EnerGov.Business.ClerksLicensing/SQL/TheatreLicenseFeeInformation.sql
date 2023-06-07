SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'f626bafa-173b-4891-a2e7-58a94a5c67c0' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS TheatreUnder500LicenseFeeAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '8a26f0cd-a2cf-4e1f-b4db-bb47cf9bdbca' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS Theatre500To1000LicenseFeeAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'b89c44da-2b57-4225-8a10-000c767e033c' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS TheatreOver1000LicenseFeeAmount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear