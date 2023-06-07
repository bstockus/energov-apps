CREATE TABLE [dbo].[OFFICEHOURS] (
    [OFFICEHOURSID] CHAR (36) NOT NULL,
    [WORKDAYID]     INT       NOT NULL,
    [OFFICEID]      CHAR (36) NOT NULL,
    [STARTTIME]     DATETIME  NOT NULL,
    [ENDTIME]       DATETIME  NOT NULL,
    [ISWORKINGDAY]  BIT       CONSTRAINT [DF_OFFICEHOURS_ISWORKINGDAY] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_OFFICEHOURS] PRIMARY KEY CLUSTERED ([OFFICEHOURSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OFFICEHOURS_OFFICE] FOREIGN KEY ([OFFICEID]) REFERENCES [dbo].[OFFICE] ([OFFICEID])
);


GO
CREATE NONCLUSTERED INDEX [OFFICEHOURS_IX_OFFICEID]
    ON [dbo].[OFFICEHOURS]([OFFICEID] ASC);


GO
CREATE TRIGGER [TG_OFFICEHOURS_UPDATE] ON OFFICEHOURS
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO [HISTORYSYSTEMSETUP] ([ID],
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
  [RECORDNAME])
    SELECT
      [OFFICE].[OFFICEID],
      [OFFICE].[ROWVERSION],
      GETUTCDATE(),
      [OFFICE].[LASTCHANGEDBY],
      'Start time',
      CONVERT(nvarchar(max), [deleted].[STARTTIME], 121),
      CONVERT(nvarchar(max), [inserted].[STARTTIME], 121),
      'Office (' + [OFFICE].[NAME] + '), Office Working Day (' + DATENAME(dw,[inserted].[WORKDAYID]-1) + ')',
	  'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
	  2,
	  0,
	  DATENAME(dw,[inserted].[WORKDAYID]-1)
    FROM [deleted]
    JOIN [inserted]
      ON [deleted].[OFFICEHOURSID] = [inserted].[OFFICEHOURSID]
    INNER JOIN OFFICE
      ON [OFFICE].[OFFICEID] = [inserted].[OFFICEID]
    WHERE [deleted].[STARTTIME] <> [inserted].[STARTTIME]
    UNION ALL
    SELECT
      [OFFICE].[OFFICEID],
      [OFFICE].[ROWVERSION],
      GETUTCDATE(),
      [OFFICE].[LASTCHANGEDBY],
      'End time', 
      CONVERT(nvarchar(max), [deleted].[ENDTIME], 121),
      CONVERT(nvarchar(max), [inserted].[ENDTIME], 121),
      'Office (' + [OFFICE].[NAME] + '), Office Working Day (' + DATENAME(dw,[inserted].[WORKDAYID]-1) + ')',	  
	  'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
	  2,
	  0,
	 DATENAME(dw,[inserted].[WORKDAYID]-1)
    FROM [deleted]
    JOIN [inserted]
      ON [deleted].[OFFICEHOURSID] = [inserted].[OFFICEHOURSID]
    INNER JOIN OFFICE
      ON [OFFICE].[OFFICEID] = [inserted].[OFFICEID]
    WHERE [deleted].[ENDTIME] <> [inserted].[ENDTIME]
    UNION ALL
    SELECT
      [OFFICE].[OFFICEID],
      [OFFICE].[ROWVERSION],
      GETUTCDATE(),
      [OFFICE].[LASTCHANGEDBY],
      'Is Working day',
	  CASE WHEN CAST([deleted].[ISWORKINGDAY] AS BIT) = 1 THEN 'Yes' ELSE 'No' END,
	  CASE WHEN CAST([inserted].[ISWORKINGDAY] AS BIT) = 1 THEN 'Yes' ELSE 'No' END,
      'Office (' + [OFFICE].[NAME] + '), Office Working Day (' + DATENAME(dw,[inserted].[WORKDAYID]-1) + ')',
	  'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
	  2,
	  0,
	  DATENAME(dw,[inserted].[WORKDAYID]-1)
    FROM [deleted]
    JOIN [inserted]
      ON [deleted].[OFFICEHOURSID] = [inserted].[OFFICEHOURSID]
    INNER JOIN OFFICE
      ON [OFFICE].[OFFICEID] = [inserted].[OFFICEID]
    WHERE [deleted].[ISWORKINGDAY] <> [inserted].[ISWORKINGDAY]
END