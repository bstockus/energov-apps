﻿CREATE TABLE [dbo].[CATRANSACTIONNOTE] (
    [CATRANSACTIONNOTEID] CHAR (36)      NOT NULL,
    [CATRANSACTIONID]     CHAR (36)      NOT NULL,
    [TEXT]                NVARCHAR (MAX) NULL,
    [CREATEDBY]           CHAR (36)      NULL,
    [CREATEDDATE]         DATETIME       NULL,
    [TITLE]               NVARCHAR (50)  CONSTRAINT [DF_CATRANSACTIONNOTE_TITLE] DEFAULT ('') NULL,
    [PIN]                 BIT            CONSTRAINT [DF_CATRANSACTIONNOTE_PIN] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CATRANSACTIONNOTE] PRIMARY KEY NONCLUSTERED ([CATRANSACTIONNOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CATRANSACTIONNOTE_USERS] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_TRANSACTIONNOTE_REQ] FOREIGN KEY ([CATRANSACTIONID]) REFERENCES [dbo].[CATRANSACTION] ([CATRANSACTIONID])
);


GO
CREATE NONCLUSTERED INDEX [CATRANSACTIONNOTE_CATRANSACTION]
    ON [dbo].[CATRANSACTIONNOTE]([CATRANSACTIONID] ASC);

