CREATE TABLE [laxreports].[SelectedInformations]
(
	[Id] CHAR(20) NOT NULL, 
    [Type] CHAR(10) NOT NULL, 
    [Information] NVARCHAR(MAX) NOT NULL, 
    [Title] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_SelectedInformations] PRIMARY KEY ([Id], [Type])
)
