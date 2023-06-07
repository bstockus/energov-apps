CREATE TABLE [laxreports].[PermitTypeInformationSelectors]
(
	[PermitTypeId] CHAR(36) NOT NULL , 
    [SelectorType] CHAR(10) NOT NULL, 
    [SelectorSortOrder] INT NOT NULL, 
    [SelectorId] CHAR(20) NOT NULL, 
    CONSTRAINT [PK_PermitTypeInformationSelectors] PRIMARY KEY ([PermitTypeId], [SelectorType], [SelectorSortOrder], [SelectorId]) 
)
