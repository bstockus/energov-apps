CREATE TABLE [dbo].[NameTypes]
(
	[TypeCode] [char](2) NOT NULL,
	[Description] [char](25) NULL,
	[PrintNamePrefix] [char](6) NULL,
	[IsPrintFlag] [bit] NOT NULL,
	[IsOwner] [bit] NOT NULL, 
    CONSTRAINT [PK_NameTypes] PRIMARY KEY ([TypeCode])
)
