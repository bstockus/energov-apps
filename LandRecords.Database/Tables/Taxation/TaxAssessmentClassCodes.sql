CREATE TABLE [dbo].[TaxAssessmentClassCodes]
(
	[TaxAssessmentClassCode] CHAR(3) NOT NULL, 
    [Description] VARCHAR(50) NULL,
	CONSTRAINT [PK_TaxAssessmentClassCodes] PRIMARY KEY ([TaxAssessmentClassCode])
)
