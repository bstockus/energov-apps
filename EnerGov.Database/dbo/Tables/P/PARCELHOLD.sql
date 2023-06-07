﻿CREATE TABLE [dbo].[PARCELHOLD] (
    [PARCELHOLDID]       CHAR (36)      NOT NULL,
    [PARCELID]           CHAR (36)      NOT NULL,
    [HOLDSETUPID]        CHAR (36)      NULL,
    [ORIGIN]             CHAR (36)      NULL,
    [ORIGINNUMBER]       NVARCHAR (150) NULL,
    [SUSERGUID]          CHAR (36)      NULL,
    [COMMENTS]           NVARCHAR (MAX) NULL,
    [CREATEDDATE]        DATETIME       NULL,
    [EFFECTIVEENDDATE]   DATETIME       NULL,
    [ACTIVE]             BIT            CONSTRAINT [DF_ParcelHold_Active] DEFAULT ((1)) NOT NULL,
    [HOLDSEVERITYID]     INT            DEFAULT ((1)) NOT NULL,
    [ORIGINCMCODECASEID] CHAR (36)      NULL,
    CONSTRAINT [PK_ParcelHold] PRIMARY KEY CLUSTERED ([PARCELHOLDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ParcelHold_Hold] FOREIGN KEY ([HOLDSETUPID]) REFERENCES [dbo].[HOLDTYPESETUPS] ([HOLDSETUPID]),
    CONSTRAINT [FK_ParcelHold_HoldSeverity] FOREIGN KEY ([HOLDSEVERITYID]) REFERENCES [dbo].[HOLDSEVERITY] ([HOLDSEVERITYID]),
    CONSTRAINT [FK_ParcelHold_OriginCodeCase] FOREIGN KEY ([ORIGINCMCODECASEID]) REFERENCES [dbo].[CMCODECASE] ([CMCODECASEID]),
    CONSTRAINT [FK_ParcelHold_Parcel] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID]),
    CONSTRAINT [FK_ParcelHold_User] FOREIGN KEY ([SUSERGUID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PARCELHOLD_PARCELID]
    ON [dbo].[PARCELHOLD]([PARCELID] ASC)
    INCLUDE([PARCELHOLDID]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_PARCELHOLD_HOLDSETUPID]
    ON [dbo].[PARCELHOLD]([HOLDSETUPID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PARCELHOLD_ORIGINNUMBER]
    ON [dbo].[PARCELHOLD]([ORIGINNUMBER] ASC)
    INCLUDE([HOLDSETUPID]);


GO
CREATE NONCLUSTERED INDEX [IX_PARCELHOLDID_ORIGINCMCODECASEID]
    ON [dbo].[PARCELHOLD]([ORIGINCMCODECASEID] ASC);
