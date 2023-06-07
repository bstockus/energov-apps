﻿CREATE TABLE [dbo].[AMENDMENTEXTBUSINESSTYPE] (
    [AMENDMENTEXTBUSINESSTYPEID] CHAR (36) NOT NULL,
    [AMENDMENTID]                CHAR (36) NOT NULL,
    [BLEXTBUSINESSTYPEID]        CHAR (36) NOT NULL,
    [MAIN]                       BIT       NOT NULL,
    CONSTRAINT [PK_AMENDMENTEXTBUSINESSTYPE] PRIMARY KEY CLUSTERED ([AMENDMENTEXTBUSINESSTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMENDMENTEXTBUSTYP_BLEXTTYP] FOREIGN KEY ([BLEXTBUSINESSTYPEID]) REFERENCES [dbo].[BLEXTBUSINESSTYPE] ([BLEXTBUSINESSTYPEID]),
    CONSTRAINT [FK_AMENDMENTEXTBUSTYPE_AMMT] FOREIGN KEY ([AMENDMENTID]) REFERENCES [dbo].[AMENDMENT] ([AMENDMENTID])
);

