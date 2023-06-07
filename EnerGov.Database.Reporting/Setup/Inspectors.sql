CREATE TABLE [laxreports].[Inspectors] (
        [CustomFieldPickListItemId] uniqueidentifier NOT NULL,
        [EmailAddress] nvarchar(255) NOT NULL,
        CONSTRAINT [PK_Inspectors] PRIMARY KEY ([CustomFieldPickListItemId])
    );