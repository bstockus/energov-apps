﻿CREATE TABLE [dbo].[MEETINGXREF] (
    [OBJECTID]  CHAR (36)      NOT NULL,
    [MEETINGID] CHAR (36)      NOT NULL,
    [OBJECTMSG] NVARCHAR (255) NULL,
    CONSTRAINT [PK_MeetingXRef] PRIMARY KEY CLUSTERED ([OBJECTID] ASC, [MEETINGID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MeetingXRef_Meeting] FOREIGN KEY ([MEETINGID]) REFERENCES [dbo].[MEETING] ([MEETINGID])
);


GO
CREATE NONCLUSTERED INDEX [IX_MEETREF_PARENT_METNG]
    ON [dbo].[MEETINGXREF]([OBJECTID] ASC, [MEETINGID] ASC) WITH (FILLFACTOR = 90);

