CREATE TABLE [dbo].[CountySpecialAssessmentCategories]
(
	[Id] INT NOT NULL, 
    [CountyCode] CHAR(2) NOT NULL, 
    [CountyCodeDescription] VARCHAR(50) NOT NULL, 
    [AbbreviationForTaxBill] VARCHAR(15) NOT NULL, 
    [EffectiveStartTaxYear] INT NOT NULL, 
    [EffectiveEndTaxYear] INT NOT NULL, 
	[StateSpecialAssessmentCategoryId] INT NOT NULL,
    CONSTRAINT [PK_CountySpecialAssessmentCategories] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_CountySpecialAssessmentCategories_StateSpecialAssessmentCategories] FOREIGN KEY ([StateSpecialAssessmentCategoryId]) REFERENCES [StateSpecialAssessmentCategories]([Id])
)
