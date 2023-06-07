CREATE TABLE [laxreports].[PermitTypeWorkClassAdditionalInformation]
(
	[PermitTypeId] CHAR(36) NOT NULL, 
    [PermitWorkClassId] CHAR(36) NOT NULL, 
	[Title] VARCHAR(MAX) NOT NULL, 
    [Contents] VARCHAR(MAX) NOT NULL, 
    [SortOrder] INT NOT NULL, 
    CONSTRAINT [PK_PermitTypeWorkClassAdditionalInformation] PRIMARY KEY ([PermitTypeId], [PermitWorkClassId], [SortOrder])
)
