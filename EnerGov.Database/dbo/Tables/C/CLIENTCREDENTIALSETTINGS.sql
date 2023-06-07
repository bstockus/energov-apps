﻿CREATE TABLE [dbo].[CLIENTCREDENTIALSETTINGS] (
    [CLIENTCREDENTIALSETTINGID] INT             IDENTITY (1, 1) NOT NULL,
    [CLIENTCREDENTIALID]        INT             NOT NULL,
    [NAME]                      NVARCHAR (200)  NOT NULL,
    [VALUE]                     NVARCHAR (4000) NULL,
    [DESCRIPTION]               NVARCHAR (MAX)  NULL,
    [LASTCHANGEDON]             DATETIME        CONSTRAINT [DF_CLIENTCREDENTIALSETTINGS_LASTCHANGEDON] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_CLIENTCREDENTIALSETTINGS_CLIENTCREDENTIALSETTINGID] PRIMARY KEY CLUSTERED ([CLIENTCREDENTIALSETTINGID] ASC),
    CONSTRAINT [FK_CLIENTCREDENTIALSETTINGS_CLIENTCREDENTIALID] FOREIGN KEY ([CLIENTCREDENTIALID]) REFERENCES [dbo].[CLIENTCREDENTIAL] ([CLIENTCREDENTIALID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_CLIENTCREDENTIALSETTINGS_CLIENTCREDENTIALID]
    ON [dbo].[CLIENTCREDENTIALSETTINGS]([CLIENTCREDENTIALID] ASC);

