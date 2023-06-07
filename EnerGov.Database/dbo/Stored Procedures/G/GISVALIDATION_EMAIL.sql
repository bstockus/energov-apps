
CREATE PROCEDURE [GISVALIDATION_EMAIL] @body NVARCHAR(MAX)
AS
  BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      BEGIN
          DECLARE @email_From NVARCHAR(80)
          DECLARE @subject NVARCHAR(MAX)

          SET @subject = 'EnerGov GIS Report'

          INSERT INTO EMAILQUEUE
                      (ID,
                       EMAILFROM,
                       EMAILTO,
                       SUBJECT,
                       BODY,
                       BCC,
                       ISHTML)
          VALUES      (NEWID(),
                       'noreply@tylertech.com',
                       'email.recipient@tylertech.com',
                       @subject,
                       @body,
                       'energov_notifications@tylertech.com',
                       1)
      END
  END
