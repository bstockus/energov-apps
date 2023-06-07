﻿CREATE TABLE [dbo].[IMINSPECTIONCALAMPM] (
    [IMINSPECTIONCALAMPMID]  CHAR (36) NOT NULL,
    [AMPMTIMEID]             INT       NOT NULL,
    [STARTTIME]              DATETIME  NULL,
    [ENDTIME]                DATETIME  NULL,
    [IMINSPECTIONCALENDARID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_IMINSPECTIONCALAMPM] PRIMARY KEY CLUSTERED ([IMINSPECTIONCALAMPMID] ASC),
    CONSTRAINT [FK_IMINSPECTIONCALAMPM_IMINSPECTIONCALENDAR] FOREIGN KEY ([IMINSPECTIONCALENDARID]) REFERENCES [dbo].[IMINSPECTIONCALENDAR] ([IMINSPECTIONCALENDARID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTIONCALAMPM_IX_IMINSPECTIONCALENDARID]
    ON [dbo].[IMINSPECTIONCALAMPM]([IMINSPECTIONCALENDARID] ASC);


GO

CREATE TRIGGER [dbo].[TG_IMINSPECTIONCALAMPM_UPDATE] ON  [dbo].[IMINSPECTIONCALAMPM]
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
      [IMINSPECTIONCALENDAR].[IMINSPECTIONCALENDARID],
      [IMINSPECTIONCALENDAR].[ROWVERSION],
      GETUTCDATE(),
      [IMINSPECTIONCALENDAR].[LASTCHANGEDBY],
      CASE
        WHEN [inserted].[AMPMTIMEID] = 1 THEN 'A.M.'
        WHEN [inserted].[AMPMTIMEID] = 2 THEN 'P.M.'
      END + ' Start time',
      ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[STARTTIME], 121),'[none]'),
      ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[STARTTIME], 121),'[none]'),
      'Inspection Calendar (' + [IMINSPECTIONCALENDAR].[NAME] + ')',
	  '540881BC-B7EC-4CAB-958C-D1820B6FEBAC',
	   2,
	   0,
	   [IMINSPECTIONCALENDAR].[NAME]
    FROM [deleted]
    JOIN [inserted]
      ON [deleted].[IMINSPECTIONCALAMPMID] = [inserted].[IMINSPECTIONCALAMPMID]
    INNER JOIN [IMINSPECTIONCALENDAR]
      ON [IMINSPECTIONCALENDAR].[IMINSPECTIONCALENDARID] = [inserted].[IMINSPECTIONCALENDARID]
    WHERE ISNULL([deleted].[STARTTIME], '') <> ISNULL([inserted].[STARTTIME], '')
    UNION ALL
	 SELECT
      [IMINSPECTIONCALENDAR].[IMINSPECTIONCALENDARID],
      [IMINSPECTIONCALENDAR].[ROWVERSION],
      GETUTCDATE(),
		[IMINSPECTIONCALENDAR].[LASTCHANGEDBY],
      CASE
        WHEN [inserted].[AMPMTIMEID] = 1 THEN 'A.M.'
        WHEN [inserted].[AMPMTIMEID] = 2 THEN 'P.M.'
      END +' End time',
     ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[ENDTIME], 121),'[none]'),
      ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[ENDTIME], 121),'[none]'),
       'Inspection Calendar (' + [IMINSPECTIONCALENDAR].[NAME] + ')',
	   '540881BC-B7EC-4CAB-958C-D1820B6FEBAC',
	   2,
	   0,
	   [IMINSPECTIONCALENDAR].[NAME]
    FROM [deleted]
    JOIN [inserted]
      ON [deleted].[IMINSPECTIONCALAMPMID] = [inserted].[IMINSPECTIONCALAMPMID]
    INNER JOIN [IMINSPECTIONCALENDAR]
      ON [IMINSPECTIONCALENDAR].[IMINSPECTIONCALENDARID] = [inserted].[IMINSPECTIONCALENDARID]
    WHERE ISNULL([deleted].[ENDTIME], '') <> ISNULL([inserted].[ENDTIME], '')    
END