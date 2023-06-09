﻿CREATE VIEW [GISHISTORYVIEW]
AS
SELECT     PMPERMITGISFEATUREID AS GISFEATUREID, ATTRIBUTEFIELD, FEATURELAYER, KEYVALUE, PMPERMITID AS CASEID
FROM        PMPERMITGISFEATURE
UNION ALL
SELECT     PLPLANGISFEATUREID AS GISFEATUREID, ATTRIBUTEFIELD, FEATURELAYER, KEYVALUE, PLPLANID AS CASEID
FROM        PLPLANGISFEATURE
UNION ALL
SELECT     CMCODECASEGISFEATUREID AS GISFEATUREID, ATTRIBUTEFIELD, FEATURELAYER, KEYVALUE, CMCODECASEID AS CASEID
FROM        CMCODECASEGISFEATURE
UNION ALL
SELECT      APPLICATIONGISFEATUREID AS GISFEATUREID, ATTRIBUTEFIELD, FEATURELAYER, KEYVALUE, PLAPPLICATIONID AS CASEID
FROM        PLAPPLICATIONGISFEATURE
UNION ALL
SELECT     OMOBJECTGISFEATUREID AS GISFEATUREID, ATTRIBUTEFIELD, FEATURELAYER, KEYVALUE, OMOBJECTID AS CASEID
FROM        OMOBJECTGISFEATURE
UNION ALL
SELECT     CITIZENREQUESTGISFEATUREID AS GISFEATUREID, ATTRIBUTEFIELD, FEATURELAYER, KEYVALUE, CITIZENREQUESTID AS CASEID
FROM        CITIZENREQUESTGISFEATURE
