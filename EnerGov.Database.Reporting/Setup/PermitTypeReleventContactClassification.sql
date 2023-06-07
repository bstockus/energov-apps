CREATE TABLE [laxreports].[PermitTypeReleventContactClassification]
(
	[PermitTypeId] VARCHAR(36) NOT NULL,
    [CertificationTypeId] VARCHAR(36) NOT NULL, 
    PRIMARY KEY ([PermitTypeId], [CertificationTypeId])
)
