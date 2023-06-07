

CREATE PROCEDURE [dbo].[GIS_PermitSearch]
	-- Add the parameters for the stored procedure here
	@SearchText varchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IsAboutText varchar(300)
	
	SET @IsAboutText = 'ISABOUT(' + @SearchText + ')'
	
	
	SELECT top 100 B.* FROM CONTAINSTABLE(PMPermit, *, @IsAboutText) AS A INNER JOIN PMPermit AS B ON A.[KEY] = B.PMPermitID
	UNION
	SELECT top 100 D.* FROM CONTAINSTABLE(MailingAddress, *, @IsAboutText) AS A INNER JOIN MailingAddress AS B ON A.[KEY] = B.MailingAddressID 
		INNER JOIN PMPermitAddress AS C ON B.MailingAddressID = C.MailingAddressID
		INNER JOIN PMPermit AS D ON C.PMPermitID = D.PMPermitID
	UNION
	SELECT top 100 D.* FROM CONTAINSTABLE(GlobalEntity, *, @IsAboutText) AS A INNER JOIN GlobalEntity AS B ON A.[KEY] = B.GlobalEntityID 
		INNER JOIN PMPermitContact AS C ON B.GlobalEntityID = C.GlobalEntityID
		INNER JOIN PMPermit AS D ON C.PMPermitID = D.PMPermitID
	
END


