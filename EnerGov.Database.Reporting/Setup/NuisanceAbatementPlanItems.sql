CREATE TABLE [laxreports].[NuisanceAbatementPlanItems]
(
	[AbatementPickListItemId] CHAR(36) NOT NULL PRIMARY KEY,
	[RentalText] NVARCHAR(MAX) NULL,
	[NonRentalText] NVARCHAR(MAX) NULL,
	[CompleteBy] NVARCHAR(MAX) NOT NULL
)
