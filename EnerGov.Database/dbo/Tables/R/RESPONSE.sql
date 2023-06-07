﻿CREATE TABLE [dbo].[RESPONSE] (
    [RESPONSEID]       VARCHAR (36)   NOT NULL,
    [RESPONSETYPEID]   INT            NOT NULL,
    [RESPONSEENTITYID] VARCHAR (36)   NOT NULL,
    [LASTCHANGEDBY]    CHAR (36)      NOT NULL,
    [LASTCHANGEDON]    DATETIME       NOT NULL,
    [CREATEDBY]        CHAR (36)      NOT NULL,
    [CREATEDATE]       DATETIME       NOT NULL,
    [ISDELETED]        BIT            DEFAULT ((0)) NOT NULL,
    [RESPONSE]         NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([RESPONSEID] ASC),
    CONSTRAINT [FK_RESPONSE_RESPONSETYPE] FOREIGN KEY ([RESPONSETYPEID]) REFERENCES [dbo].[RESPONSETYPE] ([RESPONSETYPEID]),
    CONSTRAINT [FK_RESPONSE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_RESPONSE_USERS_CREATEDBY] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);
