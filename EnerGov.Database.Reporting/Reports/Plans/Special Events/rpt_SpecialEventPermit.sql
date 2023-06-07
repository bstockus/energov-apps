CREATE PROCEDURE [dbo].[rpt_SpecialEventPermit]
	@PLPLANID AS char(36)
AS
	SELECT PLPLAN.PLANNUMBER,
       PLPLAN.APPLICATIONDATE,
       PLPLAN.EXPIREDATE,
       PLPLAN.COMPLETEDATE,
       PLPLAN.VALUE,
       PLPLAN.SQUAREFEET,
       PLPLAN.DESCRIPTION,
       PLPLANSTATUS.NAME    AS                         STATUS,
       PLPLANTYPE.PLANNAME  AS                         PLANTYPE,
       DISTRICT.NAME        AS                         DISTRICT,
       PLPLANWORKCLASS.NAME AS                         WORKCLASS,
       PLPLAN.PLPLANID,
       PRPROJECT.NAME       AS                         PROJECT,
       USERS.FNAME,
       USERS.LNAME,
       PLPLAN.APPROVALEXPIREDATE,
       (SELECT cfpli.SVALUE FROM [$(EnerGovDatabase)].[dbo].CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.EventClass) AS EventClass,
       (SELECT cfpli.SVALUE FROM [$(EnerGovDatabase)].[dbo].CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.EventSubClass) AS EventSubClass,
       (SELECT cfpli.SVALUE FROM [$(EnerGovDatabase)].[dbo].CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.EventType) AS EventType,
       cspm.EventDescription AS EventDescription,
       cspm.EventDates AS EventDates,
       cspm.EventStartTime AS EventStartTime,
       cspm.EventEndTime As EventEndTime,
       cspm.EventSetupBegins AS EventSetupBegins,
       cspm.EventTakeDownEnds AS EventTakeDownEnds,
       cspm.TotalAnticipatedAttendance AS TotalAnticipatedAttendance,
       cspm.DailyAnticipatedAttendance AS DailyAnticipatedAttendance,
       cspm.EventAdmissionRequirements AS EventAdmissionRequirements,
       cspm.EventName AS EventName,
       cspm.EventLocationDescription AS EventLocationDescription

FROM [$(EnerGovDatabase)].[dbo].PLPLAN
         INNER JOIN [$(EnerGovDatabase)].[dbo].PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID
         INNER JOIN [$(EnerGovDatabase)].[dbo].PLPLANSTATUS ON PLPLAN.PLPLANSTATUSID = PLPLANSTATUS.PLPLANSTATUSID
         INNER JOIN [$(EnerGovDatabase)].[dbo].PLPLANWORKCLASS ON PLPLAN.PLPLANWORKCLASSID = PLPLANWORKCLASS.PLPLANWORKCLASSID
         LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].DISTRICT ON PLPLAN.DISTRICTID = DISTRICT.DISTRICTID
         LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].USERS ON PLPLAN.ASSIGNEDTO = USERS.SUSERGUID
         LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID
         LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID
         LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].CUSTOMSAVERPLANMANAGEMENT cspm ON cspm.ID = PLPLAN.PLPLANID
WHERE PLPLAN.PLPLANID = @PLPLANID
