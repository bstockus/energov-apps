﻿CREATE TABLE [dbo].[USERFAVORITES] (
    [USERID] CHAR (36) NOT NULL,
    [FORMID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_UserFavorites] PRIMARY KEY CLUSTERED ([USERID] ASC, [FORMID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_UserFavorites_Forms] FOREIGN KEY ([FORMID]) REFERENCES [dbo].[FORMS] ([SFORMSGUID]),
    CONSTRAINT [FK_UserFavorites_Users] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

