SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'cc13235a-b677-4a35-8850-a3d302b0b362' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS IndoorCabaretAmount,

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '33c002eb-ffa3-4933-919a-2db03a3869ed' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS OutdoorCabaretAmount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear