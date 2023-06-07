﻿CREATE TABLE [dbo].[RPLANDLORDLICALLOWEDACTTYPE] (
    [RPLANDLORDLICALLOWEDACTTYPEID] CHAR (36) NOT NULL,
    [RPLANDLORDLICENSETYPEID]       CHAR (36) NOT NULL,
    [RPPROPERTYACTIVITYTYPEID]      CHAR (36) NOT NULL,
    CONSTRAINT [PK_RPLANDLORDLICALLOWEDACTTYPE] PRIMARY KEY NONCLUSTERED ([RPLANDLORDLICALLOWEDACTTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPLANDLORDTYPE_TYPE] FOREIGN KEY ([RPLANDLORDLICENSETYPEID]) REFERENCES [dbo].[RPLANDLORDLICENSETYPE] ([RPLANDLORDLICENSETYPEID]),
    CONSTRAINT [FK_RPLLLICALLOW_ACTIVITYTYPE] FOREIGN KEY ([RPPROPERTYACTIVITYTYPEID]) REFERENCES [dbo].[RPPROPERTYACTIVITYTYPE] ([RPPROPERTYACTIVITYTYPEID])
);

