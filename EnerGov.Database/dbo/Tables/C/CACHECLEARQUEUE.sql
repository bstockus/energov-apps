﻿CREATE TABLE [dbo].[CACHECLEARQUEUE] (
    [CACHECLEARQUEUEID]       INT            IDENTITY (1, 1) NOT NULL,
    [CREATEDDATE]             DATETIME       NOT NULL,
    [CREATEDBYBUSINESSOBJECT] NVARCHAR (256) NOT NULL,
    [CACHECLEARAREAID]        INT            NOT NULL,
    [ADDITIONALID]            NVARCHAR (256) NULL,
    [SENTTOBUSDATE]           DATETIME       NULL,
    CONSTRAINT [PK_CACHECLEARQUEUE] PRIMARY KEY CLUSTERED ([CACHECLEARQUEUEID] ASC),
    CONSTRAINT [FK_CACHECLEARQUEUE_CACHECLEARAREA] FOREIGN KEY ([CACHECLEARAREAID]) REFERENCES [dbo].[CACHECLEARAREA] ([CACHECLEARAREAID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CHECK_CACHE]
    ON [dbo].[CACHECLEARQUEUE]([CREATEDDATE] ASC, [CACHECLEARAREAID] ASC, [ADDITIONALID] ASC);

