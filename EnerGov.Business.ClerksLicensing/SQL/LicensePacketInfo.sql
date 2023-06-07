SELECT bll.LICENSENUMBER                                  AS LicenseNumber,
       buis.DBA                                           AS DBA,
       buis.REGISTRATIONID                                AS BuisnessNumber,
       ISNULL(glent.CONTACTID, buis.REGISTRATIONID)       AS CompanyNumber,
       ISNULL(glent.GLOBALENTITYNAME, buis.COMPANYNAME)   AS CompanyName,
       bllt.NAME                                          AS LicenseTypeName,
       bllc.NAME                                          AS LicenseClassName,
       bll.ISSUEDDATE                                     AS IssuedDate,
       bll.EXPIRATIONDATE                                 AS ExpirationDate,
       bltci.DisplayName                                  AS DisplayName,
       buis.BLGLOBALENTITYEXTENSIONID                     AS BusinessId,
       bll.BLLICENSEID                                    AS LicenseId
      FROM dbo.BLLICENSE bll
       INNER JOIN dbo.BLLICENSETYPE bllt ON bll.BLLICENSETYPEID = bllt.BLLICENSETYPEID
       INNER JOIN dbo.BLLICENSECLASS bllc ON bll.BLLICENSECLASSID = bllc.BLLICENSECLASSID
       LEFT OUTER JOIN dbo.CUSTOMSAVERLICENSEMANAGEMENT cslm ON bll.BLLICENSEID = cslm.ID
       LEFT OUTER JOIN dbo.CUSTOMSAVERLICENSEMANAGEMENTMS cslmms ON bll.BLLICENSEID = cslmms.ID
       INNER JOIN dbo.BLGLOBALENTITYEXTENSION buis
                  ON bll.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
       LEFT OUTER JOIN dbo.GLOBALENTITY glent ON buis.GLOBALENTITYID = glent.GLOBALENTITYID
       INNER JOIN [laxreports].[BusinessLicenseTypeClassInformation] bltci ON
          bll.BLLICENSETYPEID = bltci.LicenseTypeId AND
          bll.BLLICENSECLASSID = bltci.LicenseClassId AND
          (bltci.UseJunkDealerLogic = 0 OR
           (bltci.UseJunkDealerLogic = 1 AND cslm.JunkDealerLicenseType = bltci.PickListItemId)) AND
          (bltci.UseRecyclingFacilityLicenseSubClass = 0 OR (bltci.UseRecyclingFacilityLicenseSubClass = 1 AND
                                                             cslmms.CUSTOMFIELDPICKLISTITEMID =
                                                             bltci.PickListItemId)) AND
          (bltci.UseSecondhandLicenseLogic = 0 OR
           (bltci.UseSecondhandLicenseLogic = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId))
       WHERE bll.TAXYEAR = @TaxYear
         AND bll.BLLICENSETYPEID IN @LicenseTypeIds
         AND bll.BLLICENSESTATUSID IN @LicenseStatusIds