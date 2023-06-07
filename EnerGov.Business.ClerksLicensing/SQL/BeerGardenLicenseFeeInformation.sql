SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '7006a8f1-7f93-46f8-b47b-daea0fce098a' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassAFeeAmount,

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'fc5179b7-79e2-4820-af16-f19d061dc5b7' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassBFeeAmount,

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '16024e96-bfed-49cf-8b11-54d7f56613be' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassCFeeAmount,

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'b2384287-5c8c-4803-b136-f0e225d9fd5b' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassDFeeAmount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear