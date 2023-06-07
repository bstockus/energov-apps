CREATE TABLE [laxreports].[InspectionZones] (
        [InspectionZoneId] uniqueidentifier NOT NULL,
        [ZoneAbbreviation] nvarchar(10) NOT NULL,
        [ZoneName] nvarchar(100) NOT NULL,
        [IsZoneEscalatable] bit NOT NULL,
        [ZoneEscalationContactEmail] nvarchar(255) NOT NULL,
        CONSTRAINT [PK_InspectionZones] PRIMARY KEY ([InspectionZoneId]),
        CONSTRAINT [AK_InspectionZones_ZoneAbbreviation] UNIQUE ([ZoneAbbreviation])
    );