SELECT
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '48372894-b4ea-4f0a-a29f-ec3330c9e132' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassALiquorAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '457c5fb7-f169-4ccb-9aff-f8b1f9f35f1b' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassABeerAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '9325dce2-4ccb-4bba-ad96-919a4f4ffaf8' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassBBeerAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'c4449e75-eb0d-427e-8a27-94ca931b2f97' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) -
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '9325dce2-4ccb-4bba-ad96-919a4f4ffaf8' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassBLiquorAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '4333ba1d-ec5b-40fe-8322-a1c218684faa' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassBWineOnlyAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'c598af01-a14f-46d7-88c8-6910e78a0ad1' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ClassCWineAmount,

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'b57d6306-3d78-45d0-8742-8be309858522' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ReserveClassBLiquorAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '24a52712-74c8-46ca-b7b5-e3370e781549' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS PublicationFeeAmount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear