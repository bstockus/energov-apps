CREATE TABLE [dbo].[Municipalities]
(
	[Code] INT NOT NULL, 
    [StateCode] CHAR(3) NOT NULL, 
    [Name] CHAR(25) NULL, 
    [Type] CHAR NULL,
	CONSTRAINT [PK_Municipalities] PRIMARY KEY ([Code])
)
