﻿CREATE TABLE [dbo].[AMENDMENT] (
    [AMENDMENTID]       CHAR (36)      NOT NULL,
    [AMENDMENTNUMBER]   NVARCHAR (50)  NOT NULL,
    [AMENDMENTTYPEID]   CHAR (36)      NOT NULL,
    [AMENDMENTSTATUSID] CHAR (36)      NOT NULL,
    [COMPLETEDATE]      DATETIME       NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AMENDMENT] PRIMARY KEY CLUSTERED ([AMENDMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMENDMENT_STATUS] FOREIGN KEY ([AMENDMENTSTATUSID]) REFERENCES [dbo].[AMENDMENTSTATUS] ([AMENDMENTSTATUSID]),
    CONSTRAINT [FK_AMENDMENT_TYPE] FOREIGN KEY ([AMENDMENTTYPEID]) REFERENCES [dbo].[AMENDMENTTYPE] ([AMENDMENTTYPEID])
);

