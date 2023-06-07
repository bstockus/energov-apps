CREATE TABLE [laxreports].[PermitCustomFieldSections]
(
	[CustomFieldLayoutId] CHAR(36) NOT NULL, 
    [CustomFieldSectionType] VARCHAR(100) NOT NULL, 
    [CustomFieldSectionName] VARCHAR(100) NOT NULL, 
    [SortOrder] INT NOT NULL, 
    PRIMARY KEY ([CustomFieldLayoutId], [CustomFieldSectionType], [CustomFieldSectionName])
)
