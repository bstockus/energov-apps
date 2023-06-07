
CREATE PROCEDURE [GISVALIDATION_VIEWERPINVALUES]
AS
  BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET NOCOUNT ON;

      -- Insert statements for procedure here
      SELECT GISMAP.SMAPNAME,
             GISMAP.SPINFIELD,
             GISMAP.SADDRESSIDFIELD,
			 CASE
               WHEN GISLLDATASOURCE.ISADDRESSLAYER = 1
			   THEN GISMAP.SADDRESSIDFIELD
			   WHEN GISLLDATASOURCE.ISPARCELLAYER = 1
			   THEN GISMAP.SPINFIELD
             END AS [Key Field],
             GISLLMAPPING.COLUMNORPARAMETER,
             GISLLDATASOURCE.ARCGISLAYER,
             CASE
               WHEN GISLLDATASOURCE.ISADDRESSLAYER = 1
                    AND CHARINDEX(GISMAP.SADDRESSIDFIELD,
                        GISLLMAPPING.COLUMNORPARAMETER) > 0
             THEN 'Address ID Matches Live Link'
               WHEN GISLLDATASOURCE.ISADDRESSLAYER = 1
                    AND CHARINDEX(GISMAP.SADDRESSIDFIELD,
                        GISLLMAPPING.COLUMNORPARAMETER) <=
                        0 THEN 'Address ID Does Not Match Live Link'
               WHEN GISLLDATASOURCE.ISPARCELLAYER = 1
                    AND CHARINDEX(GISMAP.SPINFIELD,
                        GISLLMAPPING.COLUMNORPARAMETER) >
                        0 THEN
               'Parcel ID Matches Live Link'
               WHEN GISLLDATASOURCE.ISPARCELLAYER = 1
                    AND CHARINDEX(GISMAP.SPINFIELD,
                        GISLLMAPPING.COLUMNORPARAMETER) <=
                        0 THEN
               'Parcel ID Does Not Match Live Link'
               ELSE ''
             END AS [Live Link Match]
      FROM   GISLLMAPPING
             INNER JOIN GISLLDATASOURCE
                     ON GISLLMAPPING.GISLLDATASOURCE =
                        GISLLDATASOURCE.GISLLDATASOURCEID
             CROSS JOIN GISMAP
      WHERE  ( GISLLMAPPING.ISIDENTIFIER = 1 )
	  ORDER BY 1,2;
  END  
