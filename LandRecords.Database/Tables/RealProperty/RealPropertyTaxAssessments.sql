CREATE TABLE [dbo].[RealPropertyTaxAssessments]
(
	[PropertyInternalID] [numeric](7, 0) NOT NULL, 
    [TaxAssessmentClassCode] CHAR(3) NOT NULL, 
    [TaxationYear] NUMERIC(4) NOT NULL, 
    [Acreage] NUMERIC(7, 3) NULL, 
    [LandValue] NUMERIC(9) NULL, 
    [ImprovementValue] NUMERIC(9) NULL, 
    [AssessmentLineTotals] NUMERIC(9) NULL, 
    CONSTRAINT [PK_RealPropertyTaxAssessments] PRIMARY KEY ([PropertyInternalID], [TaxAssessmentClassCode], [TaxationYear]),
	CONSTRAINT [FK_RealPropertyTaxAssessments_RealProperties] FOREIGN KEY ([PropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID]),
	CONSTRAINT [FK_RealPropertyTaxAssessments_TaxAssessmentClassCodes] FOREIGN KEY ([TaxAssessmentClassCode]) REFERENCES [TaxAssessmentClassCodes]([TaxAssessmentClassCode])
)

GO

CREATE INDEX [IX_RealPropertyTaxAssessments_TaxationYear] ON [dbo].[RealPropertyTaxAssessments] ([TaxationYear])
