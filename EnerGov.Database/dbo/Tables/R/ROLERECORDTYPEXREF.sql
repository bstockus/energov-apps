﻿CREATE TABLE [dbo].[ROLERECORDTYPEXREF] (
    [ROLERECORDTYPEXREFID] CHAR (36) NOT NULL,
    [ROLEID]               CHAR (36) NOT NULL,
    [MODULERECORDTYPEID]   INT       NOT NULL,
    [RECORDTYPEID]         CHAR (36) NOT NULL,
    [VISIBLE]              BIT       NOT NULL,
    [ALLOWADD]             BIT       NOT NULL,
    [ALLOWUPDATE]          BIT       NOT NULL,
    [ALLOWDELETE]          BIT       NOT NULL,
    CONSTRAINT [PK_ROLERECORDTYPEXREF] PRIMARY KEY CLUSTERED ([ROLERECORDTYPEXREFID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_RRTX_MRT] FOREIGN KEY ([MODULERECORDTYPEID]) REFERENCES [dbo].[MODULERECORDTYPE] ([MODULERECORDTYPEID]),
    CONSTRAINT [FK_RRTX_ROLES] FOREIGN KEY ([ROLEID]) REFERENCES [dbo].[ROLES] ([SROLEGUID])
);


GO
CREATE NONCLUSTERED INDEX [ROLERECORDTYPEXREF_IX_QUERY]
    ON [dbo].[ROLERECORDTYPEXREF]([RECORDTYPEID] ASC, [ROLEID] ASC, [VISIBLE] ASC, [ROLERECORDTYPEXREFID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NCIDX_ROLERECORDTYPEXREF_RECORDTYPEID_VISIBLE_INCL]
    ON [dbo].[ROLERECORDTYPEXREF]([RECORDTYPEID] ASC, [VISIBLE] ASC)
    INCLUDE([ROLEID]) WITH (FILLFACTOR = 90, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [IX_ROLERECORDTYPEXREF_ALL]
    ON [dbo].[ROLERECORDTYPEXREF]([ROLEID] ASC)
    INCLUDE([ROLERECORDTYPEXREFID], [MODULERECORDTYPEID], [RECORDTYPEID], [VISIBLE], [ALLOWADD], [ALLOWUPDATE], [ALLOWDELETE]);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UNIQUE_ROLERECORDTYPEXREF]
    ON [dbo].[ROLERECORDTYPEXREF]([ROLEID] ASC, [RECORDTYPEID] ASC);


GO

CREATE TRIGGER [dbo].[TG_ROLERECORDTYPEXREF_UPDATE] ON  [dbo].[ROLERECORDTYPEXREF]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;
			
	INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )
	
	SELECT 
			[ROLES].[SROLEGUID]
			,[ROLES].[ROWVERSION]
			,GETUTCDATE()
			,[ROLES].[LASTCHANGEDBY]
			,'Visible Flag'
			,CASE [deleted].[VISIBLE] WHEN 1 THEN 'Yes' ELSE 'No' END
			,CASE [inserted].[VISIBLE] WHEN 1 THEN 'Yes' ELSE 'No' END
			,'User Role (' + [ROLES].[ID] + '), Record Type (' + [MODULERECORDTYPE].[NAME] + ')'	
			,'801F270F-912F-420A-91D6-82EBC3F351F3'
			,2
			,0
			,CASE WHEN [inserted].[MODULERECORDTYPEID] = 1 THEN (SELECT NAME FROM PMPERMITTYPE WHERE PMPERMITTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 2 THEN (SELECT PLANNAME FROM PLPLANTYPE WHERE PLPLANTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 3 THEN (SELECT APPLICATIONTYPENAME FROM PLAPPLICATIONTYPE WHERE PLAPPLICATIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 4 THEN (SELECT NAME FROM IMINSPECTIONTYPE WHERE IMINSPECTIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 5 THEN (SELECT NAME FROM PRPROJECTTYPE WHERE PRPROJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 6 THEN (SELECT NAME FROM CITIZENREQUESTTYPE WHERE CITIZENREQUESTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 7 THEN (SELECT NAME FROM CMCASETYPE WHERE CMCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 8 THEN (SELECT NAME FROM BLLICENSETYPE WHERE BLLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 9 THEN (SELECT NAME FROM AMASSETCLASS WHERE AMASSETCLASSID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 10 THEN (SELECT NAME FROM AMWORKORDERTYPE WHERE AMWORKORDERTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 11 THEN (SELECT NAME FROM ILLICENSETYPE WHERE ILLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 12 THEN (SELECT NAME FROM IMINSPECTIONCASETYPE WHERE IMINSPECTIONCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 13 THEN (SELECT NAME FROM TXREMITTANCETYPE WHERE TXREMITTANCETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 14 THEN (SELECT NAME FROM RPLANDLORDLICENSETYPE WHERE RPLANDLORDLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 15 THEN (SELECT NAME FROM RPPROPERTYTYPE WHERE RPPROPERTYTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 17 THEN (SELECT NAME FROM IPCASETYPE WHERE IPCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 23 THEN (SELECT NAME FROM OMOBJECTTYPE WHERE OMOBJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 30 THEN (SELECT NAME FROM PMRENEWALCASETYPE WHERE PMRENEWALCASETYPEID = [inserted].[RECORDTYPEID])
			 END
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ROLEID] = [inserted].[ROLEID]			
			JOIN [ROLES] ON [inserted].[ROLEID] = [ROLES].[SROLEGUID]
			JOIN [MODULERECORDTYPE] ON [inserted].[MODULERECORDTYPEID] = [MODULERECORDTYPE].[MODULERECORDTYPEID]
	WHERE	[deleted].[VISIBLE] <> [inserted].[VISIBLE]
	UNION ALL
	
	SELECT 
			[ROLES].[SROLEGUID]
			,[ROLES].[ROWVERSION]
			,GETUTCDATE()
			,[ROLES].[LASTCHANGEDBY]
			,'Allow Add Flag'
			,CASE [deleted].[ALLOWADD] WHEN 1 THEN 'Yes' ELSE 'No' END
			,CASE [inserted].[ALLOWADD] WHEN 1 THEN 'Yes' ELSE 'No' END
			,'User Role (' + [ROLES].[ID] + '), Record Type (' + [MODULERECORDTYPE].[NAME] + ')'		
			,'801F270F-912F-420A-91D6-82EBC3F351F3'
			,2
			,0
			,CASE WHEN [inserted].[MODULERECORDTYPEID] = 1 THEN (SELECT NAME FROM PMPERMITTYPE WHERE PMPERMITTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 2 THEN (SELECT PLANNAME FROM PLPLANTYPE WHERE PLPLANTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 3 THEN (SELECT APPLICATIONTYPENAME FROM PLAPPLICATIONTYPE WHERE PLAPPLICATIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 4 THEN (SELECT NAME FROM IMINSPECTIONTYPE WHERE IMINSPECTIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 5 THEN (SELECT NAME FROM PRPROJECTTYPE WHERE PRPROJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 6 THEN (SELECT NAME FROM CITIZENREQUESTTYPE WHERE CITIZENREQUESTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 7 THEN (SELECT NAME FROM CMCASETYPE WHERE CMCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 8 THEN (SELECT NAME FROM BLLICENSETYPE WHERE BLLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 9 THEN (SELECT NAME FROM AMASSETCLASS WHERE AMASSETCLASSID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 10 THEN (SELECT NAME FROM AMWORKORDERTYPE WHERE AMWORKORDERTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 11 THEN (SELECT NAME FROM ILLICENSETYPE WHERE ILLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 12 THEN (SELECT NAME FROM IMINSPECTIONCASETYPE WHERE IMINSPECTIONCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 13 THEN (SELECT NAME FROM TXREMITTANCETYPE WHERE TXREMITTANCETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 14 THEN (SELECT NAME FROM RPLANDLORDLICENSETYPE WHERE RPLANDLORDLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 15 THEN (SELECT NAME FROM RPPROPERTYTYPE WHERE RPPROPERTYTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 17 THEN (SELECT NAME FROM IPCASETYPE WHERE IPCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 23 THEN (SELECT NAME FROM OMOBJECTTYPE WHERE OMOBJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 30 THEN (SELECT NAME FROM PMRENEWALCASETYPE WHERE PMRENEWALCASETYPEID = [inserted].[RECORDTYPEID])
			 END
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ROLEID] = [inserted].[ROLEID]			
			JOIN [ROLES] ON [inserted].[ROLEID] = [ROLES].[SROLEGUID]
			JOIN [MODULERECORDTYPE] ON [inserted].[MODULERECORDTYPEID] = [MODULERECORDTYPE].[MODULERECORDTYPEID]
	WHERE	[deleted].[ALLOWADD] <> [inserted].[ALLOWADD]	
	UNION ALL

	SELECT 
			[ROLES].[SROLEGUID]
			,[ROLES].[ROWVERSION]
			,GETUTCDATE()
			,[ROLES].[LASTCHANGEDBY]
			,'Allow Update Flag'
			,CASE [deleted].[ALLOWUPDATE] WHEN 1 THEN 'Yes' ELSE 'No' END
			,CASE [inserted].[ALLOWUPDATE] WHEN 1 THEN 'Yes' ELSE 'No' END
			,'User Role (' + [ROLES].[ID] + '), Record Type (' + [MODULERECORDTYPE].[NAME] + ')'			
			,'801F270F-912F-420A-91D6-82EBC3F351F3'
			,2
			,0
			,CASE WHEN [inserted].[MODULERECORDTYPEID] = 1 THEN (SELECT NAME FROM PMPERMITTYPE WHERE PMPERMITTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 2 THEN (SELECT PLANNAME FROM PLPLANTYPE WHERE PLPLANTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 3 THEN (SELECT APPLICATIONTYPENAME FROM PLAPPLICATIONTYPE WHERE PLAPPLICATIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 4 THEN (SELECT NAME FROM IMINSPECTIONTYPE WHERE IMINSPECTIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 5 THEN (SELECT NAME FROM PRPROJECTTYPE WHERE PRPROJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 6 THEN (SELECT NAME FROM CITIZENREQUESTTYPE WHERE CITIZENREQUESTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 7 THEN (SELECT NAME FROM CMCASETYPE WHERE CMCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 8 THEN (SELECT NAME FROM BLLICENSETYPE WHERE BLLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 9 THEN (SELECT NAME FROM AMASSETCLASS WHERE AMASSETCLASSID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 10 THEN (SELECT NAME FROM AMWORKORDERTYPE WHERE AMWORKORDERTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 11 THEN (SELECT NAME FROM ILLICENSETYPE WHERE ILLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 12 THEN (SELECT NAME FROM IMINSPECTIONCASETYPE WHERE IMINSPECTIONCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 13 THEN (SELECT NAME FROM TXREMITTANCETYPE WHERE TXREMITTANCETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 14 THEN (SELECT NAME FROM RPLANDLORDLICENSETYPE WHERE RPLANDLORDLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 15 THEN (SELECT NAME FROM RPPROPERTYTYPE WHERE RPPROPERTYTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 17 THEN (SELECT NAME FROM IPCASETYPE WHERE IPCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 23 THEN (SELECT NAME FROM OMOBJECTTYPE WHERE OMOBJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 30 THEN (SELECT NAME FROM PMRENEWALCASETYPE WHERE PMRENEWALCASETYPEID = [inserted].[RECORDTYPEID])
			 END
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ROLEID] = [inserted].[ROLEID]			
			JOIN [ROLES] ON [inserted].[ROLEID] = [ROLES].[SROLEGUID]
			JOIN [MODULERECORDTYPE] ON [inserted].[MODULERECORDTYPEID] = [MODULERECORDTYPE].[MODULERECORDTYPEID]
	WHERE	[deleted].[ALLOWUPDATE] <> [inserted].[ALLOWUPDATE]	
	UNION ALL

	SELECT 
			[ROLES].[SROLEGUID]
			,[ROLES].[ROWVERSION]
			,GETUTCDATE()
			,[ROLES].[LASTCHANGEDBY]
			,'Allow Delete Flag'
			,CASE [deleted].[ALLOWDELETE] WHEN 1 THEN 'Yes' ELSE 'No' END
			,CASE [inserted].[ALLOWDELETE] WHEN 1 THEN 'Yes' ELSE 'No' END
			,'User Role (' + [ROLES].[ID] + '), Record Type (' + [MODULERECORDTYPE].[NAME] + ')'	
			,'801F270F-912F-420A-91D6-82EBC3F351F3'
			,2
			,0
			,CASE WHEN [inserted].[MODULERECORDTYPEID] = 1 THEN (SELECT NAME FROM PMPERMITTYPE WHERE PMPERMITTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 2 THEN (SELECT PLANNAME FROM PLPLANTYPE WHERE PLPLANTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 3 THEN (SELECT APPLICATIONTYPENAME FROM PLAPPLICATIONTYPE WHERE PLAPPLICATIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 4 THEN (SELECT NAME FROM IMINSPECTIONTYPE WHERE IMINSPECTIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 5 THEN (SELECT NAME FROM PRPROJECTTYPE WHERE PRPROJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 6 THEN (SELECT NAME FROM CITIZENREQUESTTYPE WHERE CITIZENREQUESTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 7 THEN (SELECT NAME FROM CMCASETYPE WHERE CMCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 8 THEN (SELECT NAME FROM BLLICENSETYPE WHERE BLLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 9 THEN (SELECT NAME FROM AMASSETCLASS WHERE AMASSETCLASSID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 10 THEN (SELECT NAME FROM AMWORKORDERTYPE WHERE AMWORKORDERTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 11 THEN (SELECT NAME FROM ILLICENSETYPE WHERE ILLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 12 THEN (SELECT NAME FROM IMINSPECTIONCASETYPE WHERE IMINSPECTIONCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 13 THEN (SELECT NAME FROM TXREMITTANCETYPE WHERE TXREMITTANCETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 14 THEN (SELECT NAME FROM RPLANDLORDLICENSETYPE WHERE RPLANDLORDLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 15 THEN (SELECT NAME FROM RPPROPERTYTYPE WHERE RPPROPERTYTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 17 THEN (SELECT NAME FROM IPCASETYPE WHERE IPCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 23 THEN (SELECT NAME FROM OMOBJECTTYPE WHERE OMOBJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 30 THEN (SELECT NAME FROM PMRENEWALCASETYPE WHERE PMRENEWALCASETYPEID = [inserted].[RECORDTYPEID])
			 END
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ROLEID] = [inserted].[ROLEID]			
			JOIN [ROLES] ON [inserted].[ROLEID] = [ROLES].[SROLEGUID]
			JOIN [MODULERECORDTYPE] ON [inserted].[MODULERECORDTYPEID] = [MODULERECORDTYPE].[MODULERECORDTYPEID]
	WHERE	[deleted].[ALLOWDELETE] <> [inserted].[ALLOWDELETE]	

END
GO

CREATE TRIGGER [TG_ROLERECORDTYPEXREF_INSERT] ON [ROLERECORDTYPEXREF]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO [HISTORYSYSTEMSETUP]
	(
		[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
	)
	SELECT 
			[ROLES].[SROLEGUID],
			[ROLES].[ROWVERSION],
			GETUTCDATE(),
			[ROLES].[LASTCHANGEDBY],
			'User Role - Record Type Added',
			'',
			'',
			'User Role (' + [ROLES].[ID] + '), Record Type (' + [MODULERECORDTYPE].[NAME] + ')',
			'801F270F-912F-420A-91D6-82EBC3F351F3',
			1,
			0,
			CASE  WHEN [inserted].[MODULERECORDTYPEID] = 1 THEN (SELECT NAME FROM PMPERMITTYPE WHERE PMPERMITTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 2 THEN (SELECT PLANNAME FROM PLPLANTYPE WHERE PLPLANTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 3 THEN (SELECT APPLICATIONTYPENAME FROM PLAPPLICATIONTYPE WHERE PLAPPLICATIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 4 THEN (SELECT NAME FROM IMINSPECTIONTYPE WHERE IMINSPECTIONTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 5 THEN (SELECT NAME FROM PRPROJECTTYPE WHERE PRPROJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 6 THEN (SELECT NAME FROM CITIZENREQUESTTYPE WHERE CITIZENREQUESTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 7 THEN (SELECT NAME FROM CMCASETYPE WHERE CMCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 8 THEN (SELECT NAME FROM BLLICENSETYPE WHERE BLLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 9 THEN (SELECT NAME FROM AMASSETCLASS WHERE AMASSETCLASSID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 10 THEN (SELECT NAME FROM AMWORKORDERTYPE WHERE AMWORKORDERTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 11 THEN (SELECT NAME FROM ILLICENSETYPE WHERE ILLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 12 THEN (SELECT NAME FROM IMINSPECTIONCASETYPE WHERE IMINSPECTIONCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 13 THEN (SELECT NAME FROM TXREMITTANCETYPE WHERE TXREMITTANCETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 14 THEN (SELECT NAME FROM RPLANDLORDLICENSETYPE WHERE RPLANDLORDLICENSETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 15 THEN (SELECT NAME FROM RPPROPERTYTYPE WHERE RPPROPERTYTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 17 THEN (SELECT NAME FROM IPCASETYPE WHERE IPCASETYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 23 THEN (SELECT NAME FROM OMOBJECTTYPE WHERE OMOBJECTTYPEID = [inserted].[RECORDTYPEID])
				  WHEN [inserted].[MODULERECORDTYPEID] = 30 THEN (SELECT NAME FROM PMRENEWALCASETYPE WHERE PMRENEWALCASETYPEID = [inserted].[RECORDTYPEID])
			 END
	FROM	[inserted]
	INNER JOIN [ROLES] ON [inserted].[ROLEID] = [ROLES].[SROLEGUID]
	INNER JOIN [MODULERECORDTYPE] ON [inserted].[MODULERECORDTYPEID] = [MODULERECORDTYPE].[MODULERECORDTYPEID]
END