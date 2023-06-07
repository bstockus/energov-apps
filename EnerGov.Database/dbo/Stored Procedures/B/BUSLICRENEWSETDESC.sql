
CREATE PROCEDURE [dbo].[BUSLICRENEWSETDESC]
-- Add the parameters for the stored procedure here
@BUSINESSLICENSEID char(36)

AS
BEGIN
UPDATE BLLICENSE
SET [DESCRIPTION] = 'Stored proc ran on Business License Renewal' 
where BLLICENSE.BLLICENSEID = @BUSINESSLICENSEID
END