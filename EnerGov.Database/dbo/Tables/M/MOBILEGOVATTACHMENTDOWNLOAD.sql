﻿CREATE TABLE [dbo].[MOBILEGOVATTACHMENTDOWNLOAD] (
    [ATTACHMENTID] CHAR (36) NOT NULL,
    [DOWNLOADED]   BIT       DEFAULT ((0)) NULL,
    CONSTRAINT [PK_MobileGovAttachmentDownload] PRIMARY KEY CLUSTERED ([ATTACHMENTID] ASC) WITH (FILLFACTOR = 90)
);

