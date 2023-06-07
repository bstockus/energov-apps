CREATE TABLE [dbo].[IMInspectTypeAllowedInspType] (
    [IMInspectTypeAllowedInspTypeID] CHAR (36) NOT NULL,
    [IMInspectorTypeID]              CHAR (36) NOT NULL,
    [IMInspectionTypeID]             CHAR (36) NOT NULL,
    CONSTRAINT [PK_IMInspectorTypeAllowedInspe] PRIMARY KEY CLUSTERED ([IMInspectTypeAllowedInspTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IMInspectorTypeAllowedInspe] FOREIGN KEY ([IMInspectionTypeID]) REFERENCES [dbo].[IMINSPECTIONTYPE] ([IMINSPECTIONTYPEID]),
    CONSTRAINT [FK_InspTypeAllowed_InspType] FOREIGN KEY ([IMInspectorTypeID]) REFERENCES [dbo].[IMINSPECTORTYPE] ([IMINSPECTORTYPEID])
);

