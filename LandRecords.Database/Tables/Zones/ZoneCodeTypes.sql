CREATE TABLE [dbo].[ZoneCodeTypes]
(
	[CodeType] CHAR(2) NOT NULL, 
    [Description] CHAR(25) NULL,
	CONSTRAINT [PK_ZoneCodeTypes] PRIMARY KEY ([CodeType])
)
