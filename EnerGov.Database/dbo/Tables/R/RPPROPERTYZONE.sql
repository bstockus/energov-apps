﻿CREATE TABLE [dbo].[RPPROPERTYZONE] (
    [RPPROPERTYZONEID] CHAR (36) NOT NULL,
    [RPPROPERTYID]     CHAR (36) NOT NULL,
    [ZONEID]           CHAR (36) NOT NULL,
    [MAIN]             BIT       NOT NULL,
    CONSTRAINT [PK_RPPROPERTYZONEID] PRIMARY KEY CLUSTERED ([RPPROPERTYZONEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PROPERTYZONE_PROPERTY] FOREIGN KEY ([RPPROPERTYID]) REFERENCES [dbo].[RPPROPERTY] ([RPPROPERTYID]),
    CONSTRAINT [FK_PROPERTYZONE_ZONE] FOREIGN KEY ([ZONEID]) REFERENCES [dbo].[ZONE] ([ZONEID])
);

