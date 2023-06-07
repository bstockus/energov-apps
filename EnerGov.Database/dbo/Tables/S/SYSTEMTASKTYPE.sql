﻿CREATE TABLE [dbo].[SYSTEMTASKTYPE] (
    [SYSTEMTASKTYPEID]    INT            NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [ACTIVE]              BIT            DEFAULT ((0)) NOT NULL,
    [PROCESSTYPE]         INT            DEFAULT ((1)) NOT NULL,
    [ASSIGNTOOBJECT]      INT            NULL,
    [DEFAULTASSIGNEDTOID] CHAR (36)      NULL,
    [DAYSUNTILDUE]        INT            NULL,
    [TASKTEXT]            NVARCHAR (MAX) NULL,
    [CUSTOMNAME]          NVARCHAR (250) NULL,
    [UPDATEDBYID]         CHAR (36)      NULL,
    [UPDATEDON]           DATETIME       NULL,
    CONSTRAINT [PK_SYSTEMTASKTYPE] PRIMARY KEY CLUSTERED ([SYSTEMTASKTYPEID] ASC),
    CONSTRAINT [FK_SYSTEMTASKTYPE_ASSIGNEDTO] FOREIGN KEY ([DEFAULTASSIGNEDTOID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_SYSTEMTASKTYPE_USERS] FOREIGN KEY ([UPDATEDBYID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);

