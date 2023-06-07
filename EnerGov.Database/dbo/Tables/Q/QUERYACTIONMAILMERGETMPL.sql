﻿CREATE TABLE [dbo].[QUERYACTIONMAILMERGETMPL] (
    [QUERYACTIONMAILMERGETMPLID] CHAR (36) NOT NULL,
    [QUERYACTIONID]              CHAR (36) NOT NULL,
    [MAILMERGETEMPLATEID]        CHAR (36) NOT NULL,
    CONSTRAINT [PK_QUERYACTIONMAILMERGETMPL] PRIMARY KEY CLUSTERED ([QUERYACTIONMAILMERGETMPLID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_QUERYACTIONMAILTMPL_MMT] FOREIGN KEY ([MAILMERGETEMPLATEID]) REFERENCES [dbo].[MAILMERGETEMPLATE] ([MAILMERGETEMPLATEID]),
    CONSTRAINT [FK_QUERYACTIONMAILTMPL_QA] FOREIGN KEY ([QUERYACTIONID]) REFERENCES [dbo].[QUERYACTION] ([QUERYACTIONID])
);


GO
CREATE NONCLUSTERED INDEX [QUERYACTIONMAILMERGETMPL_MAILMERGETEMPLATEID]
    ON [dbo].[QUERYACTIONMAILMERGETMPL]([MAILMERGETEMPLATEID] ASC);


GO
CREATE NONCLUSTERED INDEX [QUERYACTIONMAILMERGETMPL_QUERYACTIONID]
    ON [dbo].[QUERYACTIONMAILMERGETMPL]([QUERYACTIONID] ASC);
