﻿CREATE TABLE [dbo].[AMWORKORDERNOTE] (
    [AMWORKORDERNOTEID] CHAR (36)      NOT NULL,
    [TEXT]              NVARCHAR (MAX) NULL,
    [AMWORKORDERID]     CHAR (36)      NOT NULL,
    [CREATEDBY]         CHAR (36)      NULL,
    [CREATEDDATE]       DATETIME       NULL,
    CONSTRAINT [PK_AMWorkOrderNote] PRIMARY KEY NONCLUSTERED ([AMWORKORDERNOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWorkOrderNote_AMWorkOrder] FOREIGN KEY ([AMWORKORDERID]) REFERENCES [dbo].[AMWORKORDER] ([AMWORKORDERID]),
    CONSTRAINT [FK_AMWorkOrderNote_Users_Creat] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_AOrderNote_OrderID]
    ON [dbo].[AMWORKORDERNOTE]([AMWORKORDERID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_OrderNote_CreatedBy]
    ON [dbo].[AMWORKORDERNOTE]([CREATEDBY] ASC) WITH (FILLFACTOR = 90);
