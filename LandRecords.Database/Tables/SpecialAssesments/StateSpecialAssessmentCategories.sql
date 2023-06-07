CREATE TABLE [dbo].[StateSpecialAssessmentCategories]
(
	[Id] INT NOT NULL, 
    [StateCategory] CHAR(2) NOT NULL, 
    [StateCategoryDescription] VARCHAR(5) NOT NULL, 
	[StateClassCode] CHAR(1) NOT NULL,
    [EffectiveStartTaxYear] INT NOT NULL, 
    [EffectiveEndTaxYear] INT NOT NULL,
	CONSTRAINT [PK_StateSpecialAssessmentCategories] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_StateSpecialAssessmentCategories_StateClassCodes] FOREIGN KEY ([StateClassCode]) REFERENCES [StateClassCodes]([Code])
)
