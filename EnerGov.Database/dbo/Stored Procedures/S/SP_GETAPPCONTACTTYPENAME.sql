﻿

CREATE PROCEDURE [dbo].[SP_GETAPPCONTACTTYPENAME]
@PLPLANCONTACTTYPEID as varchar(36)
AS

SELECT TOP 1 NAME
FROM ( SELECT CONTACTTYPEID, NAME FROM CONTACTTYPE
       UNION ALL
       SELECT LANDMANAGEMENTCONTACTTYPEID, NAME FROM LANDMANAGEMENTCONTACTTYPE
       UNION ALL
       SELECT CMCODECASECONTACTTYPEID, NAME FROM CMCODECASECONTACTTYPE
       UNION ALL
       SELECT BLCONTACTTYPEID, NAME FROM BLCONTACTTYPE
       UNION ALL
       SELECT RPCONTACTTYPEID, NAME FROM RPCONTACTTYPE
     ) TB 
WHERE CONTACTTYPEID = @PLPLANCONTACTTYPEID

