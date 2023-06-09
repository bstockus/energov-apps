﻿CREATE TABLE [dbo].[IPCASECONTACT] (
    [IPCASECONTACTID] CHAR (36) NOT NULL,
    [IPCASEID]        CHAR (36) NOT NULL,
    [CONTACTTYPEID]   CHAR (36) NOT NULL,
    [GLOBALENTITYID]  CHAR (36) NOT NULL,
    [ISBILLING]       BIT       NOT NULL,
    CONSTRAINT [PK_IPCASECONTACT] PRIMARY KEY CLUSTERED ([IPCASECONTACTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IPCASECONTACT_CONTACTTYPE] FOREIGN KEY ([CONTACTTYPEID]) REFERENCES [dbo].[LANDMANAGEMENTCONTACTTYPE] ([LANDMANAGEMENTCONTACTTYPEID]),
    CONSTRAINT [FK_IPCASECONTACT_GLOBALENTITY] FOREIGN KEY ([GLOBALENTITYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID]),
    CONSTRAINT [FK_IPCASECONTACT_IPCASE] FOREIGN KEY ([IPCASEID]) REFERENCES [dbo].[IPCASE] ([IPCASEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_IPCASECONTACT_GLOBALENTITY]
    ON [dbo].[IPCASECONTACT]([GLOBALENTITYID] ASC);

