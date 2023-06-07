CREATE TABLE [laxreports].[PermitTypeDepartmentHeader]
(
	[PermitTypeId] CHAR(36) NOT NULL , 
    [DepartmentHeaderType] CHAR(4) NOT NULL, 
    [DisplaysPlanReview] BIT NULL, 
    [SignatureSectionType] CHAR(4) NULL, 
    [DisplaysRequiredInspections] BIT NULL, 
    [DisplaysSignOffs] BIT NULL, 
    [DisplaysConditions] BIT NULL, 
    [DisplaysPermitTeam] BIT NULL, 
    [ApprovalWorkflowActionId] CHAR(36) NULL, 
    [DisplaysInvoices] BIT NULL, 
    PRIMARY KEY ([PermitTypeId])
)
