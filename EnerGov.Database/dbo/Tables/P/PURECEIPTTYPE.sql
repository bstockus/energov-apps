﻿CREATE TABLE [dbo].[PURECEIPTTYPE] (
    [PURECEIPTTYPEID] CHAR (36)      NOT NULL,
    [NAME]            VARCHAR (100)  NOT NULL,
    [DESCRIPTION]     NVARCHAR (MAX) NULL,
    [SYSTEMACTIONID]  CHAR (36)      NOT NULL,
    CONSTRAINT [PK_PUReceiptType] PRIMARY KEY CLUSTERED ([PURECEIPTTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PUReceiptType_SystemAction] FOREIGN KEY ([SYSTEMACTIONID]) REFERENCES [dbo].[SYSTEMACTION] ([SYSTEMACTIONID])
);

