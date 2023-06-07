CREATE TABLE [laxreports].[PermitTypeWorkClassInformationSelectors]
(
	[PermitTypeId] CHAR(36) NOT NULL , 
    [SelectorType] CHAR(10) NOT NULL, 
    [SelectorSortOrder] INT NOT NULL, 
    [SelectorId] CHAR(20) NOT NULL, 
    [PermitWorkClassId] CHAR(36) NOT NULL, 
    CONSTRAINT [PK_PermitTypeWorkClassInformationSelectors] PRIMARY KEY ([PermitTypeId], [SelectorType], [SelectorSortOrder], [SelectorId], [PermitWorkClassId])
)
