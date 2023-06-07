﻿CREATE TABLE [dbo].[PMPERMITWFACTIONSTEP] (
    [PMPERMITWFACTIONSTEPID]       CHAR (36)       NOT NULL,
    [PMPERMITWFSTEPID]             CHAR (36)       NOT NULL,
    [WFACTIONTYPEID]               INT             NOT NULL,
    [DESCRIPTION]                  NVARCHAR (MAX)  NULL,
    [PRIORITYORDER]                INT             NOT NULL,
    [STARTDATE]                    DATETIME        NULL,
    [ENDDATE]                      DATETIME        NULL,
    [ROWVERSION]                   INT             NOT NULL,
    [LASTCHANGEDON]                DATETIME        NOT NULL,
    [LASTCHANGEDBY]                CHAR (36)       NOT NULL,
    [WORKFLOWSTATUSID]             INT             NOT NULL,
    [LOCATION]                     NVARCHAR (50)   NULL,
    [EXPECTEDDURATIONHOURS]        DECIMAL (6, 2)  NULL,
    [EVENTDATE]                    DATETIME        NULL,
    [NAME]                         NVARCHAR (100)  NOT NULL,
    [HEARINGTYPEID]                CHAR (36)       NULL,
    [PASSDESCRIPTION]              NVARCHAR (30)   NOT NULL,
    [FAILDESCRIPTION]              NVARCHAR (30)   NOT NULL,
    [ALLOWREDO]                    BIT             NOT NULL,
    [REDODESCRIPTION]              NVARCHAR (30)   NULL,
    [ICON]                         VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]               INT             NULL,
    [MEETINGTYPEID]                CHAR (36)       NULL,
    [PMPERMITWFPARENTACTIONSTEPID] CHAR (36)       NULL,
    [VERSIONNUMBER]                INT             NULL,
    [SORTORDER]                    INT             DEFAULT ((0)) NOT NULL,
    [GENERALREASON]                NVARCHAR (MAX)  NULL,
    [AUTORECEIVE]                  BIT             CONSTRAINT [DF_PMPermitAutoReceive] DEFAULT ((0)) NOT NULL,
    [WORKFLOWCOMPLETETYPEID]       INT             NULL,
    [AUTOCOMPLETED]                BIT             CONSTRAINT [DF_PMPermitWFActionStep_ActionAutoCompleted] DEFAULT ((0)) NOT NULL,
    [IMINSPECTIONTYPEID]           CHAR (36)       NULL,
    [PMPERMITTYPEID]               CHAR (36)       NULL,
    [PMPERMITWORKCLASSID]          CHAR (36)       NULL,
    [PLPLANTYPEID]                 CHAR (36)       NULL,
    [PLPLANWORKCLASSID]            CHAR (36)       NULL,
    [BLLICENSETYPEID]              CHAR (36)       NULL,
    [BLLICENSECLASSID]             CHAR (36)       NULL,
    [PMPERMITACTIVITYTYPEID]       CHAR (36)       NULL,
    [RPTREPORTID]                  CHAR (36)       NULL,
    [PARENTINSPECTIONNUMBER]       NVARCHAR (50)   NULL,
    [TASKTYPEID]                   CHAR (36)       NULL,
    [NOPRIORITY]                   BIT             DEFAULT ((0)) NOT NULL,
    [DUEDATE]                      DATETIME        NULL,
    [IMINSPECTIONCASETYPEID]       CHAR (36)       NULL,
    [CAFEETEMPLATEID]              CHAR (36)       NULL,
    [ISAUTOINVOICE]                BIT             CONSTRAINT [DF_PMPERMITWFACTIONSTEP_ISAUTOINVOICE] DEFAULT ((0)) NOT NULL,
    [ISREQUIREDFULLPAYMNENT]       BIT             CONSTRAINT [DF_PMPERMITWFACTIONSTEP_ISREQUIRED] DEFAULT ((0)) NOT NULL,
    [OMOBJECTTYPEID]               CHAR (36)       NULL,
    [OMOBJECTCLASSIFICATIONID]     CHAR (36)       NULL,
    [COMPUTEFEEACTIONTYPEID]       INT             DEFAULT ((0)) NULL,
    [ISUSEACTIONDATEASFEEDATE]     BIT             DEFAULT ((0)) NOT NULL,
    [ISCOMPUTEMAINFEETEMPLATE]     BIT             DEFAULT ((0)) NOT NULL,
    [INSPECTIONSET]                INT             CONSTRAINT [DF_PMPERMITWFACTIONSTEP_SET] DEFAULT ((0)) NOT NULL,
    [CMCASETYPEID]                 CHAR (36)       NULL,
    [PLSUBMITTALTYPEID]            CHAR (36)       NULL,
    [WKOTYPEID]                    INT             NULL,
    [WKOTYPENAME]                  VARCHAR (255)   NULL,
    [WKOCLASSID]                   INT             NULL,
    [WKOCLASSNAME]                 VARCHAR (255)   NULL,
    [IDENTITYCOLUMN]               BIGINT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PMPermitWFActionStep] PRIMARY KEY NONCLUSTERED ([PMPERMITWFACTIONSTEPID] ASC),
    CONSTRAINT [FK_ActionStep_ActionType] FOREIGN KEY ([WFACTIONTYPEID]) REFERENCES [dbo].[WFACTIONTYPE] ([WFACTIONTYPEID]),
    CONSTRAINT [FK_ActionStep_Parent] FOREIGN KEY ([PMPERMITWFPARENTACTIONSTEPID]) REFERENCES [dbo].[PMPERMITWFACTIONSTEP] ([PMPERMITWFACTIONSTEPID]),
    CONSTRAINT [FK_ActionStep_Step] FOREIGN KEY ([PMPERMITWFSTEPID]) REFERENCES [dbo].[PMPERMITWFSTEP] ([PMPERMITWFSTEPID]),
    CONSTRAINT [FK_ActionStep_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_ActionStep_WorkflowStatus] FOREIGN KEY ([WORKFLOWSTATUSID]) REFERENCES [dbo].[WORKFLOWSTATUS] ([WORKFLOWSTATUSID]),
    CONSTRAINT [FK_PMActionStep_HearingType] FOREIGN KEY ([HEARINGTYPEID]) REFERENCES [dbo].[HEARINGTYPE] ([HEARINGTYPEID]),
    CONSTRAINT [FK_PMActionStep_MeetingType] FOREIGN KEY ([MEETINGTYPEID]) REFERENCES [dbo].[MEETINGTYPE] ([MEETINGTYPEID]),
    CONSTRAINT [FK_PMACTSTEP_CMCASETYPE] FOREIGN KEY ([CMCASETYPEID]) REFERENCES [dbo].[CMCASETYPE] ([CMCASETYPEID]),
    CONSTRAINT [FK_PMPermitActStep_TaskType] FOREIGN KEY ([TASKTYPEID]) REFERENCES [dbo].[TASKTYPE] ([TASKTYPEID]),
    CONSTRAINT [FK_PMPERMITWAS_OMCLASS] FOREIGN KEY ([OMOBJECTCLASSIFICATIONID]) REFERENCES [dbo].[OMOBJECTCLASSIFICATION] ([OMOBJECTCLASSIFICATIONID]),
    CONSTRAINT [FK_PMPERMITWAS_OMOBJECTTYPE] FOREIGN KEY ([OMOBJECTTYPEID]) REFERENCES [dbo].[OMOBJECTTYPE] ([OMOBJECTTYPEID]),
    CONSTRAINT [FK_PMPermitWFActionStep_BLLicenseClass] FOREIGN KEY ([BLLICENSECLASSID]) REFERENCES [dbo].[BLLICENSECLASS] ([BLLICENSECLASSID]),
    CONSTRAINT [FK_PMPermitWFActionStep_BLLicenseType] FOREIGN KEY ([BLLICENSETYPEID]) REFERENCES [dbo].[BLLICENSETYPE] ([BLLICENSETYPEID]),
    CONSTRAINT [FK_PMPERMITWFACTIONSTEP_CAFEETEMPLATE] FOREIGN KEY ([CAFEETEMPLATEID]) REFERENCES [dbo].[CAFEETEMPLATE] ([CAFEETEMPLATEID]),
    CONSTRAINT [FK_PMPERMITWFACTIONSTEP_ICT] FOREIGN KEY ([IMINSPECTIONCASETYPEID]) REFERENCES [dbo].[IMINSPECTIONCASETYPE] ([IMINSPECTIONCASETYPEID]),
    CONSTRAINT [FK_PMPermitWFActionStep_InsT] FOREIGN KEY ([IMINSPECTIONTYPEID]) REFERENCES [dbo].[IMINSPECTIONTYPE] ([IMINSPECTIONTYPEID]),
    CONSTRAINT [FK_PMPermitWFActionStep_PLT] FOREIGN KEY ([PLPLANTYPEID]) REFERENCES [dbo].[PLPLANTYPE] ([PLPLANTYPEID]),
    CONSTRAINT [FK_PMPermitWFActionStep_PLW] FOREIGN KEY ([PLPLANWORKCLASSID]) REFERENCES [dbo].[PLPLANWORKCLASS] ([PLPLANWORKCLASSID]),
    CONSTRAINT [FK_PMPermitWFActionStep_PT] FOREIGN KEY ([PMPERMITTYPEID]) REFERENCES [dbo].[PMPERMITTYPE] ([PMPERMITTYPEID]),
    CONSTRAINT [FK_PMPermitWFActionStep_PWC] FOREIGN KEY ([PMPERMITWORKCLASSID]) REFERENCES [dbo].[PMPERMITWORKCLASS] ([PMPERMITWORKCLASSID]),
    CONSTRAINT [FK_PMPERMITWFACTIONSTEP_SUBTYPE] FOREIGN KEY ([PLSUBMITTALTYPEID]) REFERENCES [dbo].[PLSUBMITTALTYPE] ([PLSUBMITTALTYPEID]),
    CONSTRAINT [FK_PMWFACT_ACTIONTYPEID] FOREIGN KEY ([COMPUTEFEEACTIONTYPEID]) REFERENCES [dbo].[WFACTIONSYSTEMTYPE] ([WFACTIONSYSTEMTYPEID]),
    CONSTRAINT [FK_PMWFActionStep_PMActType] FOREIGN KEY ([PMPERMITACTIVITYTYPEID]) REFERENCES [dbo].[PMPERMITACTIVITYTYPE] ([PMPERMITACTIVITYTYPEID]),
    CONSTRAINT [FK_PMWFActStep_RPTReport] FOREIGN KEY ([RPTREPORTID]) REFERENCES [dbo].[RPTREPORT] ([RPTREPORTID]),
    CONSTRAINT [FK_WFPMPermitWFAct_WFCompleteType] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID])
);


GO
CREATE CLUSTERED INDEX [CLIDX_PMPERMITWFNACTSTEP_IDCOL]
    ON [dbo].[PMPERMITWFACTIONSTEP]([IDENTITYCOLUMN] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PMPERMITWFACTIONSTEP_BLLICENSETYPEID]
    ON [dbo].[PMPERMITWFACTIONSTEP]([BLLICENSETYPEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PMPERMITWFACTIONSTEP_STEPID]
    ON [dbo].[PMPERMITWFACTIONSTEP]([PMPERMITWFSTEPID] ASC)
    INCLUDE([WORKFLOWSTATUSID]);


GO
CREATE NONCLUSTERED INDEX [IX_PMPERMITWFACTIONSTEP_WORKFLOWSTATUSID]
    ON [dbo].[PMPERMITWFACTIONSTEP]([WORKFLOWSTATUSID] ASC)
    INCLUDE([PMPERMITWFACTIONSTEPID], [VERSIONNUMBER]);


GO
CREATE NONCLUSTERED INDEX [PMPERMITWFPARENTACTIONSTEPID_IDX]
    ON [dbo].[PMPERMITWFACTIONSTEP]([PMPERMITWFPARENTACTIONSTEPID] ASC);


GO

CREATE TRIGGER [dbo].[PMO_TRG_AUTO_ISSUE_PERMIT]
   ON  [dbo].[PMPERMITWFACTIONSTEP]
   AFTER UPDATE, INSERT
AS 
BEGIN
	BEGIN TRY
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET NOCOUNT ON;

      DECLARE @endDate DateTime
      DECLARE @actionID char(36)
      DECLARE @permitID char(36)
      DECLARE @actionName nvarchar(100)
      DECLARE @permitStatusName nvarchar(100)
      DECLARE @permitTypeName nvarchar(100)
      DECLARE @workflowStatusID int
	  DECLARE @DaysUntilExpire int

      SELECT @endDate = ENDDATE, @actionID = PMPERMITWFACTIONSTEPID, @actionName = NAME, @workflowStatusID = WORKFLOWSTATUSID
      FROM inserted

	  IF @actionName LIKE '%Issue Permit%' AND @workflowStatusID = 1
      BEGIN

            SELECT @permitID = p.PMPERMITID, @permitStatusName = ps.NAME, @permitTypeName = pt.NAME, @DaysUntilExpire=ptype.DAYSUNTILEXPIRE
            FROM         PMPERMITWFSTEP AS pws INNER JOIN
                      PMPERMITWFACTIONSTEP AS pwas ON pws.PMPERMITWFSTEPID = pwas.PMPERMITWFSTEPID INNER JOIN
                      PMPERMIT AS p ON pws.PMPERMITID = p.PMPERMITID INNER JOIN
                      PMPERMITSTATUS AS ps ON p.PMPERMITSTATUSID = ps.PMPERMITSTATUSID INNER JOIN
                      PMPERMITTYPE AS pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID INNER JOIN
                      PMPERMITTYPE as ptype ON p.PMPERMITTYPEID = ptype.PMPERMITTYPEID
            AND pwas.PMPERMITWFACTIONSTEPID = @actionID 


            IF @permitStatusName NOT IN ('Expired','Finaled', 'Void','Issued','On Hold','Stop Work Order') 
			BEGIN

                  UPDATE PMPERMIT 
				  SET 
				  PMPERMITSTATUSID='f8b6324d-f3b0-4efc-be19-e171ae0410d4',
                  ISSUEDATE = @endDate,
                  EXPIREDATE=(@endDate + @DaysUntilExpire),
				  ROWVERSION = ROWVERSION + 1

                  WHERE PMPERMITID = @permitID

            END


      END

	  END TRY
	  BEGIN CATCH
		 --
		 --
		INSERT into GLOBALERRORDATABASE VALUES (newid(),'PMO_TRG_AUTO_COMPLETE_PLAN_FINAL_DECSION', getdate(), @@ERROR, null)
		 --	
		 --
	  END CATCH

END
GO
DISABLE TRIGGER [dbo].[PMO_TRG_AUTO_ISSUE_PERMIT]
    ON [dbo].[PMPERMITWFACTIONSTEP];
