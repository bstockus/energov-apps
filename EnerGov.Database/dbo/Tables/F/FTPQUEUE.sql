﻿CREATE TABLE [dbo].[FTPQUEUE] (
    [FTPQUEUEID]                CHAR (36)     NOT NULL,
    [WORKFLOWACTIONFTPID]       CHAR (36)     NULL,
    [QUERYACTIONFTPID]          CHAR (36)     NULL,
    [FILENAME]                  VARCHAR (255) NULL,
    [PROCESSEDDATE]             DATETIME      NULL,
    [CREATEDATE]                DATETIME      NOT NULL,
    [ATTACHMENTID]              CHAR (36)     NULL,
    [FTPSTATUSID]               INT           NOT NULL,
    [RPTAUTOMAILID]             CHAR (36)     NULL,
    [RPTPARAMVALUECOLLECTIONID] CHAR (36)     NULL,
    CONSTRAINT [PK_FTPQUEUE] PRIMARY KEY CLUSTERED ([FTPQUEUEID] ASC),
    CONSTRAINT [FK_FTPQUEUE_ATTACHMENT] FOREIGN KEY ([ATTACHMENTID]) REFERENCES [dbo].[ATTACHMENT] ([ATTACHMENTID]),
    CONSTRAINT [FK_FTPQUEUE_FTPSTATUS] FOREIGN KEY ([FTPSTATUSID]) REFERENCES [dbo].[FTPSTATUS] ([FTPSTATUSID]),
    CONSTRAINT [FK_FTPQUEUE_QUERYACTIONFTP] FOREIGN KEY ([QUERYACTIONFTPID]) REFERENCES [dbo].[QUERYACTIONFTP] ([QUERYACTIONFTPID]),
    CONSTRAINT [FK_FTPQUEUE_RPTAUTOMAIL] FOREIGN KEY ([RPTAUTOMAILID]) REFERENCES [dbo].[RPTAUTOMAIL] ([RPTAUTOMAILID]),
    CONSTRAINT [FK_FTPQUEUE_WORKFLOWACTIONFTP] FOREIGN KEY ([WORKFLOWACTIONFTPID]) REFERENCES [dbo].[WORKFLOWACTIONFTP] ([WORKFLOWACTIONFTPID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FTPQUEUE_RPTPARAMVALUECOLLECTIONID]
    ON [dbo].[FTPQUEUE]([RPTPARAMVALUECOLLECTIONID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FTPQUEUE_PROCESSEDDATE_FTPSTATUSID]
    ON [dbo].[FTPQUEUE]([PROCESSEDDATE] ASC, [FTPSTATUSID] ASC);
