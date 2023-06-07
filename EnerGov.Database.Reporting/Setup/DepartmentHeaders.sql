CREATE TABLE [laxreports].[DepartmentHeaders]
(
	[Id] CHAR(4) NOT NULL PRIMARY KEY, 
    [LeftLogoType] CHAR(4) NOT NULL, 
    [RightLogoType] CHAR(4) NOT NULL, 
    [MainText] VARCHAR(MAX) NOT NULL, 
    [LeftTextLine1] VARCHAR(MAX) NOT NULL, 
    [RightTextLine1] VARCHAR(MAX) NOT NULL, 
    [SubMainText] VARCHAR(MAX) NOT NULL, 
    [LeftTextLine2] VARCHAR(MAX) NOT NULL, 
    [RightTextLine2] VARCHAR(MAX) NOT NULL
)
