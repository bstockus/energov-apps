﻿
CREATE PROCEDURE [dbo].[SP_ADDROLERECORDTYPEXREFSONNEWRECORDTYPE]
@MODULERECORDTYPEID int,
@RECORDTYPEID char(36)
AS
BEGIN		
INSERT INTO ROLERECORDTYPEXREF
SELECT COL1, FKROLEID, COL3, COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE
FROM (
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '7877DE83-7CC1-467F-8EC3-8C5367C00C86' AND 1 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '5C4F90D8-1252-45A9-9472-5EAE266DAE40' AND 2 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'FC540FA1-BB85-4831-8D2F-65DF0AFA6F27' AND 3 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '6300503B-620C-4798-8CFF-D22C24D5173B' AND 4 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'E620D52D-8A4A-4B0B-9C4D-B339C9335500' AND 5 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'FC80E8B0-50E7-4EF7-A3C9-2836FA8B1149' AND 6 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '39596BA9-8830-4EAE-96E6-F7D7CE5E5D21' AND 7 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '87407509-3DB4-4F89-8EB2-0802991DD28B' AND 8 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'A806BA00-1521-4968-A099-21D45CAF8FEF' AND 9 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '02614FB1-2415-4850-BFB6-BC2623D5DEC5' AND 10 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'D82974EE-5C3A-40DB-A04E-7A6168E3742E' AND 11 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'C1835173-F108-4A06-A1E9-88F4432DED1D' AND 12 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'D513CAE8-6B72-4C2B-8404-8426432E0789' AND 13 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'A004FBA9-C76E-4867-BABC-AD554EBCE6F1' AND 14 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = 'F4FCAE20-54D2-4AA1-986E-5DA3FF2EB128' AND 15 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '28BACB0B-B036-4D0F-A512-1F560A2AA864' AND 17 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '137D67AD-EEDF-459F-B5E9-3ECA97F43580' AND 23 = @MODULERECORDTYPEID
UNION ALL
SELECT NEWID() COL1, FKROLEID, @MODULERECORDTYPEID COL3, @RECORDTYPEID COL4, BVISIBLE, BALLOWADD, BALLOWUPDATE, BALLOWDELETE FROM ROLEFORMSXREF 
WHERE FKFORMSID = '86115563-9FE6-4D26-BD48-9AE793B6A5DE' AND 30 = @MODULERECORDTYPEID
) TB
JOIN ROLES on ROLES.SROLEGUID = TB.FKROLEID
END