﻿CREATE TABLE [dbo].[COLLABORATION] (
    [COLLABORATIONID] CHAR (36)      NOT NULL,
    [PLITEMREVIEWID]  CHAR (36)      NULL,
    [ERPROJECTID]     CHAR (36)      NULL,
    [SUBJECT]         NVARCHAR (255) NOT NULL,
    [MESSAGE]         NVARCHAR (MAX) NOT NULL,
    [POSTBYUSER]      CHAR (36)      NOT NULL,
    [POSTDATE]        DATETIME       NOT NULL,
    [APPLICATIONID]   INT            NOT NULL,
    [MARKREAD]        BIT            NULL,
    CONSTRAINT [PK_COLLABORATION] PRIMARY KEY CLUSTERED ([COLLABORATIONID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_COLLABORATION_APPLICATION] FOREIGN KEY ([APPLICATIONID]) REFERENCES [dbo].[APPLICATION] ([APPLICATIONID]),
    CONSTRAINT [FK_COLLABORATION_ERPROJECT] FOREIGN KEY ([ERPROJECTID]) REFERENCES [dbo].[ERPROJECT] ([ERPROJECTID]),
    CONSTRAINT [FK_COLLABORATION_PLITEMREVIEW] FOREIGN KEY ([PLITEMREVIEWID]) REFERENCES [dbo].[PLITEMREVIEW] ([PLITEMREVIEWID]),
    CONSTRAINT [FK_COLLABORATION_USERS] FOREIGN KEY ([POSTBYUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

