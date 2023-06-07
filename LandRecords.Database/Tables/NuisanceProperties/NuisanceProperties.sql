CREATE TABLE [dbo].[NuisanceProperties]
(
	[System] NVARCHAR(10) NOT NULL, 
    [Department] NVARCHAR(255) NOT NULL, 
    [Category] NVARCHAR(255) NOT NULL, 
    [Type] NVARCHAR(255) NOT NULL, 
    [Parcel] NVARCHAR(20) NOT NULL, 
    [Date] DATETIME NOT NULL, 
    [CaseNumber] NVARCHAR(30) NULL, 
    [Description] NVARCHAR(MAX) NULL
)
