CREATE TABLE [laxreports].[PermitPlanReviewComments]
(
	[CustomFieldId] CHAR(36) NOT NULL , 
    [CustomFieldPickListItemId] CHAR(36) NOT NULL, 
    [ReviewItemTitle] VARCHAR(MAX) NOT NULL, 
    [ReviewItemContents] VARCHAR(MAX) NOT NULL, 
    PRIMARY KEY ([CustomFieldId], [CustomFieldPickListItemId])
)
