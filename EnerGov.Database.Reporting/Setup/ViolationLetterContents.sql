CREATE TABLE [laxreports].[ViolationLetterContents]
(
	[CodeRevisionId] CHAR(36) NOT NULL ,
    [LetterText] NVARCHAR(MAX) NOT NULL, 
    [LetterTitle] NVARCHAR(500) NOT NULL, 
    [DepartmentHeaderId] CHAR(4) NOT NULL,
	[IncludeNotorizationInformation] BIT NULL,
	[IncludeLienHolders] BIT NULL,
	[IncludeLegalDescription] BIT NULL
    CONSTRAINT [PK_ViolationLetterContents] PRIMARY KEY ([CodeRevisionId]), 
    [OverrideSignature] CHAR(36) NULL
)
