﻿CREATE TABLE [dbo].[INSTORE] (
    [INSTOREID]           CHAR (36)        NOT NULL,
    [NAME]                VARCHAR (100)    NOT NULL,
    [DESCRIPTION]         VARCHAR (MAX)    NULL,
    [PARENTSTORE]         CHAR (36)        NULL,
    [INVENTORYISSUEPOINT] BIT              NOT NULL,
    [RECEIVINGPOINT]      BIT              NOT NULL,
    [PHONE]               VARCHAR (50)     NULL,
    [FAX]                 VARCHAR (50)     NULL,
    [MANAGER]             CHAR (36)        NULL,
    [GISX]                NUMERIC (29, 15) NULL,
    [GISY]                NUMERIC (29, 15) NULL,
    [MOBILE]              BIT              NOT NULL,
    [AMASSETID]           CHAR (36)        NULL,
    [STAGEAREA]           BIT              NOT NULL,
    [EQUIPMENTISSUEPOINT] BIT              NOT NULL,
    [MAILINGADDRESSID]    CHAR (36)        NULL,
    [ROWVERSION]          INT              NOT NULL,
    [LASTCHANGEDON]       DATETIME         NULL,
    [LASTCHANGEDBY]       CHAR (36)        NULL,
    [STORENO]             VARCHAR (50)     NOT NULL,
    CONSTRAINT [PK_INStore] PRIMARY KEY CLUSTERED ([INSTOREID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_INStore_AMAsset] FOREIGN KEY ([AMASSETID]) REFERENCES [dbo].[AMASSET] ([AMASSETID]),
    CONSTRAINT [FK_INStore_INStore] FOREIGN KEY ([PARENTSTORE]) REFERENCES [dbo].[INSTORE] ([INSTOREID]),
    CONSTRAINT [FK_INStore_MailingAddress] FOREIGN KEY ([MAILINGADDRESSID]) REFERENCES [dbo].[MAILINGADDRESS] ([MAILINGADDRESSID]),
    CONSTRAINT [FK_INStore_Users] FOREIGN KEY ([MANAGER]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_INStore_Users2] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

