﻿CREATE TABLE [dbo].[CMCODEALLOWEDUSER] (
    [CMCodeAllowedUsersID] CHAR (36) NOT NULL,
    [USERID]               CHAR (36) NOT NULL,
    [CMCODEID]             CHAR (36) NOT NULL,
    CONSTRAINT [PK_CMCodeAllowedUsers] PRIMARY KEY CLUSTERED ([CMCodeAllowedUsersID] ASC) WITH (FILLFACTOR = 90)
);

