﻿CREATE TABLE [dbo].[AMWORKORDERTYPE] (
    [AMWORKORDERTYPEID]  CHAR (36)      NOT NULL,
    [NAME]               VARCHAR (50)   NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX) NULL,
    [SHOWADDITIONALINFO] BIT            NOT NULL,
    [SHOWASSETS]         BIT            NOT NULL,
    [SHOWTASKS]          BIT            NOT NULL,
    [SHOWRESOURCES]      BIT            NOT NULL,
    [SHOWMATERIALS]      BIT            NOT NULL,
    [SHOWEQUIPMENT]      BIT            NOT NULL,
    [DEFAULTSTATUSID]    CHAR (36)      NULL,
    [PREFIX]             NVARCHAR (10)  NULL,
    CONSTRAINT [PK_AMWorkOrderType] PRIMARY KEY CLUSTERED ([AMWORKORDERTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWOType_DefaultStatus] FOREIGN KEY ([DEFAULTSTATUSID]) REFERENCES [dbo].[AMWORKORDERSTATUS] ([AMWORKORDERSTATUSID])
);
