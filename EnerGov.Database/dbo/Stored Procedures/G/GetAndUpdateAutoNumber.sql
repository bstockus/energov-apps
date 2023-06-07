
-- =============================================
-- Author:		EnerGov Solutions
-- Create date: 12/28/11
-- =============================================
CREATE PROCEDURE [dbo].[GetAndUpdateAutoNumber]
	-- Add the parameters for the stored procedure here
	@ClassName varchar(500)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @NewValue TABLE
		(
			[CLASSNAME] [nvarchar](250) NOT NULL,
			[FORMATSTRING] [nvarchar](50) NOT NULL,
			[PADWITHZEROSTOLENGTH] [int] NOT NULL,
			[NEXTVALUE] [int] NOT NULL,
			[USERESET] [int] NOT NULL,
			[LASTRESET] DATETIME NULL
		)

		Update dbo.AUTONUMBERSETTINGS 
		Set NEXTVALUE = NEXTVALUE + 1 
		Output DELETED.* INTO @NewValue
		Where dbo.AutoNumberSettings.[CLASSNAME] = @ClassName	
	
		SELECT * FROM @NewValue
	END TRY
		
	BEGIN CATCH	
		Select ERROR_MESSAGE() as ErrorMessage;
	END CATCH;
		
END
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION