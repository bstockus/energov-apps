SELECT

    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '01c7addf-d088-4ab2-b14c-06c02c2dbc77' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ProcessingFacilityFeeAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'a8be380d-1f34-4ffa-b65a-13b2925550bc' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS RecyclingCenterFeeAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'a06efc0b-86f8-4ff8-989a-21bc3e139616' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS PickUpStationFeeAmount,


    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = 'e1538964-8efb-4938-b736-220b836b9e95' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0)  +
    ISNULL((SELECT
        feeSetup.AMOUNT
    FROM CAFEESETUP feeSetup
        WHERE feeSetup.CAFEEID = '486b2912-21b0-45c6-8103-64c1b78c3792' AND
              feeSetup.CASCHEDULEID = schedule.CASCHEDULEID), 0) AS ReverseVendingMachineFeeAmount

FROM CASCHEDULE schedule
WHERE YEAR(STARTDATE) = @LicenseYear